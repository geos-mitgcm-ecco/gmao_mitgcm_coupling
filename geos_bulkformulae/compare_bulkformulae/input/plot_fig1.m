% MITgcm Bulk Formulae Comparison
clear; clc; close all;
load BulkFormulae

% Plot Heat Fluxes vs. Air-Sea Temperature Difference
idx = find( wind_5D(:,:,:,:,1) == 7.5 & ... % wind=7.5 m/s
             sst_5D(:,:,:,:,1) >= 5   & ... % deltaT=sst-temp
             sst_5D(:,:,:,:,1) <= 25  & ... % from -10°C
            temp_5D(:,:,:,:,1) == 15 & ...  % to 10°C
              qh_5D(:,:,:,:,1) == 80);      % relative humidity 80%

clf
subplot(221)
deltaT=sst_5D(:,:,:,:,1)-temp_5D(:,:,:,:,1);
tmp=hl_5D(:,:,:,:,1);
plot(deltaT(idx),tmp(idx),'k','linewidth',8)
hold on
tmp=hl_5D(:,:,:,:,2);
plot(deltaT(idx),tmp(idx),'r','linewidth',4)
for l=3:length(labels)
    tmp=hl_5D(:,:,:,:,l);
    plot(deltaT(idx),tmp(idx),'linewidth',2)
end
grid
legend(labels,'Location','sw');
xlabel('SST $-$ ATemp ($^\circ$C)','Interpreter','latex')
ylabel('latent heat flux (W/m^2)')
title('ATemp = 15^\circC; RH = 80%; Wind = 10 m/s')

subplot(223)
tmp=hs_5D(:,:,:,:,1);
plot(deltaT(idx),tmp(idx),'k','linewidth',8)
hold on
tmp=hs_5D(:,:,:,:,2);
plot(deltaT(idx),tmp(idx),'r','linewidth',4)
for l=3:length(labels)
    tmp=hs_5D(:,:,:,:,l);
    plot(deltaT(idx),tmp(idx),'linewidth',2)
end
grid
legend(labels,'Location','sw');
xlabel('SST $-$ ATemp ($^\circ$C)','Interpreter','latex')
ylabel('sensible heat flux (W/m^2)')
title('ATemp = 15^\circC; RH = 80%; Wind = 10 m/s')

% Plot Latent Heat Flux vs. Relative Humidity
idx = find( wind_5D(:,:,:,:,1) == 7.5 & ... % wind=7.5 m/s
             sst_5D(:,:,:,:,1) == 25  & ... % sst=25°C
            temp_5D(:,:,:,:,1) == 22);      % temp=23°C
subplot(222)
RH=qh_5D(:,:,:,:,1);
tmp=hl_5D(:,:,:,:,1);
plot(RH(idx),tmp(idx),'k','linewidth',8)
hold on
tmp=hl_5D(:,:,:,:,2);
plot(RH(idx),tmp(idx),'r','linewidth',4)
for l=3:length(labels)
    tmp=hl_5D(:,:,:,:,l);
    plot(RH(idx),tmp(idx),'linewidth',2)
end
axis([20 100 -550 0])
grid
legend(labels,'Location','nw');
xlabel('relative humidity (%)')
ylabel('latent heat flux (W/m^2)')
title('SST = 25^\circC; ATemp = 22^\circC; Wind = 7.5 m/s')

% Plot stress vs. wind speed (0-50 m/)
idx = find( wind_5D(:,:,:,:,1) <= 50 & ...
             sst_5D(:,:,:,:,1) == 20 & ... % neutral conditions
            temp_5D(:,:,:,:,1) == 20 & ... % sst=temp=20°C
              qh_5D(:,:,:,:,1) == 80);     % relative humidity 80%
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
title('SST = ATemp = 20^\circC; RH = 80%')

print -dpng BulkFormulae_Fig1
