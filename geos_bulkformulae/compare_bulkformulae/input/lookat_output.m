% MITgcm Triple Bulk Formulae Sensitivity Comparison Script
clear; clc; close all;

% Define File Paths and Configuration Constants
files  = {'bulk_large_pond','bulk_yeager04','bulk_yeager09'};
labels = {'Large & Pond, 1981/82','Large & Yeager, 2004','Large & Yeager, 2009'};
Nx     = 180;         % Number of X-grid points
Ny     = 168;         % Number of Y-grid points

% Read SST input file
sst        = zeros(Nx,Ny,3);
sst(:,:,1) = readbin('SST.bin',[Nx,Ny]);
sst(:,:,2) = readbin('SST.bin',[Nx,Ny]);
sst(:,:,3) = readbin('SST.bin',[Nx,Ny]);

% Initialize 3D field structures to hold data from all 3 experiments
raw_all = zeros(Nx,Ny,6,3);
for f = 1:3
    raw_all(:,:,:,f) = readbin(files{f},[Nx,Ny,6]);
end

% Dynamically Extract the Tested Coordinate Vector values
hs   = squeeze(raw_all(:,:,1,:));               % sensible heat flux (W/m^2)
hl   = squeeze(raw_all(:,:,2,:));               % latent heat flux (W/m^2)
taux = squeeze(raw_all(:,:,3,:));               % wind stress (N/m^2)
temp = squeeze(round(raw_all(:,:,4,:)-273.15)); % air temperature (deg C)
aqh  = squeeze(raw_all(:,:,5,:));               % specific humidity (kg/kg)
wind = squeeze(raw_all(:,:,6,:));               % 10-m wind (m/s)
clear f* raw* N*

% Back-calculate Relative Humidity (%) matrix vectors from specific humidity
Ps = 1013.25;
es = 6.112 * exp((17.67 * temp) ./ (temp + 243.5));
e = (aqh * Ps) ./ (0.622 + 0.378 * aqh);
rh = round((e ./ es) * 100);                    % relative humidity (percent)
clear Ps a* e*

sst_vals  = unique(sort( sst(:)));
temp_vals = unique(sort(temp(:)));
rh_vals   = unique(sort(  rh(:)));
wind_vals = unique(sort(wind(:)));

% Reconstruct 4D Parametric Grids [SST, TEMP, RH, WIND]
% Adding a 5th dimension to store each of the three formula configurations
ns=length(sst_vals);
nt=length(temp_vals);
nr=length(rh_vals);
nw=length(wind_vals);
sensible_4D = zeros(ns, nt, nr, nw, 3);
latent_4D   = zeros(ns, nt, nr, nw, 3);
taux_4D     = zeros(ns, nt, nr, nw, 3);

for s=1:ns
    for t=1:nt
        for r=1:nr
            for w=1:nw
                ix=find(sst == sst_vals(s) & ...
                        temp==temp_vals(t) & ...
                        rh  ==  rh_vals(r) & ...
                        wind==wind_vals(w));
                sensible_4D(s,t,r,w,:)=  hs(ix);
                latent_4D(s,t,r,w,:)  =  hl(ix);
                taux_4D(s,t,r,w,:)    =taux(ix);
            end
        end
    end
end
clear h* ix r rh s sst t taux temp w wind

% Evaluate and Visualize Bulk Response Behavior
% Configure fixed index variables to examine target slices
sst_idx = find( sst_vals==20);   % Fixed SST value (20°C index position)
temp_idx= find(temp_vals==15);   % Fixed Air Temp value (15°C index position)
rh_idx  = find(  rh_vals==70);   % Fixed Relative Humidity value (70% index position)

% --- Plot 1: 1D Line Slice Profiling (Comparing all 3 Formulae) ---
figure('Color', 'w', 'Name', 'Formulation Heat Flux Comparison', 'Position', [100, 100, 1000, 450]);

% Left Side: Sensible and Latent Heat Flux
clf
subplot(1, 2, 1);
colors = {'b', 'g', 'r'};
markers = {'o', 's', '^'};
for f = 1:3
    hs_curve=squeeze(sensible_4D(sst_idx,temp_idx,rh_idx,:,f));
    hl_curve=squeeze(  latent_4D(sst_idx,temp_idx,rh_idx,:,f));
    plot(wind_vals,hs_curve,[colors{f}  '-' markers{f}],'LineWidth',  2,'DisplayName',[labels{f} ' (EXFhs)']);hold on;
    plot(wind_vals,hl_curve,[colors{f} '--' markers{f}],'LineWidth',1.5,'DisplayName',[labels{f} ' (EXFhl)']);
end
grid on
xlabel('Forcing 10-m Wind Speed (m/s)', 'FontSize', 11);
ylabel('Turbulent Heat Flux (W/m^2)', 'FontSize', 11);
title('Heat Flux Evaluation vs. Wind Speed', 'FontSize', 12);
legend('Location','sw','NumColumns', 1);

% Right Side: Zonal Wind Stress Profile
subplot(1, 2, 2);
for f = 1:3
    tx_curve=squeeze(taux_4D(sst_idx,temp_idx,rh_idx,:,f));
    plot(wind_vals,tx_curve,['-' markers{f}],'Color',colors{f},'LineWidth',2,'DisplayName',labels{f});hold on;
end
grid on
xlabel('Forcing 10-m Wind Speed (m/s)', 'FontSize', 11);
ylabel('Zonal Wind Stress \tau_x (N/m^2)', 'FontSize', 11);
title('Wind Stress Evaluation vs. Wind Speed', 'FontSize', 12);
legend('Location','nw');

sgtitle(sprintf('Bulk Formulae Comparison Slice\n(Fixed Parameters: SST = %g°C, Air Temp = %g°C, RH = %g%%)', ...
    sst_vals(sst_idx), temp_vals(temp_idx), round(rh_vals(rh_idx))), 'FontSize', 13, 'FontWeight', 'bold');


% --- Plot 2: Contour Map Evaluation (Stability Regime Divergence) ---
% Isolate a full 2D slice plane across all SSTs and Winds (holding ATEMP and RH static)
[WIND_MESH, DELTAT_MESH] = meshgrid(wind_vals, sst_vals-temp_vals(temp_idx));
figure('Color', 'w', 'Name', 'Sensible Flux Comparison Regime Map', 'Position', [100, 100, 1200, 400]);
for f = 1:3
    subplot(1, 3, f);
    hs_contour_plane = squeeze(sensible_4D(:,temp_idx,rh_idx,:,f));
    contourf(WIND_MESH,DELTAT_MESH,hs_contour_plane, 15,'LineStyle','none');
    colorbar; colormap(jet);
    xlabel('Wind Speed (m/s)', 'FontSize', 10);
    ylabel('Air-Sea Temp Delta (SST - ATEMP, °C)', 'FontSize', 10);
    title(labels{f}, 'FontSize', 12);
    grid on;
end
sgtitle('Sensible Heat Flux Regime Contour Comparison Map (W/m^2)', 'FontSize', 14, 'FontWeight', 'bold');
