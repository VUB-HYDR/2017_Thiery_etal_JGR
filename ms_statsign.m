
% --------------------------------------------------------------------
% Statistical significance subroutine
% note: preferably run "main"
% --------------------------------------------------------------------


% perform paired, two-sided Wilcoxon signed rank test at alpha % significance level
% a paired, two-sided test for the null hypothesis that x – y comes from a distribution with zero median.
% h=1 rejects h0, thus significant change!


% --------------------------------------------------------------------
% Initialisation
% --------------------------------------------------------------------


% get number of observational products
alpha = 0.05;


% --------------------------------------------------------------------
% manipulations
% --------------------------------------------------------------------


% prepare for loop
statsign_dT2M_p    = NaN(nlat,nlon);
statsign_dT2M_h    = NaN(nlat,nlon);
statsign_dPRECT_p  = NaN(nlat,nlon);
statsign_dPRECT_h  = NaN(nlat,nlon);
statsign_dLHF_p    = NaN(nlat,nlon);
statsign_dLHF_h    = NaN(nlat,nlon);
statsign_dSHF_p    = NaN(nlat,nlon);
statsign_dSHF_h    = NaN(nlat,nlon);
statsign_dTXx_p    = NaN(nlat,nlon);
statsign_dTXx_h    = NaN(nlat,nlon);
statsign_dTNn_p    = NaN(nlat,nlon);
statsign_dTNn_h    = NaN(nlat,nlon);
statsign_dHWDI_p   = NaN(nlat,nlon);
statsign_dHWDI_h   = NaN(nlat,nlon);
statsign_dCDD_p    = NaN(nlat,nlon);
statsign_dCDD_h    = NaN(nlat,nlon);
statsign_dTS_p     = NaN(nlat,nlon);
statsign_dTS_h     = NaN(nlat,nlon);
statsign_dET_p     = NaN(nlat,nlon);
statsign_dET_h     = NaN(nlat,nlon);
statsign_dTS_pft_p = NaN(nlat,nlon);
statsign_dTS_pft_h = NaN(nlat,nlon);
statsign_dET_pft_p = NaN(nlat,nlon);
statsign_dET_pft_h = NaN(nlat,nlon);


% loop over lat/lon
for i=1:nlat
    for j=1:nlon       
        if ~isnan(T2M_ctl(i,j)) % only for land pixels
            [statsign_dT2M_p(i,j)   , statsign_dT2M_h(i,j)   ] = signrank(squeeze(T2M_irr_ym_pe(i,j,:)     ), squeeze(T2M_ctl_ym_pe(i,j,:)     ), 'alpha', alpha);
            [statsign_dPRECT_p(i,j) , statsign_dPRECT_h(i,j) ] = signrank(squeeze(PRECT_irr_ym_pe(i,j,:)   ), squeeze(PRECT_ctl_ym_pe(i,j,:)   ), 'alpha', alpha);
            [statsign_dLHF_p(i,j)   , statsign_dLHF_h(i,j)   ] = signrank(squeeze(LHF_irr_ym_pe(i,j,:)     ), squeeze(LHF_ctl_ym_pe(i,j,:)     ), 'alpha', alpha);
            [statsign_dSHF_p(i,j)   , statsign_dSHF_h(i,j)   ] = signrank(squeeze(SHF_irr_ym_pe(i,j,:)     ), squeeze(SHF_ctl_ym_pe(i,j,:)     ), 'alpha', alpha);

            [statsign_dTXx_p(i,j)   , statsign_dTXx_h(i,j)   ] = signrank(squeeze(TXx_irr_ym_pe(i,j,:)     ), squeeze(TXx_ctl_ym_pe(i,j,:)     ), 'alpha', alpha);
            [statsign_dTNn_p(i,j)   , statsign_dTNn_h(i,j)   ] = signrank(squeeze(TNn_irr_ym_pe(i,j,:)     ), squeeze(TNn_ctl_ym_pe(i,j,:)     ), 'alpha', alpha);
            [statsign_dHWDI_p(i,j)  , statsign_dHWDI_h(i,j)  ] = signrank(squeeze(HWDI_irr_ym_pe(i,j,:)    ), squeeze(HWDI_ctl_ym_pe(i,j,:)    ), 'alpha', alpha);
            [statsign_dCDD_p(i,j)   , statsign_dCDD_h(i,j)   ] = signrank(squeeze(CDD_irr_ym_pe(i,j,:)     ), squeeze(CDD_ctl_ym_pe(i,j,:)     ), 'alpha', alpha);
            
            [statsign_dTS_p(i,j)    , statsign_dTS_h(i,j)    ] = signrank(squeeze(TS_irr_ym_pe(i,j,:)      ), squeeze(TS_ctl_ym_pe(i,j,:)      ), 'alpha', alpha);
            [statsign_dET_p(i,j)    , statsign_dET_h(i,j)    ] = signrank(squeeze(ET_irr_ym_pe(i,j,:)      ), squeeze(ET_ctl_ym_pe(i,j,:)      ), 'alpha', alpha);
            if flags.local == 1
            if ~isnan(TS_pft_irr(i,j,16)) && ~isnan(TS_pft_irr(i,j,17)) % only for irrigated pixels
            [statsign_dTS_pft_p(i,j), statsign_dTS_pft_h(i,j)] = signrank(squeeze(TS_pft_irr_ym_pe(i,j,1,:)), squeeze(TS_pft_irr_ym_pe(i,j,2,:)), 'alpha', alpha);
            [statsign_dET_pft_p(i,j), statsign_dET_pft_h(i,j)] = signrank(squeeze(ET_pft_irr_ym_pe(i,j,1,:)), squeeze(ET_pft_irr_ym_pe(i,j,2,:)), 'alpha', alpha);            
            end
            end
        end
    end
end

