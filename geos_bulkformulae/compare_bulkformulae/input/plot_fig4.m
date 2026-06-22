% MITgcm Bulk Formulae Comparison
clear; clc; close all;
load BulkFormulae

% Plot stress vs. wind speed (0-30 m/)
idx = find( wind_5D(:,:,:,:,1) <= 30 & ...
             sst_5D(:,:,:,:,1) == 15 & ... % neutral conditions
            temp_5D(:,:,:,:,1) == 15 & ... % sst=temp=20°C
              qh_5D(:,:,:,:,1) == 100);     % relative humidity 80%
clf
subplot(221)
tmp=taux_5D(:,:,:,:,1);
plot(wind_5D(idx),tmp(idx),'k','linewidth',4)
hold on
for l=2:length(labels)
    tmp=taux_5D(:,:,:,:,l);
    plot(wind_5D(idx),tmp(idx),'linewidth',2)
end
axis([0 30 0 2.5])
grid
legend(labels,'Location','nw');
xlabel('10-m wind (m/s)')
ylabel('surface stress (N/m^2)')
title('SST = ATemp = 15^\circC; RH = 100%')

% Plot Sensible Heat Flux vs. Air-Sea Temperature Difference
idx = find( wind_5D(:,:,:,:,1) ==  8  & ... % wind=8 m/s
             sst_5D(:,:,:,:,1) == 10  & ... % deltaT=temp-sst
            temp_5D(:,:,:,:,1) >=  5  & ... % from -5°C
            temp_5D(:,:,:,:,1) <= 15 & ...  % to 5°C
              qh_5D(:,:,:,:,1) == 80);      % relative humidity 80%
subplot(222)
deltaT=temp_5D(:,:,:,:,1)-sst_5D(:,:,:,:,1);
tmp=hs_5D(:,:,:,:,1);
plot(deltaT(idx),tmp(idx),'k','linewidth',8)
hold on
tmp=hs_5D(:,:,:,:,2);
plot(deltaT(idx),tmp(idx),'r','linewidth',4)
for l=3:length(labels)
    tmp=hs_5D(:,:,:,:,l);
    plot(deltaT(idx),tmp(idx),'linewidth',2)
end
axis([-5 5 -60 40])
grid
legend(labels,'Location','se');
xlabel('$\Delta T =$ Air Temp $-$ SST ($^\circ$C)','Interpreter','latex')
ylabel('sensible heat flux (W/m^2)')
title('SST = 10^\circC; RH = 80%; Wind = 8 m/s')

% Plot Latent Heat Flux vs. Wind Speed
idx = find(  sst_5D(:,:,:,:,1) == 20 & ... % sst=20°C
            temp_5D(:,:,:,:,1) == 19 & ... % temp=19°C
              qh_5D(:,:,:,:,1) == 75);     % relative humidity 75%
subplot(223)
tmp=hl_5D(:,:,:,:,1);
plot(wind_5D(idx),tmp(idx),'k','linewidth',4)
hold on
for l=2:length(labels)
    tmp=hl_5D(:,:,:,:,l);
    plot(wind_5D(idx),tmp(idx),'linewidth',2)
end
axis([0 30 -600 0])
grid
legend(labels,'Location','sw');
xlabel('10-m wind (m/s)')
ylabel('latent heat flux (W/m^2)')
title('SST = 20^\circC; Air Temp = 19^\circC; RH = 75%')

% Plot Sensible Heat Flux vs. Wind Speed
idx = find(  sst_5D(:,:,:,:,1) ==  5 & ... % sst=5°C
            temp_5D(:,:,:,:,1) ==  2 & ... % temp=2°C
              qh_5D(:,:,:,:,1) == 85);     % relative humidity 85%
subplot(224)
tmp=hs_5D(:,:,:,:,1);
plot(wind_5D(idx),tmp(idx),'k','linewidth',8)
hold on
tmp=hs_5D(:,:,:,:,2);
plot(wind_5D(idx),tmp(idx),'linewidth',4)
for l=3:length(labels)
    tmp=hs_5D(:,:,:,:,l);
    plot(wind_5D(idx),tmp(idx),'linewidth',2)
end
axis([0 30 -140 0])
grid
legend(labels,'Location','sw');
xlabel('10-m wind (m/s)')
ylabel('sensible heat flux (W/m^2)')
title('SST = 5^\circC; Air Temp = 2^\circC; RH = 85%')

print -dpng BulkFormulae_Fig4
