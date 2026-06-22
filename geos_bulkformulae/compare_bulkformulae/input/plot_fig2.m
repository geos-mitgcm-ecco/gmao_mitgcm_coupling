% MITgcm Bulk Formulae Comparison
clear; clc; close all;
load BulkFormulae

% Plot Heat Fluxes vs. Wind Speed
idx = find(  sst_5D(:,:,:,:,1) == 20  & ... % sst=20°C
            temp_5D(:,:,:,:,1) == 15 & ...  % temp=15°C
              qh_5D(:,:,:,:,1) == 70);      % relative humidity 70%

clf
subplot(221)
tmp=hl_5D(:,:,:,:,1);
plot(wind_5D(idx),tmp(idx),'k','linewidth',4)
hold on
for l=2:length(labels)
    tmp=hl_5D(:,:,:,:,l);
    plot(wind_5D(idx),tmp(idx),'linewidth',2)
end
axis([0 50 -2000 0])
grid
xlabel('10-m wind (m/s)')
ylabel('latent heat flux (W/m^2)')
title('SST = 20^\circC; ATemp = 15^\circC; RH = 70%')

subplot(223)
tmp=hs_5D(:,:,:,:,1);
plot(wind_5D(idx),tmp(idx),'k','linewidth',4)
hold on
for l=2:length(labels)
    tmp=hs_5D(:,:,:,:,l);
    plot(wind_5D(idx),tmp(idx),'linewidth',2)
end
axis([0 50 -700 0])
grid
legend(labels,'Location','sw');
xlabel('10-m wind (m/s)')
ylabel('sensible heat flux (W/m^2)')
title('SST = 20^\circC; ATemp = 15^\circC; RH = 70%')

% Plot Wind Stress vs. Relative Humidity
idx = find( wind_5D(:,:,:,:,1) == 30 & ... % wind=30 m/s
             sst_5D(:,:,:,:,1) == 25 & ... % sst=25°C
            temp_5D(:,:,:,:,1) == 25);     % temp=25°C
subplot(222)
RH=qh_5D(:,:,:,:,1);
tmp=taux_5D(:,:,:,:,1);
plot(RH(idx),tmp(idx),'k','linewidth',4)
hold on
for l=2:length(labels)
    tmp=taux_5D(:,:,:,:,l);
    plot(RH(idx),tmp(idx),'linewidth',2)
end
axis([20 100 2.47 2.76])
grid
xlabel('relative humidity (%)')
ylabel('wind stress (N/m^2)')
title('SST = 25^\circC; ATemp = 25^\circC; Wind = 30 m/s')

% Plot stress vs. wind speed (0-50 m/)
idx = find( wind_5D(:,:,:,:,1) <= 50 & ...
             sst_5D(:,:,:,:,1) == 20 & ... % sst=20°C
            temp_5D(:,:,:,:,1) == 15 & ... % temp=15°C
              qh_5D(:,:,:,:,1) == 70);     % relative humidity 70%
subplot(224)
tmp=taux_5D(:,:,:,:,1);
plot(wind_5D(idx),tmp(idx),'k','linewidth',4)
hold on
for l=2:length(labels)
    tmp=taux_5D(:,:,:,:,l);
    plot(wind_5D(idx),tmp(idx),'linewidth',2)
end
axis([0 50 0 12])
grid
legend(labels,'Location','nw');
xlabel('10-m wind (m/s)')
ylabel('surface stress (N/m^2)')
title('SST = 20^\circC; ATemp = 15^\circC; RH = 70%')

print -dpng BulkFormulae_Fig2
