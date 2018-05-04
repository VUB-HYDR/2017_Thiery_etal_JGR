
% --------------------------------------------------------------------
% Surface Temperature Change decomposition routine
% note: preferably run "main"
% --------------------------------------------------------------------



% --------------------------------------------------------------------
% manipulations: call STCD function for all land
% --------------------------------------------------------------------


% call STCD function
[dR_lp, dR_ip, dT_lp, dT_ip, dTs_lp, dTs_ip] = mf_STCdecomp(                                                       ...
 SWin_irr, SWout_irr, SWnet_irr, LWin_irr, LWout_irr, LWnet_irr, LHF_irr, SHF_irr , G_irr, WHF_irr, AHF_irr,       ...
 SWin_ctl, SWout_ctl, SWnet_ctl, LWin_ctl, LWout_ctl, LWnet_ctl, LHF_ctl, SHF_ctl , G_ctl, WHF_ctl, AHF_ctl, isirr);


% get changes in T_2M
[~, dT2m_tot_lp, dT2m_tot_ip] = mf_fieldmean(T2M_irr-T2M_ctl, island, isirr);



% --------------------------------------------------------------------
% manipulations: call STCD function for all land - local effect
% --------------------------------------------------------------------

% call STCD function - consider irrigated pixels only since you look at local effects! - in case of all pixels the averaging is wrong (for unirrigated pixels you have SWin and LWin but no other fluxes, hence closure for averages but not for means)  
[~, dR_local_ip, ~, dT_local_ip, ~, dTs_local_ip] = mf_STCdecomp(                                                       ...
 SWin_irr, SWout_pft_irr(:,:,17), SWnet_pft_irr(:,:,17), LWin_irr, LWout_pft_irr(:,:,17), LWnet_pft_irr(:,:,17), LHF_pft_irr(:,:,17), SHF_pft_irr(:,:,17) , G_pft_irr(:,:,17), WHF_pft_irr(:,:,17), AHF_pft_irr(:,:,17),       ...
 SWin_irr, SWout_pft_irr(:,:,16), SWnet_pft_irr(:,:,16), LWin_irr, LWout_pft_irr(:,:,16), LWnet_pft_irr(:,:,16), LHF_pft_irr(:,:,16), SHF_pft_irr(:,:,16) , G_pft_irr(:,:,16), WHF_pft_irr(:,:,16), AHF_pft_irr(:,:,16), isirr);


% get changes in T_2M
[~, dT2m_tot_local_lp, dT2m_tot_local_ip] = mf_fieldmean(T2M_pft_irr(:,:,17)-T2M_pft_irr(:,:,16), island, isirr);



% --------------------------------------------------------------------
% manipulations: call STCD function for every srex region - annual means
% --------------------------------------------------------------------


% loop over srex regions
for i=1:nreg
    
    
    % call STCD function - srex regions ALL pixels
    [~, dR_srex_lp(:,i), ~, dT_srex_lp(:,i), ~, dTs_srex_lp(i)] = mf_STCdecomp(                                                  ...
     SWin_irr, SWout_irr, SWnet_irr, LWin_irr, LWout_irr, LWnet_irr, LHF_irr, SHF_irr , G_irr, WHF_irr, AHF_irr,                 ...
     SWin_ctl, SWout_ctl, SWnet_ctl, LWin_ctl, LWout_ctl, LWnet_ctl, LHF_ctl, SHF_ctl , G_ctl, WHF_ctl, AHF_ctl, issrex(:,:,i)); %#ok<*SAGROW>

 
    % call STCD function - srex regions IRRIGATED pixels
    [~, dR_srex_ip(:,i), ~, dT_srex_ip(:,i), ~, dTs_srex_ip(i)] = mf_STCdecomp(                                                         ...
     SWin_irr, SWout_irr, SWnet_irr, LWin_irr, LWout_irr, LWnet_irr, LHF_irr, SHF_irr , G_irr, WHF_irr, AHF_irr,                        ...
     SWin_ctl, SWout_ctl, SWnet_ctl, LWin_ctl, LWout_ctl, LWnet_ctl, LHF_ctl, SHF_ctl , G_ctl, WHF_ctl, AHF_ctl, issrex(:,:,i) & isirr);


    % get changes in T_2M
    [~, dT2m_tot_srex_lp(i), dT2m_tot_srex_ip(i)] = mf_fieldmean(T2M_irr-T2M_ctl, issrex(:,:,i) & island, issrex(:,:,i) & isirr);
    [~, dT2m_min_srex_lp(i), dT2m_min_srex_ip(i)] = mf_fieldmin (T2M_irr-T2M_ctl, issrex(:,:,i) & island, issrex(:,:,i) & isirr);

    
end



% --------------------------------------------------------------------
% manipulations: call STCD function for every srex region - monthly means
% --------------------------------------------------------------------


% loop over srex regions
for i=1:nreg
    
  for j=1:12 % number of months
    
    % call STCD function - srex regions ALL pixels
    [~, dR_srex_lp_mm(:,i,j), ~, dT_srex_lp_mm(:,i,j), ~, dTs_srex_lp_mm(i,j)] = mf_STCdecomp(                                                  ...
     SWin_irr_mm(:,:,j), SWout_irr_mm(:,:,j), SWnet_irr_mm(:,:,j), LWin_irr_mm(:,:,j), LWout_irr_mm(:,:,j), LWnet_irr_mm(:,:,j), LHF_irr_mm(:,:,j), SHF_irr_mm(:,:,j), G_irr_mm(:,:,j), WHF_irr_mm(:,:,j), AHF_irr_mm(:,:,j),                 ...
     SWin_ctl_mm(:,:,j), SWout_ctl_mm(:,:,j), SWnet_ctl_mm(:,:,j), LWin_ctl_mm(:,:,j), LWout_ctl_mm(:,:,j), LWnet_ctl_mm(:,:,j), LHF_ctl_mm(:,:,j), SHF_ctl_mm(:,:,j), G_ctl_mm(:,:,j), WHF_ctl_mm(:,:,j), AHF_ctl_mm(:,:,j), issrex(:,:,i)); %#ok<*SAGROW>

 
    % call STCD function - srex regions IRRIGATED pixels
    [~, dR_srex_ip_mm(:,i,j), ~, dT_srex_ip_mm(:,i,j), ~, dTs_srex_ip_mm(i,j)] = mf_STCdecomp(                                                         ...
     SWin_irr_mm(:,:,j), SWout_irr_mm(:,:,j), SWnet_irr_mm(:,:,j), LWin_irr_mm(:,:,j), LWout_irr_mm(:,:,j), LWnet_irr_mm(:,:,j), LHF_irr_mm(:,:,j), SHF_irr_mm(:,:,j), G_irr_mm(:,:,j), WHF_irr_mm(:,:,j), AHF_irr_mm(:,:,j),                        ...
     SWin_ctl_mm(:,:,j), SWout_ctl_mm(:,:,j), SWnet_ctl_mm(:,:,j), LWin_ctl_mm(:,:,j), LWout_ctl_mm(:,:,j), LWnet_ctl_mm(:,:,j), LHF_ctl_mm(:,:,j), SHF_ctl_mm(:,:,j), G_ctl_mm(:,:,j), WHF_ctl_mm(:,:,j), AHF_ctl_mm(:,:,j), issrex(:,:,i) & isirr);


    % get changes in T_2M
    [~, dT2m_tot_srex_lp_mm(i,j), dT2m_tot_srex_ip_mm(i,j)] = mf_fieldmean(T2M_irr_mm(:,:,j)-T2M_ctl_mm(:,:,j), issrex(:,:,i) & island, issrex(:,:,i) & isirr);

    
  end
    
end

