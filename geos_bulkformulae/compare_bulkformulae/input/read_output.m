% MITgcm Bulk Formulae Comparison
clear; clc; close all;

% Define File Paths and Configuration Constants
files  = {'bulk_large_pond','bulk_yeager04','bulk_yeager09','bulk_GEOS'};
labels = {'Large & Pond, 1981/82','Large & Yeager, 2004','Large & Yeager, 2009','GEOS BULKF'};
vars   = {'hs','hl','taux','temp','qh','wind','sst'};
Nx     = 221;         % Number of X-grid points
Ny     = 234;         % Number of Y-grid points
Nf     = length(files);
Nv     = length(vars);

% Read and repeat the 2D SST field Nf times
sst = repmat(readbin('SST.bin', [Nx, Ny]), [1, 1, Nf]);

% Read data from all experiments
raw_all = zeros(Nx,Ny,Nv-1,Nf);
for f = 1:Nf
    raw_all(:,:,:,f) = readbin(files{f},[Nx,Ny,Nv-1]);
end
for v=1:Nv-1
    eval([vars{v} '=squeeze(raw_all(:,:,v,:));']);
end
temp=round(temp-273.15);      % air temperature: Kelvin -> °C
es=6.112*exp((17.67*temp)./(temp+243.5));
e=(qh*1013.25)./(0.622+0.378*qh);
qh=round((e./es)*100);        % air humidity: kg/kg -> %
clear e* f* r* Ps

% find unique values
for v=4:Nv
    eval([vars{v} '_vals  = unique(sort(' vars{v} '(:)));']);
end

% Reconstruct 5D Parametric Grids [SST, TEMP, RH, WIND, FORMULA]
Ns=length(sst_vals);
Nt=length(temp_vals);
Nq=length(qh_vals);
Nw=length(wind_vals);
for v=1:Nv
    eval([vars{v} '_5D=zeros(Ns, Nt, Nq, Nw, Nf);']);
end
for s=1:Ns
    for t=1:Nt
        for q=1:Nq
            for w=1:Nw
                ix=find(sst == sst_vals(s) & ...
                        temp==temp_vals(t) & ...
                        qh  ==  qh_vals(q) & ...
                        wind==wind_vals(w));
                for v=1:Nv
                    eval([vars{v} '_5D(s,t,q,w,:)=' vars{v} '(ix);']);
                end
            end
        end
    end
end
for v=1:Nv
    eval(['clear ' vars{v}]);
end
clear N* ix q s t v w
save BulkFormulae
