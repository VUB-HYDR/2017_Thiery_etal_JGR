
% --------------------------------------------------------------------
% evaluation subroutine
% note: preferably run "main"
% --------------------------------------------------------------------



% --------------------------------------------------------------------
% manipulations: general
% --------------------------------------------------------------------


% get number of observational products
nprod = length(prod_names);



% --------------------------------------------------------------------
% manipulations: CESM data
% --------------------------------------------------------------------


% subset years corresponding to evaluation products
LHF_irr_8905   = nanmean(LHF_irr_ym  (:,:,find(years==1989):find(years==2005)), 3);
LHF_ctl_8905   = nanmean(LHF_ctl_ym  (:,:,find(years==1989):find(years==2005)), 3);
LHF_irr_8210   = nanmean(LHF_irr_ym  (:,:,find(years==1982):find(years==2010)), 3);
LHF_ctl_8210   = nanmean(LHF_ctl_ym  (:,:,find(years==1982):find(years==2010)), 3);
SHF_irr_8210   = nanmean(SHF_irr_ym  (:,:,find(years==1982):find(years==2010)), 3);
SHF_ctl_8210   = nanmean(SHF_ctl_ym  (:,:,find(years==1982):find(years==2010)), 3);
SWnet_irr_8407 = nanmean(SWnet_irr_ym(:,:,find(years==1984):find(years==2007)), 3);
SWnet_ctl_8407 = nanmean(SWnet_ctl_ym(:,:,find(years==1984):find(years==2007)), 3);
LWnet_irr_8407 = nanmean(LWnet_irr_ym(:,:,find(years==1984):find(years==2007)), 3);
LWnet_ctl_8407 = nanmean(LWnet_ctl_ym(:,:,find(years==1984):find(years==2007)), 3);


% subset years corresponding to evaluation products - monthly means
for i=1:12
    LHF_irr_8905_mm(:,:,i)   = nanmean(LHF_irr_mm_py  (:,:,find(years==1989)*12-(12-i):12:find(years==2005)*12), 3); %#ok<*SAGROW>
    LHF_ctl_8905_mm(:,:,i)   = nanmean(LHF_ctl_mm_py  (:,:,find(years==1989)*12-(12-i):12:find(years==2005)*12), 3);
    LHF_irr_8210_mm(:,:,i)   = nanmean(LHF_irr_mm_py  (:,:,find(years==1982)*12-(12-i):12:find(years==2010)*12), 3);
    LHF_ctl_8210_mm(:,:,i)   = nanmean(LHF_ctl_mm_py  (:,:,find(years==1982)*12-(12-i):12:find(years==2010)*12), 3);
    SHF_irr_8210_mm(:,:,i)   = nanmean(SHF_irr_mm_py  (:,:,find(years==1982)*12-(12-i):12:find(years==2010)*12), 3);
    SHF_ctl_8210_mm(:,:,i)   = nanmean(SHF_ctl_mm_py  (:,:,find(years==1982)*12-(12-i):12:find(years==2010)*12), 3);
    SWnet_irr_8407_mm(:,:,i) = nanmean(SWnet_irr_mm_py(:,:,find(years==1984)*12-(12-i):12:find(years==2007)*12), 3);
    SWnet_ctl_8407_mm(:,:,i) = nanmean(SWnet_ctl_mm_py(:,:,find(years==1984)*12-(12-i):12:find(years==2007)*12), 3);
    LWnet_irr_8407_mm(:,:,i) = nanmean(LWnet_irr_mm_py(:,:,find(years==1984)*12-(12-i):12:find(years==2007)*12), 3);
    LWnet_ctl_8407_mm(:,:,i) = nanmean(LWnet_ctl_mm_py(:,:,find(years==1984)*12-(12-i):12:find(years==2007)*12), 3);
end



% --------------------------------------------------------------------
% manipulations: spatial averaging over srex regions
% --------------------------------------------------------------------


% irrigation amounts
QIRR_srex(:,1) = mf_srex(lat_mod, lon_mod, QIRR_obs, island, [], 'WNA', 'CNA', 'MED', 'WAS', 'SAS', 'SEA', 'EAS');
QIRR_srex(:,2) = mf_srex(lat_mod, lon_mod, QIRR_irr, island, [], 'WNA', 'CNA', 'MED', 'WAS', 'SAS', 'SEA', 'EAS');
QIRR_srex(:,3) = mf_srex(lat_mod, lon_mod, QIRR_ctl, island, [], 'WNA', 'CNA', 'MED', 'WAS', 'SAS', 'SEA', 'EAS');


% irrigation amounts
if flags.offli == 1
QIRR_srex_offline(:,1) = mf_srex(lat_mod, lon_mod, QIRR_obs            , island, [], 'WNA', 'CNA', 'MED', 'WAS', 'SAS', 'SEA', 'EAS');
QIRR_srex_offline(:,2) = mf_srex(lat_mod, lon_mod, QIRR_irr_offline_w00, island, [], 'WNA', 'CNA', 'MED', 'WAS', 'SAS', 'SEA', 'EAS');
QIRR_srex_offline(:,3) = mf_srex(lat_mod, lon_mod, QIRR_irr_offline_w03, island, [], 'WNA', 'CNA', 'MED', 'WAS', 'SAS', 'SEA', 'EAS');
QIRR_srex_offline(:,4) = mf_srex(lat_mod, lon_mod, QIRR_irr_offline_w07, island, [], 'WNA', 'CNA', 'MED', 'WAS', 'SAS', 'SEA', 'EAS');
QIRR_srex_offline(:,5) = mf_srex(lat_mod, lon_mod, QIRR_irr_offline_w10, island, [], 'WNA', 'CNA', 'MED', 'WAS', 'SAS', 'SEA', 'EAS');
QIRR_srex_offline(:,6) = mf_srex(lat_mod, lon_mod, QIRR_ctl_offline    , island, [], 'WNA', 'CNA', 'MED', 'WAS', 'SAS', 'SEA', 'EAS');


% get land pixel indices - excluding Antarctica
island_2deg                     = pct_land_2deg > 50; 
island_2deg(lat_mod_2deg < -60) = 0;             % remove antarctica

QIRR_srex_offline_2deg(:,1) = mf_srex(lat_mod     , lon_mod     , QIRR_obs                 , island     , [], 'WNA', 'CNA', 'MED', 'WAS', 'SAS', 'SEA', 'EAS');
QIRR_srex_offline_2deg(:,2) = mf_srex(lat_mod_2deg, lon_mod_2deg, QIRR_irr_offline_2deg_w00, island_2deg, [], 'WNA', 'CNA', 'MED', 'WAS', 'SAS', 'SEA', 'EAS');
QIRR_srex_offline_2deg(:,3) = mf_srex(lat_mod_2deg, lon_mod_2deg, QIRR_irr_offline_2deg_w03, island_2deg, [], 'WNA', 'CNA', 'MED', 'WAS', 'SAS', 'SEA', 'EAS');
QIRR_srex_offline_2deg(:,4) = mf_srex(lat_mod_2deg, lon_mod_2deg, QIRR_irr_offline_2deg_w07, island_2deg, [], 'WNA', 'CNA', 'MED', 'WAS', 'SAS', 'SEA', 'EAS');
QIRR_srex_offline_2deg(:,5) = mf_srex(lat_mod_2deg, lon_mod_2deg, QIRR_irr_offline_2deg_w10, island_2deg, [], 'WNA', 'CNA', 'MED', 'WAS', 'SAS', 'SEA', 'EAS');
QIRR_srex_offline_2deg(:,6) = mf_srex(lat_mod_2deg, lon_mod_2deg, QIRR_ctl_offline_2deg    , island_2deg, [], 'WNA', 'CNA', 'MED', 'WAS', 'SAS', 'SEA', 'EAS');
end


% loop over months
for i=1:12


% LHF - LandFlux-EVAL
LHF_srex_lfev_mm(:,1,i) = mf_srex(lat_mod, lon_mod, LHF_lfev_8905_mm(:,:,i), island, [], 'WNA', 'CNA', 'MED', 'WAS', 'SAS', 'SEA', 'EAS');
LHF_srex_lfev_mm(:,2,i) = mf_srex(lat_mod, lon_mod, LHF_irr_8905_mm(:,:,i) , island, [], 'WNA', 'CNA', 'MED', 'WAS', 'SAS', 'SEA', 'EAS');
LHF_srex_lfev_mm(:,3,i) = mf_srex(lat_mod, lon_mod, LHF_ctl_8905_mm(:,:,i) , island, [], 'WNA', 'CNA', 'MED', 'WAS', 'SAS', 'SEA', 'EAS');


% LHF - GLEAM
LHF_srex_glea_mm(:,1,i) = mf_srex(lat_mod, lon_mod, LHF_glea_mm(:,:,i), island, [], 'WNA', 'CNA', 'MED', 'WAS', 'SAS', 'SEA', 'EAS');
LHF_srex_glea_mm(:,2,i) = mf_srex(lat_mod, lon_mod, LHF_irr_mm(:,:,i) , island, [], 'WNA', 'CNA', 'MED', 'WAS', 'SAS', 'SEA', 'EAS');
LHF_srex_glea_mm(:,3,i) = mf_srex(lat_mod, lon_mod, LHF_ctl_mm(:,:,i) , island, [], 'WNA', 'CNA', 'MED', 'WAS', 'SAS', 'SEA', 'EAS');


% LHF - mte
LHF_srex_mte_mm(:,1,i) = mf_srex(lat_mod, lon_mod, LHF_mte_8210_mm(:,:,i), island, [], 'WNA', 'CNA', 'MED', 'WAS', 'SAS', 'SEA', 'EAS');
LHF_srex_mte_mm(:,2,i) = mf_srex(lat_mod, lon_mod, LHF_irr_8210_mm(:,:,i), island, [], 'WNA', 'CNA', 'MED', 'WAS', 'SAS', 'SEA', 'EAS');
LHF_srex_mte_mm(:,3,i) = mf_srex(lat_mod, lon_mod, LHF_ctl_8210_mm(:,:,i), island, [], 'WNA', 'CNA', 'MED', 'WAS', 'SAS', 'SEA', 'EAS');


% SHF
SHF_srex_mm(:,1,i) = mf_srex(lat_mod, lon_mod, SHF_mte_8210_mm(:,:,i), island, [], 'WNA', 'CNA', 'MED', 'WAS', 'SAS', 'SEA', 'EAS');
SHF_srex_mm(:,2,i) = mf_srex(lat_mod, lon_mod, SHF_irr_8210_mm(:,:,i), island, [], 'WNA', 'CNA', 'MED', 'WAS', 'SAS', 'SEA', 'EAS');
SHF_srex_mm(:,3,i) = mf_srex(lat_mod, lon_mod, SHF_ctl_8210_mm(:,:,i), island, [], 'WNA', 'CNA', 'MED', 'WAS', 'SAS', 'SEA', 'EAS');


% SWnet
SWnet_srex_mm(:,1,i) = mf_srex(lat_mod, lon_mod, SWnet_srb_8407_mm(:,:,i), island, [], 'WNA', 'CNA', 'MED', 'WAS', 'SAS', 'SEA', 'EAS');
SWnet_srex_mm(:,2,i) = mf_srex(lat_mod, lon_mod, SWnet_irr_8407_mm(:,:,i), island, [], 'WNA', 'CNA', 'MED', 'WAS', 'SAS', 'SEA', 'EAS');
SWnet_srex_mm(:,3,i) = mf_srex(lat_mod, lon_mod, SWnet_ctl_8407_mm(:,:,i), island, [], 'WNA', 'CNA', 'MED', 'WAS', 'SAS', 'SEA', 'EAS');


% LWnet
LWnet_srex_mm(:,1,i) = mf_srex(lat_mod, lon_mod, LWnet_srb_8407_mm(:,:,i), island, [], 'WNA', 'CNA', 'MED', 'WAS', 'SAS', 'SEA', 'EAS');
LWnet_srex_mm(:,2,i) = mf_srex(lat_mod, lon_mod, LWnet_irr_8407_mm(:,:,i), island, [], 'WNA', 'CNA', 'MED', 'WAS', 'SAS', 'SEA', 'EAS');
LWnet_srex_mm(:,3,i) = mf_srex(lat_mod, lon_mod, LWnet_ctl_8407_mm(:,:,i), island, [], 'WNA', 'CNA', 'MED', 'WAS', 'SAS', 'SEA', 'EAS');


% T2M - CRU
T2M_srex(:,1,i) = mf_srex(lat_mod, lon_mod, T2M_cru_mm(:,:,i), island, [], 'WNA', 'CNA', 'MED', 'WAS', 'SAS', 'SEA', 'EAS');
T2M_srex(:,2,i) = mf_srex(lat_mod, lon_mod, T2M_irr_mm(:,:,i), island, [], 'WNA', 'CNA', 'MED', 'WAS', 'SAS', 'SEA', 'EAS');
T2M_srex(:,3,i) = mf_srex(lat_mod, lon_mod, T2M_ctl_mm(:,:,i), island, [], 'WNA', 'CNA', 'MED', 'WAS', 'SAS', 'SEA', 'EAS');


% precipitation - CRU
PRECT_srex_cru_mm(:,1,i) = mf_srex(lat_mod, lon_mod, PRECT_cru_mm(:,:,i), island, [], 'WNA', 'CNA', 'MED', 'WAS', 'SAS', 'SEA', 'EAS');
PRECT_srex_cru_mm(:,2,i) = mf_srex(lat_mod, lon_mod, PRECT_irr_mm(:,:,i), island, [], 'WNA', 'CNA', 'MED', 'WAS', 'SAS', 'SEA', 'EAS');
PRECT_srex_cru_mm(:,3,i) = mf_srex(lat_mod, lon_mod, PRECT_ctl_mm(:,:,i), island, [], 'WNA', 'CNA', 'MED', 'WAS', 'SAS', 'SEA', 'EAS');


% precipitation - GPCP
PRECT_srex_gpcp_mm(:,1,i) = mf_srex(lat_mod, lon_mod, PRECT_gpcp_mm(:,:,i), island, [], 'WNA', 'CNA', 'MED', 'WAS', 'SAS', 'SEA', 'EAS');
PRECT_srex_gpcp_mm(:,2,i) = mf_srex(lat_mod, lon_mod, PRECT_irr_mm(:,:,i) , island, [], 'WNA', 'CNA', 'MED', 'WAS', 'SAS', 'SEA', 'EAS');
PRECT_srex_gpcp_mm(:,3,i) = mf_srex(lat_mod, lon_mod, PRECT_ctl_mm(:,:,i) , island, [], 'WNA', 'CNA', 'MED', 'WAS', 'SAS', 'SEA', 'EAS');


% spatial averaging - SREX regions
% !!! this is odd here since GHCNDEX has very few data in these regions !!!
TXx_srex_ghcn_mm(:,1,i) = mf_srex(lat_mod, lon_mod, TXx_ghcn_mm(:,:,i), island, [], 'WNA', 'CNA', 'MED', 'WAS', 'SAS', 'SEA', 'EAS');
TXx_srex_ghcn_mm(:,2,i) = mf_srex(lat_mod, lon_mod, TXx_irr_mm(:,:,i) , island, [], 'WNA', 'CNA', 'MED', 'WAS', 'SAS', 'SEA', 'EAS');
TXx_srex_ghcn_mm(:,3,i) = mf_srex(lat_mod, lon_mod, TXx_ctl_mm(:,:,i) , island, [], 'WNA', 'CNA', 'MED', 'WAS', 'SAS', 'SEA', 'EAS');


% spatial averaging - SREX regions
% !!! this is odd here since Hadex2 has very few data in these regions !!!
TXx_srex_had_mm(:,1,i) = mf_srex(lat_mod, lon_mod, TXx_had_mm(:,:,i), island, [], 'WNA', 'CNA', 'MED', 'WAS', 'SAS', 'SEA', 'EAS');
TXx_srex_had_mm(:,2,i) = mf_srex(lat_mod, lon_mod, TXx_irr_mm(:,:,i), island, [], 'WNA', 'CNA', 'MED', 'WAS', 'SAS', 'SEA', 'EAS');
TXx_srex_had_mm(:,3,i) = mf_srex(lat_mod, lon_mod, TXx_ctl_mm(:,:,i), island, [], 'WNA', 'CNA', 'MED', 'WAS', 'SAS', 'SEA', 'EAS');


% spatial averaging - SREX regions
% !!! this is odd here since GHCNDEX has very few data in these regions !!!
TNn_srex_ghcn_mm(:,1,i) = mf_srex(lat_mod, lon_mod, TNn_ghcn_mm(:,:,i), island, [], 'WNA', 'CNA', 'MED', 'WAS', 'SAS', 'SEA', 'EAS');
TNn_srex_ghcn_mm(:,2,i) = mf_srex(lat_mod, lon_mod, TNn_irr_mm(:,:,i) , island, [], 'WNA', 'CNA', 'MED', 'WAS', 'SAS', 'SEA', 'EAS');
TNn_srex_ghcn_mm(:,3,i) = mf_srex(lat_mod, lon_mod, TNn_ctl_mm(:,:,i) , island, [], 'WNA', 'CNA', 'MED', 'WAS', 'SAS', 'SEA', 'EAS');


% spatial averaging - SREX regions
% !!! this is odd here since Hadex2 has very few data in these regions !!!
TNn_srex_had_mm(:,1,i) = mf_srex(lat_mod, lon_mod, TNn_had_mm(:,:,i), island, [], 'WNA', 'CNA', 'MED', 'WAS', 'SAS', 'SEA', 'EAS');
TNn_srex_had_mm(:,2,i) = mf_srex(lat_mod, lon_mod, TNn_irr_mm(:,:,i), island, [], 'WNA', 'CNA', 'MED', 'WAS', 'SAS', 'SEA', 'EAS');
TNn_srex_had_mm(:,3,i) = mf_srex(lat_mod, lon_mod, TNn_ctl_mm(:,:,i), island, [], 'WNA', 'CNA', 'MED', 'WAS', 'SAS', 'SEA', 'EAS');

end


% --------------------------------------------------------------------
% manipulations: generate added value matrix
% --------------------------------------------------------------------


% change in spatial MSE - SREX regions, global land, global irrigated land
[RMSE_irr( 1,1:nreg)] = mf_srex(lat_mod, lon_mod, (QIRR_irr       - QIRR_obs      ).^2, island, [], 'WNA', 'CNA', 'MED', 'WAS', 'SAS', 'SEA', 'EAS');
[RMSE_irr( 2,1:nreg)] = mf_srex(lat_mod, lon_mod, (LHF_irr_8905   - LHF_lfev_8905 ).^2, island, [], 'WNA', 'CNA', 'MED', 'WAS', 'SAS', 'SEA', 'EAS');
[RMSE_irr( 3,1:nreg)] = mf_srex(lat_mod, lon_mod, (LHF_irr        - LHF_glea      ).^2, island, [], 'WNA', 'CNA', 'MED', 'WAS', 'SAS', 'SEA', 'EAS');
[RMSE_irr( 4,1:nreg)] = mf_srex(lat_mod, lon_mod, (SWnet_irr_8407 - SWnet_srb_8407).^2, island, [], 'WNA', 'CNA', 'MED', 'WAS', 'SAS', 'SEA', 'EAS');
[RMSE_irr( 5,1:nreg)] = mf_srex(lat_mod, lon_mod, (LWnet_irr_8407 - LWnet_srb_8407).^2, island, [], 'WNA', 'CNA', 'MED', 'WAS', 'SAS', 'SEA', 'EAS');
[RMSE_irr( 6,1:nreg)] = mf_srex(lat_mod, lon_mod, (T2M_irr        - T2M_cru       ).^2, island, [], 'WNA', 'CNA', 'MED', 'WAS', 'SAS', 'SEA', 'EAS');
[RMSE_irr( 7,1:nreg)] = mf_srex(lat_mod, lon_mod, (PRECT_irr      - PRECT_cru     ).^2, island, [], 'WNA', 'CNA', 'MED', 'WAS', 'SAS', 'SEA', 'EAS');
[RMSE_irr( 8,1:nreg)] = mf_srex(lat_mod, lon_mod, (PRECT_irr      - PRECT_gpcp    ).^2, island, [], 'WNA', 'CNA', 'MED', 'WAS', 'SAS', 'SEA', 'EAS');
[RMSE_irr( 9,1:nreg)] = mf_srex(lat_mod, lon_mod, (TXx_irr        - TXx_ghcn      ).^2, island, [], 'WNA', 'CNA', 'MED', 'WAS', 'SAS', 'SEA', 'EAS');
[RMSE_irr(10,1:nreg)] = mf_srex(lat_mod, lon_mod, (TXx_irr        - TXx_had       ).^2, island, [], 'WNA', 'CNA', 'MED', 'WAS', 'SAS', 'SEA', 'EAS');
[RMSE_irr(11,1:nreg)] = mf_srex(lat_mod, lon_mod, (TNn_irr        - TNn_ghcn      ).^2, island, [], 'WNA', 'CNA', 'MED', 'WAS', 'SAS', 'SEA', 'EAS');
[RMSE_irr(12,1:nreg)] = mf_srex(lat_mod, lon_mod, (TNn_irr        - TNn_had       ).^2, island, [], 'WNA', 'CNA', 'MED', 'WAS', 'SAS', 'SEA', 'EAS');
[~, RMSE_irr( 1,nreg+1), RMSE_irr( 1,nreg+2)] = mf_fieldmean((QIRR_irr       - QIRR_obs      ).^2, island, isirr);
[~, RMSE_irr( 2,nreg+1), RMSE_irr( 2,nreg+2)] = mf_fieldmean((LHF_irr_8905   - LHF_lfev_8905 ).^2, island, isirr);
[~, RMSE_irr( 3,nreg+1), RMSE_irr( 3,nreg+2)] = mf_fieldmean((LHF_irr        - LHF_glea      ).^2, island, isirr);
[~, RMSE_irr( 4,nreg+1), RMSE_irr( 4,nreg+2)] = mf_fieldmean((SWnet_irr_8407 - SWnet_srb_8407).^2, island, isirr);
[~, RMSE_irr( 5,nreg+1), RMSE_irr( 5,nreg+2)] = mf_fieldmean((LWnet_irr_8407 - LWnet_srb_8407).^2, island, isirr);
[~, RMSE_irr( 6,nreg+1), RMSE_irr( 6,nreg+2)] = mf_fieldmean((T2M_irr        - T2M_cru       ).^2, island, isirr);
[~, RMSE_irr( 7,nreg+1), RMSE_irr( 7,nreg+2)] = mf_fieldmean((PRECT_irr      - PRECT_cru     ).^2, island, isirr);
[~, RMSE_irr( 8,nreg+1), RMSE_irr( 8,nreg+2)] = mf_fieldmean((PRECT_irr      - PRECT_gpcp    ).^2, island, isirr);
[~, RMSE_irr( 9,nreg+1), RMSE_irr( 9,nreg+2)] = mf_fieldmean((TXx_irr        - TXx_ghcn      ).^2, island, isirr);
[~, RMSE_irr(10,nreg+1), RMSE_irr(10,nreg+2)] = mf_fieldmean((TXx_irr        - TXx_had       ).^2, island, isirr);
[~, RMSE_irr(11,nreg+1), RMSE_irr(11,nreg+2)] = mf_fieldmean((TNn_irr        - TNn_ghcn      ).^2, island, isirr);
[~, RMSE_irr(12,nreg+1), RMSE_irr(12,nreg+2)] = mf_fieldmean((TNn_irr        - TNn_had       ).^2, island, isirr);


% change in spatial MSE - SREX regions, global land, global irrigated land
[RMSE_ctl( 1,1:nreg)] = mf_srex(lat_mod, lon_mod, (QIRR_ctl       - QIRR_obs      ).^2, island, [], 'WNA', 'CNA', 'MED', 'WAS', 'SAS', 'SEA', 'EAS');
[RMSE_ctl( 2,1:nreg)] = mf_srex(lat_mod, lon_mod, (LHF_ctl_8905   - LHF_lfev_8905 ).^2, island, [], 'WNA', 'CNA', 'MED', 'WAS', 'SAS', 'SEA', 'EAS');
[RMSE_ctl( 3,1:nreg)] = mf_srex(lat_mod, lon_mod, (LHF_ctl        - LHF_glea      ).^2, island, [], 'WNA', 'CNA', 'MED', 'WAS', 'SAS', 'SEA', 'EAS');
[RMSE_ctl( 4,1:nreg)] = mf_srex(lat_mod, lon_mod, (SWnet_ctl_8407 - SWnet_srb_8407).^2, island, [], 'WNA', 'CNA', 'MED', 'WAS', 'SAS', 'SEA', 'EAS');
[RMSE_ctl( 5,1:nreg)] = mf_srex(lat_mod, lon_mod, (LWnet_ctl_8407 - LWnet_srb_8407).^2, island, [], 'WNA', 'CNA', 'MED', 'WAS', 'SAS', 'SEA', 'EAS');
[RMSE_ctl( 6,1:nreg)] = mf_srex(lat_mod, lon_mod, (T2M_ctl        - T2M_cru       ).^2, island, [], 'WNA', 'CNA', 'MED', 'WAS', 'SAS', 'SEA', 'EAS');
[RMSE_ctl( 7,1:nreg)] = mf_srex(lat_mod, lon_mod, (PRECT_ctl      - PRECT_cru     ).^2, island, [], 'WNA', 'CNA', 'MED', 'WAS', 'SAS', 'SEA', 'EAS');
[RMSE_ctl( 8,1:nreg)] = mf_srex(lat_mod, lon_mod, (PRECT_ctl      - PRECT_gpcp    ).^2, island, [], 'WNA', 'CNA', 'MED', 'WAS', 'SAS', 'SEA', 'EAS');
[RMSE_ctl( 9,1:nreg)] = mf_srex(lat_mod, lon_mod, (TXx_ctl        - TXx_ghcn      ).^2, island, [], 'WNA', 'CNA', 'MED', 'WAS', 'SAS', 'SEA', 'EAS');
[RMSE_ctl(10,1:nreg)] = mf_srex(lat_mod, lon_mod, (TXx_ctl        - TXx_had       ).^2, island, [], 'WNA', 'CNA', 'MED', 'WAS', 'SAS', 'SEA', 'EAS');
[RMSE_ctl(11,1:nreg)] = mf_srex(lat_mod, lon_mod, (TNn_ctl        - TNn_ghcn      ).^2, island, [], 'WNA', 'CNA', 'MED', 'WAS', 'SAS', 'SEA', 'EAS');
[RMSE_ctl(12,1:nreg)] = mf_srex(lat_mod, lon_mod, (TNn_ctl        - TNn_had       ).^2, island, [], 'WNA', 'CNA', 'MED', 'WAS', 'SAS', 'SEA', 'EAS');
[~, RMSE_ctl( 1,nreg+1), RMSE_ctl( 1,nreg+2)] = mf_fieldmean((QIRR_ctl       - QIRR_obs      ).^2, island, isirr);
[~, RMSE_ctl( 2,nreg+1), RMSE_ctl( 2,nreg+2)] = mf_fieldmean((LHF_ctl_8905   - LHF_lfev_8905 ).^2, island, isirr);
[~, RMSE_ctl( 3,nreg+1), RMSE_ctl( 3,nreg+2)] = mf_fieldmean((LHF_ctl        - LHF_glea      ).^2, island, isirr);
[~, RMSE_ctl( 4,nreg+1), RMSE_ctl( 4,nreg+2)] = mf_fieldmean((SWnet_ctl_8407 - SWnet_srb_8407).^2, island, isirr);
[~, RMSE_ctl( 5,nreg+1), RMSE_ctl( 5,nreg+2)] = mf_fieldmean((LWnet_ctl_8407 - LWnet_srb_8407).^2, island, isirr);
[~, RMSE_ctl( 6,nreg+1), RMSE_ctl( 6,nreg+2)] = mf_fieldmean((T2M_ctl        - T2M_cru       ).^2, island, isirr);
[~, RMSE_ctl( 7,nreg+1), RMSE_ctl( 7,nreg+2)] = mf_fieldmean((PRECT_ctl      - PRECT_cru     ).^2, island, isirr);
[~, RMSE_ctl( 8,nreg+1), RMSE_ctl( 8,nreg+2)] = mf_fieldmean((PRECT_ctl      - PRECT_gpcp    ).^2, island, isirr);
[~, RMSE_ctl( 9,nreg+1), RMSE_ctl( 9,nreg+2)] = mf_fieldmean((TXx_ctl        - TXx_ghcn      ).^2, island, isirr);
[~, RMSE_ctl(10,nreg+1), RMSE_ctl(10,nreg+2)] = mf_fieldmean((TXx_ctl        - TXx_had       ).^2, island, isirr);
[~, RMSE_ctl(11,nreg+1), RMSE_ctl(11,nreg+2)] = mf_fieldmean((TNn_ctl        - TNn_ghcn      ).^2, island, isirr);
[~, RMSE_ctl(12,nreg+1), RMSE_ctl(12,nreg+2)] = mf_fieldmean((TNn_ctl        - TNn_had       ).^2, island, isirr);


% go from MSE to RMSE
RMSE_irr = sqrt(RMSE_irr);
RMSE_ctl = sqrt(RMSE_ctl);


% get the percentage change in RMSE
RMSE_change_perc = (RMSE_irr - RMSE_ctl) ./RMSE_ctl .* 100;



% --------------------------------------------------------------------
% manipulations: generate added value matrix - monthly means
% --------------------------------------------------------------------


% initialise matrix
RMSE_irr_mm = NaN(nprod,nreg+2);
RMSE_ctl_mm = NaN(nprod,nreg+2);


% change in spatial MSE - SREX regions, global land, global irrigated land
% % % [RMSE_irr( 1,1:nreg)] = mf_srex(lat_mod, lon_mod, (QIRR_irr_mm       - QIRR_obs_mm      ).^2, island, [], 'WNA', 'CNA', 'MED', 'WAS', 'SAS', 'SEA', 'EAS');
[RMSE_irr_mm( 2,1:nreg)] = mf_srex(lat_mod, lon_mod, (LHF_irr_8905_mm   - LHF_lfev_8905_mm ).^2, island, [], 'WNA', 'CNA', 'MED', 'WAS', 'SAS', 'SEA', 'EAS');
[RMSE_irr_mm( 3,1:nreg)] = mf_srex(lat_mod, lon_mod, (LHF_irr_mm        - LHF_glea_mm      ).^2, island, [], 'WNA', 'CNA', 'MED', 'WAS', 'SAS', 'SEA', 'EAS');
[RMSE_irr_mm( 4,1:nreg)] = mf_srex(lat_mod, lon_mod, (SWnet_irr_8407_mm - SWnet_srb_8407_mm).^2, island, [], 'WNA', 'CNA', 'MED', 'WAS', 'SAS', 'SEA', 'EAS');
[RMSE_irr_mm( 5,1:nreg)] = mf_srex(lat_mod, lon_mod, (LWnet_irr_8407_mm - LWnet_srb_8407_mm).^2, island, [], 'WNA', 'CNA', 'MED', 'WAS', 'SAS', 'SEA', 'EAS');
[RMSE_irr_mm( 6,1:nreg)] = mf_srex(lat_mod, lon_mod, (T2M_irr_mm        - T2M_cru_mm       ).^2, island, [], 'WNA', 'CNA', 'MED', 'WAS', 'SAS', 'SEA', 'EAS');
[RMSE_irr_mm( 7,1:nreg)] = mf_srex(lat_mod, lon_mod, (PRECT_irr_mm      - PRECT_cru_mm     ).^2, island, [], 'WNA', 'CNA', 'MED', 'WAS', 'SAS', 'SEA', 'EAS');
[RMSE_irr_mm( 8,1:nreg)] = mf_srex(lat_mod, lon_mod, (PRECT_irr_mm      - PRECT_gpcp_mm    ).^2, island, [], 'WNA', 'CNA', 'MED', 'WAS', 'SAS', 'SEA', 'EAS');
[RMSE_irr_mm( 9,1:nreg)] = mf_srex(lat_mod, lon_mod, (TXx_irr_mm        - TXx_ghcn_mm      ).^2, island, [], 'WNA', 'CNA', 'MED', 'WAS', 'SAS', 'SEA', 'EAS');
[RMSE_irr_mm(10,1:nreg)] = mf_srex(lat_mod, lon_mod, (TXx_irr_mm        - TXx_had_mm       ).^2, island, [], 'WNA', 'CNA', 'MED', 'WAS', 'SAS', 'SEA', 'EAS');
[RMSE_irr_mm(11,1:nreg)] = mf_srex(lat_mod, lon_mod, (TNn_irr_mm        - TNn_ghcn_mm      ).^2, island, [], 'WNA', 'CNA', 'MED', 'WAS', 'SAS', 'SEA', 'EAS');
[RMSE_irr_mm(12,1:nreg)] = mf_srex(lat_mod, lon_mod, (TNn_irr_mm        - TNn_had_mm       ).^2, island, [], 'WNA', 'CNA', 'MED', 'WAS', 'SAS', 'SEA', 'EAS');
% [~, RMSE_irr_mm( 1,nreg+1), RMSE_irr_mm( 1,nreg+2)] = mf_fieldmean(nanmean((QIRR_irr_mm       - QIRR_obs_mm      ).^2, 3), island, isirr);
[~, RMSE_irr_mm( 2,nreg+1), RMSE_irr_mm( 2,nreg+2)] = mf_fieldmean(nanmean((LHF_irr_8905_mm   - LHF_lfev_8905_mm ).^2, 3), island, isirr);
[~, RMSE_irr_mm( 3,nreg+1), RMSE_irr_mm( 3,nreg+2)] = mf_fieldmean(nanmean((LHF_irr_mm        - LHF_glea_mm      ).^2, 3), island, isirr);
[~, RMSE_irr_mm( 4,nreg+1), RMSE_irr_mm( 4,nreg+2)] = mf_fieldmean(nanmean((SWnet_irr_8407_mm - SWnet_srb_8407_mm).^2, 3), island, isirr);
[~, RMSE_irr_mm( 5,nreg+1), RMSE_irr_mm( 5,nreg+2)] = mf_fieldmean(nanmean((LWnet_irr_8407_mm - LWnet_srb_8407_mm).^2, 3), island, isirr);
[~, RMSE_irr_mm( 6,nreg+1), RMSE_irr_mm( 6,nreg+2)] = mf_fieldmean(nanmean((T2M_irr_mm        - T2M_cru_mm       ).^2, 3), island, isirr);
[~, RMSE_irr_mm( 7,nreg+1), RMSE_irr_mm( 7,nreg+2)] = mf_fieldmean(nanmean((PRECT_irr_mm      - PRECT_cru_mm     ).^2, 3), island, isirr);
[~, RMSE_irr_mm( 8,nreg+1), RMSE_irr_mm( 8,nreg+2)] = mf_fieldmean(nanmean((PRECT_irr_mm      - PRECT_gpcp_mm    ).^2, 3), island, isirr);
[~, RMSE_irr_mm( 9,nreg+1), RMSE_irr_mm( 9,nreg+2)] = mf_fieldmean(nanmean((TXx_irr_mm        - TXx_ghcn_mm      ).^2, 3), island, isirr);
[~, RMSE_irr_mm(10,nreg+1), RMSE_irr_mm(10,nreg+2)] = mf_fieldmean(nanmean((TXx_irr_mm        - TXx_had_mm       ).^2, 3), island, isirr);
[~, RMSE_irr_mm(11,nreg+1), RMSE_irr_mm(11,nreg+2)] = mf_fieldmean(nanmean((TNn_irr_mm        - TNn_ghcn_mm      ).^2, 3), island, isirr);
[~, RMSE_irr_mm(12,nreg+1), RMSE_irr_mm(12,nreg+2)] = mf_fieldmean(nanmean((TNn_irr_mm        - TNn_had_mm       ).^2, 3), island, isirr);


% change in spatial MSE - SREX regions, global land, global irrigated land
% [RMSE_ctl_mm( 1,1:nreg)] = mf_srex(lat_mod, lon_mod, (QIRR_ctl_mm       - QIRR_obs_mm      ).^2, island, [], 'WNA', 'CNA', 'MED', 'WAS', 'SAS', 'SEA', 'EAS');
[RMSE_ctl_mm( 2,1:nreg)] = mf_srex(lat_mod, lon_mod, (LHF_ctl_8905_mm   - LHF_lfev_8905_mm ).^2, island, [], 'WNA', 'CNA', 'MED', 'WAS', 'SAS', 'SEA', 'EAS');
[RMSE_ctl_mm( 3,1:nreg)] = mf_srex(lat_mod, lon_mod, (LHF_ctl_mm        - LHF_glea_mm      ).^2, island, [], 'WNA', 'CNA', 'MED', 'WAS', 'SAS', 'SEA', 'EAS');
[RMSE_ctl_mm( 4,1:nreg)] = mf_srex(lat_mod, lon_mod, (SWnet_ctl_8407_mm - SWnet_srb_8407_mm).^2, island, [], 'WNA', 'CNA', 'MED', 'WAS', 'SAS', 'SEA', 'EAS');
[RMSE_ctl_mm( 5,1:nreg)] = mf_srex(lat_mod, lon_mod, (LWnet_ctl_8407_mm - LWnet_srb_8407_mm).^2, island, [], 'WNA', 'CNA', 'MED', 'WAS', 'SAS', 'SEA', 'EAS');
[RMSE_ctl_mm( 6,1:nreg)] = mf_srex(lat_mod, lon_mod, (T2M_ctl_mm        - T2M_cru_mm       ).^2, island, [], 'WNA', 'CNA', 'MED', 'WAS', 'SAS', 'SEA', 'EAS');
[RMSE_ctl_mm( 7,1:nreg)] = mf_srex(lat_mod, lon_mod, (PRECT_ctl_mm      - PRECT_cru_mm     ).^2, island, [], 'WNA', 'CNA', 'MED', 'WAS', 'SAS', 'SEA', 'EAS');
[RMSE_ctl_mm( 8,1:nreg)] = mf_srex(lat_mod, lon_mod, (PRECT_ctl_mm      - PRECT_gpcp_mm    ).^2, island, [], 'WNA', 'CNA', 'MED', 'WAS', 'SAS', 'SEA', 'EAS');
[RMSE_ctl_mm( 9,1:nreg)] = mf_srex(lat_mod, lon_mod, (TXx_ctl_mm        - TXx_ghcn_mm      ).^2, island, [], 'WNA', 'CNA', 'MED', 'WAS', 'SAS', 'SEA', 'EAS');
[RMSE_ctl_mm(10,1:nreg)] = mf_srex(lat_mod, lon_mod, (TXx_ctl_mm        - TXx_had_mm       ).^2, island, [], 'WNA', 'CNA', 'MED', 'WAS', 'SAS', 'SEA', 'EAS');
[RMSE_ctl_mm(11,1:nreg)] = mf_srex(lat_mod, lon_mod, (TNn_ctl_mm        - TNn_ghcn_mm      ).^2, island, [], 'WNA', 'CNA', 'MED', 'WAS', 'SAS', 'SEA', 'EAS');
[RMSE_ctl_mm(12,1:nreg)] = mf_srex(lat_mod, lon_mod, (TNn_ctl_mm        - TNn_had_mm       ).^2, island, [], 'WNA', 'CNA', 'MED', 'WAS', 'SAS', 'SEA', 'EAS');
% [~, RMSE_ctl_mm( 1,nreg+1), RMSE_ctl_mm( 1,nreg+2)] = mf_fieldmean(nanmean((QIRR_ctl_mm       - QIRR_obs_mm      ).^2, 3), island, isirr);
[~, RMSE_ctl_mm( 2,nreg+1), RMSE_ctl_mm( 2,nreg+2)] = mf_fieldmean(nanmean((LHF_ctl_8905_mm   - LHF_lfev_8905_mm ).^2, 3), island, isirr);
[~, RMSE_ctl_mm( 3,nreg+1), RMSE_ctl_mm( 3,nreg+2)] = mf_fieldmean(nanmean((LHF_ctl_mm        - LHF_glea_mm      ).^2, 3), island, isirr);
[~, RMSE_ctl_mm( 4,nreg+1), RMSE_ctl_mm( 4,nreg+2)] = mf_fieldmean(nanmean((SWnet_ctl_8407_mm - SWnet_srb_8407_mm).^2, 3), island, isirr);
[~, RMSE_ctl_mm( 5,nreg+1), RMSE_ctl_mm( 5,nreg+2)] = mf_fieldmean(nanmean((LWnet_ctl_8407_mm - LWnet_srb_8407_mm).^2, 3), island, isirr);
[~, RMSE_ctl_mm( 6,nreg+1), RMSE_ctl_mm( 6,nreg+2)] = mf_fieldmean(nanmean((T2M_ctl_mm        - T2M_cru_mm       ).^2, 3), island, isirr);
[~, RMSE_ctl_mm( 7,nreg+1), RMSE_ctl_mm( 7,nreg+2)] = mf_fieldmean(nanmean((PRECT_ctl_mm      - PRECT_cru_mm     ).^2, 3), island, isirr);
[~, RMSE_ctl_mm( 8,nreg+1), RMSE_ctl_mm( 8,nreg+2)] = mf_fieldmean(nanmean((PRECT_ctl_mm      - PRECT_gpcp_mm    ).^2, 3), island, isirr);
[~, RMSE_ctl_mm( 9,nreg+1), RMSE_ctl_mm( 9,nreg+2)] = mf_fieldmean(nanmean((TXx_ctl_mm        - TXx_ghcn_mm      ).^2, 3), island, isirr);
[~, RMSE_ctl_mm(10,nreg+1), RMSE_ctl_mm(10,nreg+2)] = mf_fieldmean(nanmean((TXx_ctl_mm        - TXx_had_mm       ).^2, 3), island, isirr);
[~, RMSE_ctl_mm(11,nreg+1), RMSE_ctl_mm(11,nreg+2)] = mf_fieldmean(nanmean((TNn_ctl_mm        - TNn_ghcn_mm      ).^2, 3), island, isirr);
[~, RMSE_ctl_mm(12,nreg+1), RMSE_ctl_mm(12,nreg+2)] = mf_fieldmean(nanmean((TNn_ctl_mm        - TNn_had_mm       ).^2, 3), island, isirr);


% go from MSE to RMSE
RMSE_irr_mm = sqrt(RMSE_irr_mm);
RMSE_ctl_mm = sqrt(RMSE_ctl_mm);


% get the percentage change in RMSE
RMSE_change_perc_mm = (RMSE_irr_mm - RMSE_ctl_mm) ./RMSE_ctl_mm .* 100;

    
% since Qirr does not exist for monthly means, put annual means instead
RMSE_change_perc_mm(1,:) = RMSE_change_perc(1,:);




