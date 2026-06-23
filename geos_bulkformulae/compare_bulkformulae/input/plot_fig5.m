% MITgcm Bulk Formulae Comparison
clear; clc; close all;
load BulkFormulae

%%%%%%%%%%%%%%%%%%%*%
% Unstable conditions
idx = find(  sst_5D(:,:,:,:,1) == 20  & ... % sst=20°C
            temp_5D(:,:,:,:,1) == 15  & ... % temp=15°C
              qh_5D(:,:,:,:,1) == 100);     % relative humidity 75%

clf, subplot(331)
tmpg=taux_5D(:,:,:,:,4);
tmp1=taux_5D(:,:,:,:,5);
tmp2=taux_5D(:,:,:,:,6);
[AX,H1,H2]=plotyy(wind_5D(idx),100*(tmp1(idx)-tmpg(idx))./tmpg(idx), ...
                  wind_5D(idx),100*(tmp2(idx)-tmpg(idx))./tmpg(idx));
xlim(AX(1),[0 30])
xlim(AX(2),[0 30])
ylim(AX(1),[-10 0]);
ylim(AX(2),[-.04 0]);
set(AX(1),'YTick',[-10 -5 0]);
set(AX(2),'YTick',[-.04 -.02 0]);
grid(AX(2),'on')
legend('Charnok1=2.19e-3','Charnok2=-2e-8','Location','se')
xlabel('wind speed (m/s)')
xlabel('wind speed (m/s)')
ylabel(AX(1),'taux change (%)')
ylabel(AX(2),'taux change (%)')
title('unstable: SST=20^\circC, Air Temp=15^\circC, RH=75%')

subplot(334)
tmpg=hl_5D(:,:,:,:,4);
tmp1=hl_5D(:,:,:,:,5);
tmp2=hl_5D(:,:,:,:,6);
[AX,H1,H2]=plotyy(wind_5D(idx),100*(tmp1(idx)-tmpg(idx))./tmpg(idx), ...
                  wind_5D(idx),100*(tmp2(idx)-tmpg(idx))./tmpg(idx));
xlim(AX(1),[0 30])
xlim(AX(2),[0 30])
ylim(AX(1),[-3 3]);
ylim(AX(2),[-.02 .02]);
set(AX(1),'YTick',[-3 0 3]);
set(AX(2),'YTick',[-.02 0 .02]);
grid(AX(1),'on')
legend('Charnok1=2.19e-3','Charnok2=-2e-8','Location','se')
xlabel('wind speed (m/s)')
xlabel('wind speed (m/s)')
ylabel(AX(1),'latent change (%)')
ylabel(AX(2),'latent change (%)')

subplot(337)
tmpg=hs_5D(:,:,:,:,4);
tmp1=hs_5D(:,:,:,:,5);
tmp2=hs_5D(:,:,:,:,6);
[AX,H1,H2]=plotyy(wind_5D(idx),100*(tmp1(idx)-tmpg(idx))./tmpg(idx), ...
                  wind_5D(idx),100*(tmp2(idx)-tmpg(idx))./tmpg(idx));
xlim(AX(1),[0 30])
xlim(AX(2),[0 30])
ylim(AX(1),[-3 3]);
ylim(AX(2),[-.02 .02]);
set(AX(1),'YTick',[-3 0 3]);
set(AX(2),'YTick',[-.02 0 .02]);
grid(AX(1),'on')
legend('Charnok1=2.19e-3','Charnok2=-2e-8','Location','se')
xlabel('wind speed (m/s)')
xlabel('wind speed (m/s)')
ylabel(AX(1),'sensible change (%)')
ylabel(AX(2),'sensible change (%)')

%%%%%%%%%%%%%%%%%%%%
% Neutral conditions
idx = find(  sst_5D(:,:,:,:,1) == 20  & ... % sst=20°C
            temp_5D(:,:,:,:,1) == 20 & ...  % temp=20°C
              qh_5D(:,:,:,:,1) == 100);     % relative humidity 75%

subplot(332)
tmpg=taux_5D(:,:,:,:,4);
tmp1=taux_5D(:,:,:,:,5);
tmp2=taux_5D(:,:,:,:,6);
[AX,H1,H2]=plotyy(wind_5D(idx),100*(tmp1(idx)-tmpg(idx))./tmpg(idx), ...
                  wind_5D(idx),100*(tmp2(idx)-tmpg(idx))./tmpg(idx));
xlim(AX(1),[0 30])
xlim(AX(2),[0 30])
ylim(AX(1),[-10 0]);
ylim(AX(2),[-.04 0]);
set(AX(1),'YTick',[-10 -5 0]);
set(AX(2),'YTick',[-.04 -.02 0]);
grid(AX(2),'on')
legend('Charnok1=2.19e-3','Charnok2=-2e-8','Location','se')
xlabel('wind speed (m/s)')
xlabel('wind speed (m/s)')
ylabel(AX(1),'taux change (%)')
ylabel(AX(2),'taux change (%)')
title('neutral: SST=20^\circC, Air Temp=20^\circC, RH=75%')

subplot(335)
tmpg=hl_5D(:,:,:,:,4);
tmp1=hl_5D(:,:,:,:,5);
tmp2=hl_5D(:,:,:,:,6);
[AX,H1,H2]=plotyy(wind_5D(idx),100*(tmp1(idx)-tmpg(idx))./tmpg(idx), ...
                  wind_5D(idx),100*(tmp2(idx)-tmpg(idx))./tmpg(idx));
xlim(AX(1),[0 30])
xlim(AX(2),[0 30])
ylim(AX(1),[-3 3]);
ylim(AX(2),[-.02 .02]);
set(AX(1),'YTick',[-3 0 3]);
set(AX(2),'YTick',[-.02 0 .02]);
grid(AX(1),'on')
legend('Charnok1=2.19e-3','Charnok2=-2e-8','Location','se')
xlabel('wind speed (m/s)')
xlabel('wind speed (m/s)')
ylabel(AX(1),'latent change (%)')
ylabel(AX(2),'latent change (%)')

subplot(338)
tmpg=hs_5D(:,:,:,:,4);
tmp1=hs_5D(:,:,:,:,5);
tmp2=hs_5D(:,:,:,:,6);
[AX,H1,H2]=plotyy(wind_5D(idx),100*(tmp1(idx)-tmpg(idx))./tmpg(idx), ...
                  wind_5D(idx),100*(tmp2(idx)-tmpg(idx))./tmpg(idx));
xlim(AX(1),[0 30])
xlim(AX(2),[0 30])
ylim(AX(1),[-3 3]);
ylim(AX(2),[-.02 .02]);
set(AX(1),'YTick',[-3 0 3]);
set(AX(2),'YTick',[-.02 0 .02]);
grid(AX(1),'on')
legend('Charnok1=2.19e-3','Charnok2=-2e-8','Location','se')
xlabel('wind speed (m/s)')
xlabel('wind speed (m/s)')
ylabel(AX(1),'sensible change (%)')
ylabel(AX(2),'sensible change (%)')


%%%%%%%%%%%%%%%%%%%%
% Stable conditions
idx = find(  sst_5D(:,:,:,:,1) == 20  & ... % sst=20°C
            temp_5D(:,:,:,:,1) == 25 & ...  % temp=25°C
              qh_5D(:,:,:,:,1) == 100);     % relative humidity 75%

subplot(333)
tmpg=taux_5D(:,:,:,:,4);
tmp1=taux_5D(:,:,:,:,5);
tmp2=taux_5D(:,:,:,:,6);
[AX,H1,H2]=plotyy(wind_5D(idx),100*(tmp1(idx)-tmpg(idx))./tmpg(idx), ...
                  wind_5D(idx),100*(tmp2(idx)-tmpg(idx))./tmpg(idx));
xlim(AX(1),[0 30])
xlim(AX(2),[0 30])
ylim(AX(1),[-10 0]);
ylim(AX(2),[-.04 0]);
set(AX(1),'YTick',[-10 -5 0]);
set(AX(2),'YTick',[-.04 -.02 0]);
grid(AX(2),'on')
legend('Charnok1=2.19e-3','Charnok2=-2e-8','Location','se')
xlabel('wind speed (m/s)')
xlabel('wind speed (m/s)')
ylabel(AX(1),'taux change (%)')
ylabel(AX(2),'taux change (%)')
title('stable: SST=20^\circC, Air Temp=25^\circC, RH=75%')

subplot(336)
tmpg=hl_5D(:,:,:,:,4);
tmp1=hl_5D(:,:,:,:,5);
tmp2=hl_5D(:,:,:,:,6);
[AX,H1,H2]=plotyy(wind_5D(idx),100*(tmp1(idx)-tmpg(idx))./tmpg(idx), ...
                  wind_5D(idx),100*(tmp2(idx)-tmpg(idx))./tmpg(idx));
xlim(AX(1),[0 30])
xlim(AX(2),[0 30])
ylim(AX(1),[-3 3]);
ylim(AX(2),[-.02 .02]);
set(AX(1),'YTick',[-3 0 3]);
set(AX(2),'YTick',[-.02 0 .02]);
grid(AX(1),'on')
legend('Charnok1=2.19e-3','Charnok2=-2e-8','Location','se')
xlabel('wind speed (m/s)')
xlabel('wind speed (m/s)')
ylabel(AX(1),'latent change (%)')
ylabel(AX(2),'latent change (%)')

subplot(339)
tmpg=hs_5D(:,:,:,:,4);
tmp1=hs_5D(:,:,:,:,5);
tmp2=hs_5D(:,:,:,:,6);
[AX,H1,H2]=plotyy(wind_5D(idx),100*(tmp1(idx)-tmpg(idx))./tmpg(idx), ...
                  wind_5D(idx),100*(tmp2(idx)-tmpg(idx))./tmpg(idx));
xlim(AX(1),[0 30])
xlim(AX(2),[0 30])
ylim(AX(1),[-3 3]);
ylim(AX(2),[-.02 .02]);
set(AX(1),'YTick',[-3 0 3]);
set(AX(2),'YTick',[-.02 0 .02]);
grid(AX(1),'on')
legend('Charnok1=2.19e-3','Charnok2=-2e-8','Location','se')
xlabel('wind speed (m/s)')
xlabel('wind speed (m/s)')
ylabel(AX(1),'sensible change (%)')
ylabel(AX(2),'sensible change (%)')

print -dpng BulkFormulae_Fig5
