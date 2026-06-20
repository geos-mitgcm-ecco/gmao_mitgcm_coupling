% Define testing values for each parameter
sst_vals  = [-2 1 5 10 15 18 20 25 28 33 35 38];               % Sea Surface Temp (°C)
temp_vals = [-40 -30 -20 -10 0  5 10 15 20 22 25 30 35 40 45]; % Air Temp (°C)
rh_vals   = [10 20 30 40 45 50 60 70 80 85 90 100];            % Relative Humidity (%)
wind_vals = [0 1 3 5 7.5 10 15 20 30 40 50 60 75 100];         % Wind speed (m/s)

% Define domain dimensions matching code/SIZE.h
Nx = length(sst_vals)*length(temp_vals);
Ny = length(rh_vals)*length(wind_vals);
disp([Nx Ny])

% Create a uniform 10-meter deep basin
bathy = -10.0 * ones(Ny, Nx);
writebin('bathy.bin',bathy);

% Initialize
SST  = zeros(Ny, Nx);
TEMP = zeros(Ny, Nx);
RH   = zeros(Ny, Nx);
WIND = zeros(Ny, Nx);

% Populate arrays
idx=0;
for s=1:length(sst_vals)
    for t=1:length(temp_vals)
        for r=1:length(rh_vals)
            for w=1:length(wind_vals)
                idx=idx+1;
                SST(idx)  =  sst_vals(s);
                TEMP(idx) = temp_vals(t);
                RH(idx)   =   rh_vals(r);
                WIND(idx) = wind_vals(w);
            end
        end
    end
end

% Convert Relative Humidity to Specific Humidity (kg/kg)
Ps = 1013.25;                                       % Standard surface pressure (hPa)
es = 6.112 * exp((17.67 * TEMP) ./ (TEMP + 243.5)); % Saturation vapor pressure (hPa)
e  = (RH / 100) .* es;                              % Vapor pressure (hPa)
AQH = (0.622 * e) ./ (Ps - (0.378 * e));            % Specific humidity (kg/kg)

% Convert air temperature to Kelvin
ATEMP = TEMP + 273.15;                              % Air temperature (Kelvin)

% Write arrays to Big-Endian Float32 binary files
writebin(  'SST.bin',   SST);
writebin('ATEMP.bin', ATEMP);
writebin('UWIND.bin',  WIND);
writebin(  'AQH.bin',   AQH);

clf
subplot(221)
pcolorcen(SST)
colorbar
title('SST')
subplot(222)
pcolorcen(ATEMP)
colorbar
title('ATEMP')
subplot(223)
pcolorcen(WIND)
colorbar
title('UWIND')
subplot(224)
pcolorcen(AQH)
colorbar
title('AQH')
