#\cp -r $s/GEOSMITgcmFiles/mit_inpu\cp -r $s/GEOSMITgcmFiles/restarts-orig/* .
#\cp -r $s/GEOSMITgcmFiles/restarts-orig/* 
cp AGCM.rc AGCM.rc.Org
cp gcm_run.j gcm_run.j.Org
mv HISTORY.rc HISTORY.rc.Org
\cp /nobackupp11/afahad/GEOSMITgcmFiles/HISTORY.rc HISTORY.rc
sed -i '1,5 {s/^/#/}' HISTORY.rc
head -5 HISTORY.rc.Org | cat - HISTORY.rc > temp && \mv temp HISTORY.rc

sed -i 's|/nobackupp18/afahad|/nobackupp11/afahad|g' gcm_run.j
sed -i '1103,1109 {s/^/#/}' gcm_run.j

sed -i 's|ABCS|BCS|g' gcm_run.j
sed -i 's|OBCS|BCS|g' gcm_run.j


sed -i 's|$BCSDIR/visdf|$BCSDIR/$BCRSLV/visdf|g' gcm_run.j
sed -i 's|$BCSDIR/nirdf|$BCSDIR/$BCRSLV/nirdf|g' gcm_run.j
sed -i 's|$BCSDIR/vegdyn|$BCSDIR/$BCRSLV/vegdyn|g' gcm_run.j
sed -i 's|$BCSDIR/lai_clim|$BCSDIR/$BCRSLV/lai_clim|g' gcm_run.j
sed -i 's|$BCSDIR/green|$BCSDIR/$BCRSLV/green|g' gcm_run.j
sed -i 's|$BCSDIR/ndvi|$BCSDIR/$BCRSLV/ndvi|g' gcm_run.j

sed -i 's|$BCSDIR/topo_DYN|$BCSDIR/$BCRSLV/topo_DYN|g' gcm_run.j
sed -i 's|$BCSDIR/topo_GWD|$BCSDIR/$BCRSLV/topo_GWD|g' gcm_run.j
sed -i 's|$BCSDIR/topo_TRB|$BCSDIR/$BCRSLV/topo_TRB|g' gcm_run.j
sed -i '102 {s/^/OCEAN_DIR: mitocean_run\n/}' AGCM.rc

#sed -i '550,552 {s/^/##/}' AGCM.rc
sed -i 's|steady_state_ocean: 0|##steady_state_ocean: 1|g' AGCM.rc
sed -i 's|ROUTING_FILE|##ROUTING_FILE|g' AGCM.rc
sed -i 's/OGCM_RUN_DT: 1800/OGCM_RUN_DT: 450/g' AGCM.rc







