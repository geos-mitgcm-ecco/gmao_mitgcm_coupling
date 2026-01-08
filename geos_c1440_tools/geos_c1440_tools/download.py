from __future__ import annotations

import os
import time
from typing import List, Set, Tuple
from urllib.parse import urljoin, urlparse

import requests
from bs4 import BeautifulSoup

DEFAULT_UA = "Mozilla/5.0 (compatible; geos-c1440-tools/0.1)"


def _normalize_base(url: str) -> str:
    return url if url.endswith("/") else url + "/"


def _within_same_tree(base_url: str, candidate_url: str) -> bool:
    b = urlparse(base_url)
    c = urlparse(candidate_url)
    return (b.scheme, b.netloc) == (c.scheme, c.netloc) and c.path.startswith(b.path)


def _safe_mkdir(path: str) -> None:
    os.makedirs(path, exist_ok=True)


def _get_text(session: requests.Session, url: str, timeout: int, retries: int) -> str:
    last = None
    for k in range(retries + 1):
        try:
            r = session.get(url, timeout=timeout)
            r.raise_for_status()
            return r.text
        except Exception as e:
            last = e
            time.sleep(min(60, 2 ** k) + 0.25 * k)
    raise RuntimeError(f"Failed to GET {url}: {last}")


def _parse_listing_links(html: str, page_url: str) -> List[str]:
    soup = BeautifulSoup(html, "html.parser")
    out: List[str] = []
    for a in soup.find_all("a", href=True):
        href = a["href"]
        if href.startswith("#"):
            continue
        out.append(urljoin(page_url, href))
    return out


def crawl_directory(
    base_url: str,
    recursive: bool = True,
    timeout: int = 60,
    retries: int = 5,
    file_exts: Tuple[str, ...] = (".nc4", ".nc"),
    user_agent: str = DEFAULT_UA,
) -> List[str]:
    """Crawl an HTML directory listing and return file URLs."""
    base_url = _normalize_base(base_url)
    session = requests.Session()
    session.headers.update({"User-Agent": user_agent})

    seen_pages: Set[str] = set()
    queue: List[str] = [base_url]
    files: List[str] = []

    while queue:
        page = queue.pop(0)
        if page in seen_pages:
            continue
        seen_pages.add(page)

        html = _get_text(session, page, timeout=timeout, retries=retries)
        links = _parse_listing_links(html, page)

        for u in links:
            if not _within_same_tree(base_url, u):
                continue
            if u.endswith("/") and recursive:
                if u not in seen_pages:
                    queue.append(u)
                continue
            low = u.lower()
            if any(low.endswith(ext) for ext in file_exts):
                files.append(u)

    out: List[str] = []
    s = set()
    for u in files:
        if u not in s:
            s.add(u)
            out.append(u)
    return out


def url_to_relpath(base_url: str, file_url: str) -> str:
    b = urlparse(_normalize_base(base_url))
    f = urlparse(file_url)
    rel = f.path[len(b.path):].lstrip("/")
    return rel


def download_file(
    url: str,
    dest_path: str,
    session: requests.Session,
    resume: bool = True,
    timeout: int = 120,
    retries: int = 8,
    chunk_size: int = 1024 * 1024,
) -> None:
    """Download a URL to dest_path using a .part file and best-effort resume."""
    _safe_mkdir(os.path.dirname(dest_path))
    tmp = dest_path + ".part"

    if os.path.exists(dest_path) and os.path.getsize(dest_path) > 0:
        return

    headers = {}
    mode = "wb"
    if resume and os.path.exists(tmp):
        start = os.path.getsize(tmp)
        if start > 0:
            headers["Range"] = f"bytes={start}-"
            mode = "ab"

    last = None
    for k in range(retries + 1):
        try:
            with session.get(url, stream=True, headers=headers, timeout=timeout) as r:
                if headers.get("Range") and r.status_code == 200 and mode == "ab":
                    mode = "wb"
                    headers.pop("Range", None)
                    if os.path.exists(tmp):
                        os.remove(tmp)
                r.raise_for_status()
                with open(tmp, mode) as f:
                    for chunk in r.iter_content(chunk_size=chunk_size):
                        if chunk:
                            f.write(chunk)
            os.replace(tmp, dest_path)
            return
        except Exception as e:
            last = e
            time.sleep(min(60, 2 ** k) + 0.25 * k)
    raise RuntimeError(f"Failed download {url}: {last}")


def download_tree(
    base_url: str,
    out_dir: str,
    recursive: bool = True,
    resume: bool = True,
    workers: int = 4,
    timeout: int = 60,
    retries: int = 8,
    user_agent: str = DEFAULT_UA,
) -> List[str]:
    """Crawl and download all NetCDF files under base_url to out_dir preserving structure."""
    import concurrent.futures as cf

    base_url = _normalize_base(base_url)
    _safe_mkdir(out_dir)

    urls = crawl_directory(base_url, recursive=recursive, timeout=timeout, retries=retries, user_agent=user_agent)

    session = requests.Session()
    session.headers.update({"User-Agent": user_agent})

    def _job(u: str) -> str:
        rel = url_to_relpath(base_url, u)
        dest = os.path.join(out_dir, rel)
        download_file(u, dest, session=session, resume=resume, timeout=max(60, timeout), retries=retries)
        return dest

    local_paths: List[str] = []
    with cf.ThreadPoolExecutor(max_workers=workers) as ex:
        futs = [ex.submit(_job, u) for u in urls]
        for f in cf.as_completed(futs):
            local_paths.append(f.result())

    return local_paths
