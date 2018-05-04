
% --------------------------------------------------------------------
% Compute values used in the paper
% note: preferably run "main"
% --------------------------------------------------------------------


% --------------------------------------------------------------------
% evaluation
% --------------------------------------------------------------------


% annual global gross irrigation amounts [km^3 yr^-1]
QIRR_irr_tot = round( nansum(nansum(QIRR_irr ./ 1E6 .* area)) ) % original QIRR_irr unit is [mm yr^-1]
QIRR_obs_tot = round( nansum(nansum(QIRR_obs ./ 1E6 .* area)) ) % original QIRR_obs unit is [mm yr^-1] - consistent with Sacks et al., 2009 (2560 km^3 yr^-1)


% annual global gross irrigation amounts [km^3 yr^-1] - standard deviation
QIRR_irr_std = nansum(nansum(QIRR_irr_ym_pe ./ 1E6 .* repmat(area, [1 1 nyears*nens]) )); % original QIRR_irr unit is [mm yr^-1]
QIRR_irr_std = round(  nanstd( squeeze(QIRR_irr_std) ) )                                  % compute std


% number of pixels for which skill improves
RMSE_change_perc_mm_ap    = round( nanmean(nanmean(RMSE_change_perc_mm)) )                         % average RMSE change
RMSE_change_perc_mm_isneg = length(find(RMSE_change_perc_mm < 0))                                  % number of elements for which skill is improving
RMSE_change_perc_mm_numel = numel(find(~isnan(RMSE_change_perc_mm)))                               % total number of elements
RMSE_change_perc_mm_isneg = round( RMSE_change_perc_mm_isneg ./ RMSE_change_perc_mm_numel .* 100 ) % percentage increase



% --------------------------------------------------------------------
% impact on means
% --------------------------------------------------------------------


% regional cooling over irrigated areas
if flags.STCD == 1
dT2m_av_srex_ip_rounded  = round( dT2m_tot_srex_ip .* 100 ) ./ 100; % mean
dT2m_min_srex_lp_rounded = round( dT2m_min_srex_lp .* 100 ) ./ 100; % max (thus take all land pixels)
end


% global land temperature change excluding Antarctica
island_noAnt          = island; island_noAnt(lat_mod < -60) = 0;
isirr_noAnt           = isirr;  isirr_noAnt (lat_mod < -60) = 0;
[~, dT2m_av_lp_noAnt] = mf_fieldmean(T2M_irr - T2M_ctl, island_noAnt); % absolute impact, all & irrigated land
dT2m_av_lp_noAnt      = round( dT2m_av_lp_noAnt .* 100 ) ./ 100



% increase in ET precentage of this increase realised over irrigated pixels [km^3 yr^-1]
dET_ap       = round( nansum( (ET_irr(:)      - ET_ctl(:)     ) ./ 1E6 .* area(:)      ) ) % original ET unit is [mm yr^-1]
dET_lp       = round( nansum( (ET_irr(island) - ET_ctl(island)) ./ 1E6 .* area(island) ) ); % original ET unit is [mm yr^-1]
dET_ip       = round( nansum( (ET_irr(isirr)  - ET_ctl(isirr) ) ./ 1E6 .* area(isirr)  ) ); % original ET unit is [mm yr^-1]
dET_percland = round( dET_lp ./ dET_ap .* 100 ) % fraction realised over land [%]
dET_percirr  = round( dET_ip ./ dET_ap .* 100 ) % fraction realised over irrigated land [%]


% irrigation induced increase in ET in other studies
dET_Sack2009 = 0.656 ./ Lvap ./ rhow;                            % [W m^-2] to [m s^-1]
dET_Sack2009 = dET_Sack2009 .* 3600 .* 24 .* 365.25;             % [m s^-1] to [m year^-1]
dET_Sack2009 = round(dET_Sack2009 ./ 1E3 .* mf_inicon('a_land')) % [m year^-1] to [km^3 year^-1]



% --------------------------------------------------------------------
% impact on extremes
% --------------------------------------------------------------------


if flags.perc == 1
% impact on T during HOT days - for TSA (i=2) and over MED (j=3)
bindiff_mean_T2M_MED     = binmean_binT_irr{2,3} - binmean_binT_ctl{2,3};
bindiff_mean_T2M_MED_Q80 = nanmean(bindiff_mean_T2M_MED(17:20));
bindiff_mean_T2M_MED_ALL = nanmean(bindiff_mean_T2M_MED);
amplification_T2M_MED    = round( bindiff_mean_T2M_MED_Q80 ./ bindiff_mean_T2M_MED_ALL .* 10 ) ./ 10 % during 20% warmest days


% impact on runoff during HOT days - for QRUNOFF (i=8) and over MED (j=3)
bindiff_mean_QRUNOFF_MED     = binmean_binT_irr{8,3} - binmean_binT_ctl{8,3};
bindiff_mean_QRUNOFF_MED_rel = bindiff_mean_QRUNOFF_MED ./ binmean_binT_ctl{8,3};
deficit_QRUNOFF_MED_fract    = round( nanmean(bindiff_mean_QRUNOFF_MED_rel(17:20)) .* 10 ) ./ 10 


% impact on runoff during DRY days - for QRUNOFF (i=8) and over SAS (j=5)
bindiff_mean_QRUNOFF_SAS     = binmean_binP_irr{8,5} - binmean_binP_ctl{8,5};
bindiff_mean_QRUNOFF_SAS_rel = bindiff_mean_QRUNOFF_SAS ./ binmean_binP_ctl{8,5};
deficit_QRUNOFF_MED_perc     = round( nanmean(bindiff_mean_QRUNOFF_SAS_rel(1:4) .* 100) .* 10 ) ./ 10 
end


% impact of irrigation on TXx on irrigated land
if flags.STCD == 1
[~, dTXx_lp, dTXx_ip] = mf_fieldmean(TXx_irr - TXx_ctl, island, isirr); % bias, CTL ensemble, all & irrigated land
[~, dTNn_lp, dTNn_ip] = mf_fieldmean(TNn_irr - TNn_ctl, island, isirr); % bias, CTL ensemble, all & irrigated land
dTXx_min_ip           = nanmin(nanmin(TXx_irr(isirr) - TXx_ctl(isirr)))
dTNn_max_ip           = nanmax(nanmax(TNn_irr(isirr) - TNn_ctl(isirr)))
amplification_TXx_lp  = round( dTXx_lp ./ dT2m_tot_lp .* 10) ./ 10
amplification_TXx_ip  = round( dTXx_ip ./ dT2m_tot_ip .* 10) ./ 10
end


% spatial differences in Water Use Efficiency (dET/Qirr)
if flags.STCD == 1 || flags.eval == 1
QIRR_srex(1,1:nreg) = mf_srex(lat_mod, lon_mod, QIRR_irr       , island, [], 'WNA', 'CNA', 'MED', 'WAS', 'SAS', 'SEA', 'EAS');
dET_srex(1,1:nreg)  = mf_srex(lat_mod, lon_mod, ET_irr - ET_ctl, island, [], 'WNA', 'CNA', 'MED', 'WAS', 'SAS', 'SEA', 'EAS');
dET_srex            = round(dET_srex .* 100) ./ 100
% dWUE_srex           = dET_srex ./ QIRR_srex .* 100;
end


% --------------------------------------------------------------------
% local versus non-local
% --------------------------------------------------------------------


% % % Get correlation between modeled and observed annual precipitation values
% % [corr_spearman_T2M_QIRR,corr_spearman_T2M_QIRR_pval] = corr((T2M_irr(:) - T2M_ctl(:)) .* -1, QIRR_irr(:), 'type','spearman', 'rows', 'pairwise');
% % corr_spearman_T2M_QIRR                               = round(corr_spearman_T2M_QIRR .* 100) ./ 100


% get spatial averages !! all irrigated pixels !!
if flags.local == 1
[~, dTS_total_ip] = mf_fieldmean(TS_irr             - TS_ctl            , pct_irr > 0); % total effect, all & irrigated land
[~, dTS_local_ip] = mf_fieldmean(TS_pft_irr(:,:,17) - TS_pft_irr(:,:,16), pct_irr > 0); % local effect, all & irrigated land
[~, dET_total_ip] = mf_fieldmean(ET_irr             - ET_ctl            , pct_irr > 0); % total effect, all & irrigated land
[~, dET_local_ip] = mf_fieldmean(ET_pft_irr(:,:,17) - ET_pft_irr(:,:,16), pct_irr > 0); % local effect, all & irrigated land
dTS_total_ip      = round(dTS_total_ip .* 100) ./ 100
dTS_local_ip      = round(dTS_local_ip .* 100) ./ 100
dET_total_ip      = round(dET_total_ip)
dET_local_ip      = round(dET_local_ip)

% now compute this for srex regions
dTS_total_srex(:,1) = mf_srex(lat_mod, lon_mod, TS_irr             - TS_ctl            , island, pct_irr > 0 , 'WNA', 'CNA', 'MED', 'WAS', 'SAS', 'SEA', 'EAS');
dTS_local_srex(:,1) = mf_srex(lat_mod, lon_mod, TS_pft_irr(:,:,17) - TS_pft_irr(:,:,16), island, pct_irr > 0 , 'WNA', 'CNA', 'MED', 'WAS', 'SAS', 'SEA', 'EAS');
dTS_total_srex      = round(dTS_total_srex .* 100) ./ 100
dTS_local_srex      = round(dTS_local_srex .* 100) ./ 100
end



% --------------------------------------------------------------------
% Discussion
% --------------------------------------------------------------------


% touch upon role of ensemble size
ms_enssize
dT2M_1m_range = round([nanmin(dT2M_1m) nanmax(dT2M_1m)] .* 100) ./ 100



% --------------------------------------------------------------------
% skill table: all land and irrigated land
% --------------------------------------------------------------------


% Biases - CTL ensemble
[~, table_skill( 1,1), table_skill( 1,3)] = mf_fieldmean(QIRR_ctl       - QIRR_obs      , island, isirr); % bias, CTL ensemble, all & irrigated land
[~, table_skill( 2,1), table_skill( 2,3)] = mf_fieldmean(LHF_ctl_8905   - LHF_lfev_8905 , island, isirr); % bias, CTL ensemble, all & irrigated land
[~, table_skill( 3,1), table_skill( 3,3)] = mf_fieldmean(LHF_ctl        - LHF_glea      , island, isirr); % bias, CTL ensemble, all & irrigated land
[~, table_skill( 4,1), table_skill( 4,3)] = mf_fieldmean(LHF_ctl_8210   - LHF_mte_8210  , island, isirr); % bias, CTL ensemble, all & irrigated land
[~, table_skill( 5,1), table_skill( 5,3)] = mf_fieldmean(SHF_ctl_8210   - SHF_mte_8210  , island, isirr); % bias, CTL ensemble, all & irrigated land
[~, table_skill( 6,1), table_skill( 6,3)] = mf_fieldmean(SWnet_ctl_8407 - SWnet_srb_8407, island, isirr); % bias, CTL ensemble, all & irrigated land
[~, table_skill( 7,1), table_skill( 7,3)] = mf_fieldmean(LWnet_ctl_8407 - LWnet_srb_8407, island, isirr); % bias, CTL ensemble, all & irrigated land
[~, table_skill( 8,1), table_skill( 8,3)] = mf_fieldmean(T2M_ctl        - T2M_cru       , island, isirr); % bias, CTL ensemble, all & irrigated land
[~, table_skill( 9,1), table_skill( 9,3)] = mf_fieldmean(PRECT_ctl      - PRECT_cru     , island, isirr); % bias, CTL ensemble, all & irrigated land
[~, table_skill(10,1), table_skill(10,3)] = mf_fieldmean(PRECT_ctl      - PRECT_gpcp    , island, isirr); % bias, CTL ensemble, all & irrigated land
[~, table_skill(11,1), table_skill(11,3)] = mf_fieldmean(TXx_ctl        - TXx_ghcn      , island, isirr); % bias, CTL ensemble, all & irrigated land
[~, table_skill(12,1), table_skill(12,3)] = mf_fieldmean(TXx_ctl        - TXx_had       , island, isirr); % bias, CTL ensemble, all & irrigated land
[~, table_skill(13,1), table_skill(13,3)] = mf_fieldmean(TNn_ctl        - TNn_ghcn      , island, isirr); % bias, CTL ensemble, all & irrigated land
[~, table_skill(14,1), table_skill(14,3)] = mf_fieldmean(TNn_ctl        - TNn_had       , island, isirr); % bias, CTL ensemble, all & irrigated land


% Biases - IRR ensemble
[~, table_skill( 1,2), table_skill( 1,4)] = mf_fieldmean(QIRR_irr       - QIRR_obs      , island, isirr); % bias, IRR ensemble, all & irrigated land
[~, table_skill( 2,2), table_skill( 2,4)] = mf_fieldmean(LHF_irr_8905   - LHF_lfev_8905 , island, isirr); % bias, IRR ensemble, all & irrigated land
[~, table_skill( 3,2), table_skill( 3,4)] = mf_fieldmean(LHF_irr        - LHF_glea      , island, isirr); % bias, IRR ensemble, all & irrigated land
[~, table_skill( 4,2), table_skill( 4,4)] = mf_fieldmean(LHF_irr_8210   - LHF_mte_8210  , island, isirr); % bias, IRR ensemble, all & irrigated land
[~, table_skill( 5,2), table_skill( 5,4)] = mf_fieldmean(SHF_irr_8210   - SHF_mte_8210  , island, isirr); % bias, IRR ensemble, all & irrigated land
[~, table_skill( 6,2), table_skill( 6,4)] = mf_fieldmean(SWnet_irr_8407 - SWnet_srb_8407, island, isirr); % bias, IRR ensemble, all & irrigated land
[~, table_skill( 7,2), table_skill( 7,4)] = mf_fieldmean(LWnet_irr_8407 - LWnet_srb_8407, island, isirr); % bias, IRR ensemble, all & irrigated land
[~, table_skill( 8,2), table_skill( 8,4)] = mf_fieldmean(T2M_irr        - T2M_cru       , island, isirr); % bias, IRR ensemble, all & irrigated land
[~, table_skill( 9,2), table_skill( 9,4)] = mf_fieldmean(PRECT_irr      - PRECT_cru     , island, isirr); % bias, IRR ensemble, all & irrigated land
[~, table_skill(10,2), table_skill(10,4)] = mf_fieldmean(PRECT_irr      - PRECT_gpcp    , island, isirr); % bias, IRR ensemble, all & irrigated land
[~, table_skill(11,2), table_skill(11,4)] = mf_fieldmean(TXx_irr        - TXx_ghcn      , island, isirr); % bias, IRR ensemble, all & irrigated land
[~, table_skill(12,2), table_skill(12,4)] = mf_fieldmean(TXx_irr        - TXx_had       , island, isirr); % bias, IRR ensemble, all & irrigated land
[~, table_skill(13,2), table_skill(13,4)] = mf_fieldmean(TNn_irr        - TNn_ghcn      , island, isirr); % bias, IRR ensemble, all & irrigated land
[~, table_skill(14,2), table_skill(14,4)] = mf_fieldmean(TNn_irr        - TNn_had       , island, isirr); % bias, IRR ensemble, all & irrigated land


% RMSE_mm is already computed in ms_evaluation
% !!! In contrast to RMSE_xxx_mm, table_skill includes Fluxnet-MTE on lines 4-5 !!!
table_skill([1:3 6:14],5) = RMSE_ctl_mm(:,8); % RMSE, CTL ensemble, all land
table_skill([1:3 6:14],6) = RMSE_irr_mm(:,8); % RMSE, IRR ensemble, all land
table_skill([1:3 6:14],7) = RMSE_ctl_mm(:,9); % RMSE, CTL ensemble, irrigated land
table_skill([1:3 6:14],8) = RMSE_irr_mm(:,9); % RMSE, IRR ensemble, irrigated land

% compute RMSE for Fluxnet-MTE separately
[~, table_skill(4, 5), table_skill(4, 7)] = mf_fieldmean(nanmean((LHF_ctl_8210_mm - LHF_mte_8210_mm).^2, 3), island, isirr);
[~, table_skill(4, 6), table_skill(4, 8)] = mf_fieldmean(nanmean((LHF_irr_8210_mm - LHF_mte_8210_mm).^2, 3), island, isirr);
[~, table_skill(5, 5), table_skill(5, 7)] = mf_fieldmean(nanmean((SHF_ctl_8210_mm - SHF_mte_8210_mm).^2, 3), island, isirr);
[~, table_skill(5, 6), table_skill(5, 8)] = mf_fieldmean(nanmean((SHF_irr_8210_mm - SHF_mte_8210_mm).^2, 3), island, isirr);
table_skill(4:5, 5:8) = sqrt(table_skill(4:5, 5:8));


% RMSE for QIRRIG: take it from RMSE instead of RMSE_mm
table_skill(1,5) = RMSE_ctl(1,8); % RMSE, CTL ensemble, all land
table_skill(1,6) = RMSE_irr(1,8); % RMSE, IRR ensemble, all land
table_skill(1,7) = RMSE_ctl(1,9); % RMSE, CTL ensemble, irrigated land
table_skill(1,8) = RMSE_irr(1,9); % RMSE, IRR ensemble, irrigated land


% rounding
table_skill(1:7,:)       = round(table_skill(1:7,:) .* 10) /10;
table_skill(9:10,:)      = round(table_skill(9:10,:));
table_skill([8 11:14],:) = round(table_skill([8 11:14],:) .* 100) /100;



% --------------------------------------------------------------------
% impact table: all land and irrigated land
% --------------------------------------------------------------------


% irrigation impacts - absolute effects
if flags.STCD == 1
[~, table_impact( 1,1), table_impact( 1,3)] = mf_fieldmean(T2M_irr   - T2M_ctl  , island, isirr); % absolute impact, all & irrigated land
[~, table_impact( 2,1), table_impact( 2,3)] = mf_fieldmean(PRECT_irr - PRECT_ctl, island, isirr); % absolute impact, all & irrigated land
[~, table_impact( 3,1), table_impact( 3,3)] = mf_fieldmean(ET_irr    - ET_ctl   , island, isirr); % absolute impact, all & irrigated land
[~, table_impact( 4,1), table_impact( 4,3)] = mf_fieldmean(TS_irr    - TS_ctl   , island, isirr); % absolute impact, all & irrigated land
[~, table_impact( 5,1), table_impact( 5,3)] = mf_fieldmean(SWnet_irr - SWnet_ctl, island, isirr); % absolute impact, all & irrigated land
[~, table_impact( 6,1), table_impact( 6,3)] = mf_fieldmean(LWnet_irr - LWnet_ctl, island, isirr); % absolute impact, all & irrigated land
[~, table_impact( 7,1), table_impact( 7,3)] = mf_fieldmean(LHF_irr   - LHF_ctl  , island, isirr); % absolute impact, all & irrigated land
[~, table_impact( 8,1), table_impact( 8,3)] = mf_fieldmean(SHF_irr   - SHF_ctl  , island, isirr); % absolute impact, all & irrigated land
[~, table_impact( 9,1), table_impact( 9,3)] = mf_fieldmean(PSL_irr   - PSL_ctl  , island, isirr); % absolute impact, all & irrigated land
[~, table_impact(10,1), table_impact(10,3)] = mf_fieldmean(TXx_irr   - TXx_ctl  , island, isirr); % absolute impact, all & irrigated land
[~, table_impact(11,1), table_impact(11,3)] = mf_fieldmean(TNn_irr   - TNn_ctl  , island, isirr); % absolute impact, all & irrigated land
[~, table_impact(12,1), table_impact(12,3)] = mf_fieldmean(CDD_irr   - CDD_ctl  , island, isirr); % absolute impact, all & irrigated land
[~, table_impact(13,1), table_impact(13,3)] = mf_fieldmean(HWDI_irr  - HWDI_ctl , island, isirr); % absolute impact, all & irrigated land


% irrigation impacts - relative effects
[~, table_impact( 1,2), table_impact( 1,4)] = mf_fieldmean( (T2M_irr   - T2M_ctl  ) ./ T2M_ctl   .* 100, island, isirr); % relative impact, all & irrigated land
[~, table_impact( 2,2), table_impact( 2,4)] = mf_fieldmean( (PRECT_irr - PRECT_ctl) ./ PRECT_ctl .* 100, island, isirr); % relative impact, all & irrigated land
[~, table_impact( 3,2), table_impact( 3,4)] = mf_fieldmean( (ET_irr    - ET_ctl   ) ./ ET_ctl    .* 100, island, isirr); % relative impact, all & irrigated land
[~, table_impact( 4,2), table_impact( 4,4)] = mf_fieldmean( (TS_irr    - TS_ctl   ) ./ TS_ctl    .* 100, island, isirr); % relative impact, all & irrigated land
[~, table_impact( 5,2), table_impact( 5,4)] = mf_fieldmean( (SWnet_irr - SWnet_ctl) ./ SWnet_ctl .* 100, island, isirr); % relative impact, all & irrigated land
[~, table_impact( 6,2), table_impact( 6,4)] = mf_fieldmean( (LWnet_irr - LWnet_ctl) ./ LWnet_ctl .* 100, island, isirr); % relative impact, all & irrigated land
[~, table_impact( 7,2), table_impact( 7,4)] = mf_fieldmean( (LHF_irr   - LHF_ctl  ) ./ LHF_ctl   .* 100, island, isirr); % relative impact, all & irrigated land
[~, table_impact( 8,2), table_impact( 8,4)] = mf_fieldmean( (SHF_irr   - SHF_ctl  ) ./ SHF_ctl   .* 100, island, isirr); % relative impact, all & irrigated land
[~, table_impact( 9,2), table_impact( 9,4)] = mf_fieldmean( (PSL_irr   - PSL_ctl  ) ./ PSL_ctl   .* 100, island, isirr); % relative impact, all & irrigated land
[~, table_impact(10,2), table_impact(10,4)] = mf_fieldmean( (TXx_irr   - TXx_ctl  ) ./ TXx_ctl   .* 100, island, isirr); % relative impact, all & irrigated land
[~, table_impact(11,2), table_impact(11,4)] = mf_fieldmean( (TNn_irr   - TNn_ctl  ) ./ TNn_ctl   .* 100, island, isirr); % relative impact, all & irrigated land
[~, table_impact(12,2), table_impact(12,4)] = mf_fieldmean( (CDD_irr   - CDD_ctl  ) ./ CDD_ctl   .* 100, island, isirr); % relative impact, all & irrigated land
table_impact(13,[2 4])                      = NaN; % index, so relative change makes no sense


% rounding
table_impact(:,[2 4]) = round(table_impact(:,[2 4]) .* 10 ) ./ 10 ; % round to 1 decimal
table_impact(:,[1 3]) = round(table_impact(:,[1 3]) .* 100) ./ 100; % round to 2 decimals


% perform paired, two-sided Wilcoxon signed rank test at 5% significance level
% a paired, two-sided test for the null hypothesis that x – y comes from a distribution with zero median.
% h=1 rejects h0, thus significant change!
alpha = 0.01;
tabel_impact_p = NaN(size(table_impact));
tabel_impact_h = NaN(size(table_impact));
[tabel_impact_p( 1, 1), tabel_impact_h( 1, 1)] = signrank(T2M_irr(island)  , T2M_ctl(island)  , 'alpha', alpha); % all land
[tabel_impact_p( 2, 1), tabel_impact_h( 2, 1)] = signrank(PRECT_irr(island), PRECT_ctl(island), 'alpha', alpha); % all land
[tabel_impact_p( 3, 1), tabel_impact_h( 3, 1)] = signrank(ET_irr(island)   , ET_ctl(island)   , 'alpha', alpha); % all land
[tabel_impact_p( 4, 1), tabel_impact_h( 4, 1)] = signrank(TS_irr(island)   , TS_ctl(island)   , 'alpha', alpha); % all land
[tabel_impact_p( 5, 1), tabel_impact_h( 5, 1)] = signrank(SWnet_irr(island), SWnet_ctl(island), 'alpha', alpha); % all land
[tabel_impact_p( 6, 1), tabel_impact_h( 6, 1)] = signrank(LWnet_irr(island), LWnet_ctl(island), 'alpha', alpha); % all land
[tabel_impact_p( 7, 1), tabel_impact_h( 7, 1)] = signrank(LHF_irr(island)  , LHF_ctl(island)  , 'alpha', alpha); % all land
[tabel_impact_p( 8, 1), tabel_impact_h( 8, 1)] = signrank(SHF_irr(island)  , SHF_ctl(island)  , 'alpha', alpha); % all land
[tabel_impact_p( 9, 1), tabel_impact_h( 9, 1)] = signrank(PSL_irr(island)  , PSL_ctl(island)  , 'alpha', alpha); % all land
[tabel_impact_p(10, 1), tabel_impact_h(10, 1)] = signrank(TXx_irr(island)  , TXx_ctl(island)  , 'alpha', alpha); % all land
[tabel_impact_p(11, 1), tabel_impact_h(11, 1)] = signrank(TNn_irr(island)  , TNn_ctl(island)  , 'alpha', alpha); % all land
[tabel_impact_p(12, 1), tabel_impact_h(12, 1)] = signrank(CDD_irr(island)  , CDD_ctl(island)  , 'alpha', alpha); % all land
[tabel_impact_p(13, 1), tabel_impact_h(13, 1)] = signrank(HWDI_irr(island) , HWDI_ctl(island) , 'alpha', alpha); % all land

[tabel_impact_p( 1, 3), tabel_impact_h( 1, 3)] = signrank(T2M_irr(isirr)   , T2M_ctl(isirr)   , 'alpha', alpha); % irrigated land
[tabel_impact_p( 2, 3), tabel_impact_h( 2, 3)] = signrank(PRECT_irr(isirr) , PRECT_ctl(isirr) , 'alpha', alpha); % irrigated land
[tabel_impact_p( 3, 3), tabel_impact_h( 3, 3)] = signrank(ET_irr(isirr)    , ET_ctl(isirr)    , 'alpha', alpha); % irrigated land
[tabel_impact_p( 4, 3), tabel_impact_h( 4, 3)] = signrank(TS_irr(isirr)    , TS_ctl(isirr)    , 'alpha', alpha); % irrigated land
[tabel_impact_p( 5, 3), tabel_impact_h( 5, 3)] = signrank(SWnet_irr(isirr) , SWnet_ctl(isirr) , 'alpha', alpha); % irrigated land
[tabel_impact_p( 6, 3), tabel_impact_h( 6, 3)] = signrank(LWnet_irr(isirr) , LWnet_ctl(isirr) , 'alpha', alpha); % irrigated land
[tabel_impact_p( 7, 3), tabel_impact_h( 7, 3)] = signrank(LHF_irr(isirr)   , LHF_ctl(isirr)   , 'alpha', alpha); % irrigated land
[tabel_impact_p( 8, 3), tabel_impact_h( 8, 3)] = signrank(SHF_irr(isirr)   , SHF_ctl(isirr)   , 'alpha', alpha); % irrigated land
[tabel_impact_p( 9, 3), tabel_impact_h( 9, 3)] = signrank(PSL_irr(isirr)   , PSL_ctl(isirr)   , 'alpha', alpha); % irrigated land
[tabel_impact_p(10, 3), tabel_impact_h(10, 3)] = signrank(TXx_irr(isirr)   , TXx_ctl(isirr)   , 'alpha', alpha); % irrigated land
[tabel_impact_p(11, 3), tabel_impact_h(11, 3)] = signrank(TNn_irr(isirr)   , TNn_ctl(isirr)   , 'alpha', alpha); % irrigated land
[tabel_impact_p(12, 3), tabel_impact_h(12, 3)] = signrank(CDD_irr(isirr)   , CDD_ctl(isirr)   , 'alpha', alpha); % irrigated land
[tabel_impact_p(13, 3), tabel_impact_h(13, 3)] = signrank(HWDI_irr(isirr)  , HWDI_ctl(isirr)  , 'alpha', alpha); % irrigated land
end



% --------------------------------------------------------------------
% numbers for review
% --------------------------------------------------------------------


% global irrigation quantities from offline sensitivity experiments
if flags.offli == 1
QIRR_irr_offline_w00_tot = round( nansum(nansum(QIRR_irr_offline_w00 ./ 1E6 .* area)) ) % original QIRR_irr unit is [mm yr^-1]
QIRR_irr_offline_w03_tot = round( nansum(nansum(QIRR_irr_offline_w03 ./ 1E6 .* area)) ) % original QIRR_irr unit is [mm yr^-1]
QIRR_irr_offline_w07_tot = round( nansum(nansum(QIRR_irr_offline_w07 ./ 1E6 .* area)) ) % original QIRR_irr unit is [mm yr^-1]
QIRR_irr_offline_w10_tot = round( nansum(nansum(QIRR_irr_offline_w10 ./ 1E6 .* area)) ) % original QIRR_irr unit is [mm yr^-1]
end



