% Define domain dimensions matching code/SIZE.h
Nx = 81;
Ny = 81;

% Create a uniform 10-meter deep basin
bathy = -10.0 * ones(Ny, Nx);
writebin('bathy.bin',bathy);

% 1. Define the 9 testing values for each parameter
uwind_vals = [ 0  1  3  5 10 20 30 50 100]; % Wind speed (m/s)
atemp_vals = [ 0  5 10 15 20 22 25 30  40]; % Air Temp (°C)
sst_vals   = [ 0  5 10 15 18 20 28 33  38]; % Sea Surface Temp (°C)
rh_vals    = [10 20 30 45 60 70 80 90 100]; % Relative Humidity (%)

% 2. Initialize the 81x81 arrays (Ny rows, Nx columns)
UWIND = zeros(Ny, Nx);
ATEMP = zeros(Ny, Nx);
SST   = zeros(Ny, Nx);
AQH   = zeros(Ny, Nx); % Specific humidity (kg/kg)

% Standard surface pressure (hPa) for humidity calculation
P_surf = 1013.25;

% 3. Populate arrays using matrix decomposition
% Row index (j) maps to Y-axis parameters (Wind, RH)
% Column index (i) maps to X-axis parameters (SST, Air Temp)
for j = 1:Ny
    for i = 1:Nx
        
        % X-Direction Mapping (0-indexed logic)
        idx_i = i - 1;
        val_sst   = sst_vals(mod(idx_i, 9) + 1);
        val_atemp = atemp_vals(floor(idx_i / 9) + 1);
        
        % Y-Direction Mapping (0-indexed logic)
        idx_j = j - 1;
        val_uwind = uwind_vals(mod(idx_j, 9) + 1);
        val_rh    = rh_vals(floor(idx_j / 9) + 1);
        
        % Convert Relative Humidity to Specific Humidity (kg/kg)
        % Formula: es = 6.112 * exp((17.67 * T) / (T + 243.5))
        es  = 6.112 * exp((17.67 * val_atemp) / (val_atemp + 243.5)); % Saturation vapor pressure (hPa)
        e   = (val_rh / 100) * es;                                     % Vapor pressure (hPa)
        q   = (0.622 * e) / (P_surf - (0.378 * e));                    % Specific humidity (kg/kg)
        
        % Assign values (Note: MITgcm requires ATEMP in Kelvin!)
        SST(j, i)   = val_sst;                  % °C
        ATEMP(j, i) = val_atemp + 273.15;       % Kelvin
        UWIND(j, i) = val_uwind;                % m/s
        AQH(j, i)   = q;                        % kg/kg
    end
end

% 4. Write arrays to Big-Endian Float32 binary files
writebin(  'SST.bin',   SST);
writebin('ATEMP.bin', ATEMP);
writebin('UWIND.bin', UWIND);
writebin(  'AQH.bin',   AQH);
