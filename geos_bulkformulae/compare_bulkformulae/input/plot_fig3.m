% MITgcm Bulk Formulae Comparison
clear; clc; close all;
load BulkFormulae

temp_idx= find(temp_vals==15);   % Fixed Air Temp value (15°C index position)
qh_idx  = find(  qh_vals==70);   % Fixed Relative Humidity value (70% index position)
[WIND_MESH, DELTAT_MESH] = meshgrid(wind_vals, sst_vals-temp_vals(temp_idx));

% Sensible Heat Flux Regime
clf
for f = 1:4
    subplot(2,2,f);
    hs_contour_plane = squeeze(hs_5D(:,temp_idx,qh_idx,:,f));
    contourf(WIND_MESH,DELTAT_MESH,hs_contour_plane,2000,'LineStyle','none');
    colorbar
    colormap(jet)
    axis([0 50 -15 15])
    caxis([-1 1]*600)
    xlabel('10-m wind (m/s)')
    ylabel('SST $-$ ATemp ($^\circ$C)','Interpreter','latex')
    title(labels{f});
    grid
end
sgtitle('Sensible Heat Flux Regime Contour Comparison Map (W/m^2)');
print -dpng BulkFormulae_Fig3a

% Latent Heat Flux Regime
clf
for f = 1:4
    subplot(2,2,f);
    hl_contour_plane = squeeze(hl_5D(:,temp_idx,qh_idx,:,f));
    contourf(WIND_MESH,DELTAT_MESH,hl_contour_plane,2000,'LineStyle','none');
    colorbar
    colormap(jet)
    axis([0 50 -15 15])
    caxis([-1 1]*1000)
    xlabel('10-m wind (m/s)')
    ylabel('SST $-$ ATemp ($^\circ$C)','Interpreter','latex')
    title(labels{f});
    grid
end
sgtitle('Latent Heat Flux Regime Contour Comparison Map (W/m^2)');
print -dpng BulkFormulae_Fig3b
