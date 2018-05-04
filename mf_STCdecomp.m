
% --------------------------------------------------------------------
% SEB changes responsible for Surface Temperature change
% note: preferably run "main"
% --------------------------------------------------------------------


function [dR_lp  , dR_ip  , dT_lp  , dT_ip  , dTs_lp  , dTs_ip] = mf_STCdecomp(                                                                      ...
          SWin_irr, SWout_irr, SWnet_irr, LWin_irr, LWout_irr, LWnet_irr, LHF_irr, SHF_irr, G_irr, WHF_irr, AHF_irr,        ...
          SWin_ctl, SWout_ctl, SWnet_ctl, LWin_ctl, LWout_ctl, LWnet_ctl, LHF_ctl, SHF_ctl, G_ctl, WHF_ctl, AHF_ctl, isirr) ...


% What is different from the original CCLM code:
% 1. we get closure because we enforce it (dT is computed from dLWout), instead of checking closure independently from TAF (I also tested TS from CAM but also doesn't work)
% 2. G has opposite sign!!! -1 needed to close balance in testing, not needed to close balance over AGL in cclm_present!!
% 3. emissivity is different, hence 'term' varies between two approaches, but this is only a small effect because changing term to term_lp has only little influence!!!
% 4. change in emissivity is not considered during testing
% 5. seems that CCLM code is working only because there is almost no bare soil/glaciers/urban over the AGL region (hence ignoring emg is ok and TAF for vegetation only is ok)


% emissivities in CLM:
% bare soil:  emg = 0.97
% water:      emg = 0.97
% snow:       emg = 0.96
% vegetation: emv = 1 - exp(-(elai + esai))


% sign conventions in CLM (see Biogeophysics2Mod.F90):
% SWnet:  + to land (not explicit in code)
% LWnet:  + to atm
% LHF  :  + to atm
% SHF  :  + to atm  (idem for FSH_G)
% G    :  + into soil
% LHF  :  + to atm


% note: 
% * these are really identical, always (checked):
% SWdown = FSDS
% SWup   = FSR
% LWdown = FLDS
% LWup   = FIRE
% * these are identical except for some numerical noise (checked):
% SWnet = SWin - SWout
% LWnet = LWout - LWin
% FSH   = FSH_V + FSH_G
% LHF2  = FCEV + FCTR + FGEV



% --------------------------------------------------------------------
% initialisation
% --------------------------------------------------------------------


% declare globals
global island


% initialise physical constants
[sigma] = mf_inicon('sigma');



% --------------------------------------------------------------------
% manipulations: check SEB closure
% --------------------------------------------------------------------


% check surface energy balance closure
% closure_SEB_irr = SWin_irr - SWout_irr + LWin_irr - LWout_irr - LHF_irr - SHF_irr - G_irr + WHF_irr + AHF_irr; % works
% closure_SEB_ctl = SWin_ctl - SWout_ctl + LWin_ctl - LWout_ctl - LHF_ctl - SHF_ctl - G_ctl + WHF_ctl + AHF_ctl; % works
closure_SEB_irr = SWnet_irr - LWnet_irr - LHF_irr - SHF_irr - G_irr + WHF_irr + AHF_irr;                         % works even better
closure_SEB_ctl = SWnet_ctl - LWnet_ctl - LHF_ctl - SHF_ctl - G_ctl + WHF_ctl + AHF_ctl;                         % works even better


% get max SEB closure error
errmax_irr  = nanmax(nanmax(abs(closure_SEB_irr)));
errmax_ctl  = nanmax(nanmax(abs(closure_SEB_ctl)));
disp(['maximum SEB error for irr is ' num2str(errmax_irr) ' W m^-2'])
disp(['maximum SEB error for ctl is ' num2str(errmax_ctl) ' W m^-2'])



% --------------------------------------------------------------------
% manipulations: Temperature decomposition
% --------------------------------------------------------------------


% get field means for land pixels and irrigated pixels only
[~, SWin_irr_lp , SWin_irr_ip ] = mf_fieldmean(SWin_irr , island, isirr);
[~, SWin_ctl_lp , SWin_ctl_ip ] = mf_fieldmean(SWin_ctl , island, isirr);
[~, SWout_irr_lp, SWout_irr_ip] = mf_fieldmean(SWout_irr, island, isirr);
[~, SWout_ctl_lp, SWout_ctl_ip] = mf_fieldmean(SWout_ctl, island, isirr);
[~, LWin_irr_lp , LWin_irr_ip ] = mf_fieldmean(LWin_irr , island, isirr);
[~, LWin_ctl_lp , LWin_ctl_ip ] = mf_fieldmean(LWin_ctl , island, isirr);
[~, LWout_irr_lp, LWout_irr_ip] = mf_fieldmean(LWout_irr, island, isirr);
[~, LWout_ctl_lp, LWout_ctl_ip] = mf_fieldmean(LWout_ctl, island, isirr);
[~, LHF_irr_lp  , LHF_irr_ip  ] = mf_fieldmean(LHF_irr  , island, isirr);
[~, LHF_ctl_lp  , LHF_ctl_ip  ] = mf_fieldmean(LHF_ctl  , island, isirr);
[~, SHF_irr_lp  , SHF_irr_ip  ] = mf_fieldmean(SHF_irr  , island, isirr);
[~, SHF_ctl_lp  , SHF_ctl_ip  ] = mf_fieldmean(SHF_ctl  , island, isirr);
[~, G_irr_lp    , G_irr_ip    ] = mf_fieldmean(G_irr    , island, isirr);
[~, G_ctl_lp    , G_ctl_ip    ] = mf_fieldmean(G_ctl    , island, isirr);
[~, WHF_irr_lp  , WHF_irr_ip  ] = mf_fieldmean(WHF_irr  , island, isirr);
[~, WHF_ctl_lp  , WHF_ctl_ip  ] = mf_fieldmean(WHF_ctl  , island, isirr);
[~, AHF_irr_lp  , AHF_irr_ip  ] = mf_fieldmean(AHF_irr  , island, isirr);
[~, AHF_ctl_lp  , AHF_ctl_ip  ] = mf_fieldmean(AHF_ctl  , island, isirr);


% get some more field means (SEB component differences)
[~, dR_SWnet_lp, dR_SWnet_ip] = mf_fieldmean(SWnet_irr - SWnet_ctl, island, isirr);
[~, dR_LWnet_lp, dR_LWnet_ip] = mf_fieldmean(LWnet_irr - LWnet_ctl, island, isirr);
[~, dR_LHF_lp  , dR_LHF_ip  ] = mf_fieldmean(LHF_irr   - LHF_ctl  , island, isirr);
[~, dR_SHF_lp  , dR_SHF_ip  ] = mf_fieldmean(SHF_irr   - SHF_ctl  , island, isirr);
[~, dR_G_lp    , dR_G_ip    ] = mf_fieldmean(G_irr     - G_ctl    , island, isirr);
[~, dR_WHF_lp  , dR_WHF_ip  ] = mf_fieldmean(WHF_irr   - WHF_ctl  , island, isirr);
[~, dR_AHF_lp  , dR_AHF_ip  ] = mf_fieldmean(AHF_irr   - AHF_ctl  , island, isirr);


% get the net radiative forcing => conventions as in the SEB equation:
% dR_SWnet : + if more energy to surface
% dR_LWnet : + if more energy to atm  (= away from surface)
% dR_LHF_lp: + if more energy to atm  (= away from surface)
% dR_SHF_lp: + if more energy to atm  (= away from surface)
% dR_G_lp  : + if more energy to soil (= away from surface)
dR_lp = [dR_SWnet_lp; dR_LWnet_lp; dR_LHF_lp; dR_SHF_lp; dR_G_lp; dR_WHF_lp; dR_AHF_lp];
dR_ip = [dR_SWnet_ip; dR_LWnet_ip; dR_LHF_ip; dR_SHF_ip; dR_G_ip; dR_WHF_ip; dR_AHF_ip];


% check surface energy balance closure for averages - works
closure_SEB_irr_lp = SWin_irr_lp  - SWout_irr_lp + LWin_irr_lp - LWout_irr_lp - LHF_irr_lp - SHF_irr_lp - G_irr_lp + WHF_irr_lp + AHF_irr_lp; %#ok<NASGU> % works
closure_SEB_ctl_lp = SWin_ctl_lp  - SWout_ctl_lp + LWin_ctl_lp - LWout_ctl_lp - LHF_ctl_lp - SHF_ctl_lp - G_ctl_lp + WHF_ctl_lp + AHF_ctl_lp; %#ok<NASGU> % works


% get radiative temperature from LWout - see equation 4.11 in (Oleson et al., 2010)
% note: assuming blackbody
Ts_ctl_lp = (LWout_ctl_lp ./ sigma).^(1/4);
Ts_irr_lp = (LWout_irr_lp ./ sigma).^(1/4);
Ts_ctl_ip = (LWout_ctl_ip ./ sigma).^(1/4);
Ts_irr_ip = (LWout_irr_ip ./ sigma).^(1/4);


% get the contribution to temperature change - land pixels
term       = 1 ./ (4 .* sigma .* Ts_ctl_lp.^3 );
dT_alb_lp  = term .* (-1) .*  SWin_irr_lp .* (SWout_irr_lp./SWin_irr_lp - SWout_ctl_lp./SWin_ctl_lp);
dT_SWin_lp = term .* (1 - SWout_irr_lp./SWin_irr_lp) .* (SWin_irr_lp - SWin_ctl_lp);
dT_LWin_lp = term .*         (LWin_irr_lp - LWin_ctl_lp);
dT_LHF_lp  = term .* (-1) .* (LHF_irr_lp  - LHF_ctl_lp );
dT_SHF_lp  = term .* (-1) .* (SHF_irr_lp  - SHF_ctl_lp ); % niet af!!!
dT_G_lp    = term .* (-1) .* (G_irr_lp    - G_ctl_lp   );
dT_em_lp   = 0;                                           % neglect
% dT_em_lp   = term .* - ((( (1-emg_irr_lp) .* (1-emv_irr_lp)  .* (1-emv_irr_lp)  .* LWin_ctl_lp )                           + ...
%                         (  emv_irr_lp .* ( 1 + (1-emg_irr_lp).*(1-emv_irr_lp) ) .* sigma .* TV_ctl_lp.^3 .* TV_ctl_lp )     + ...
%                         (  emg_irr_lp     .* (1-emv_irr_lp)  .* sigma        .* TG_ctl_lp.^4 ) )                              ...
%                         -                                                                                                     ...   % compute change in Lvg_up due to the changee in emissivity
%                         (( (1-emg_ctl_lp) .* (1-emv_ctl_lp)   .* (1-emv_ctl_lp) .* LWin_ctl_lp )                            + ...   % (eq.4.15 p.42 (pdf: p.54) in CLM3.5_TechnicalDescription.pdf)
%                         (  emv_ctl_lp .* ( 1 + (1-emg_ctl_lp).*(1-emv_ctl_lp) ) .* sigma .* TV_ctl_lp.^3 .* TV_ctl_lp )     + ...   % but note that we ignored the time step terms and that this is 
%                         (  emg_ctl_lp     .* (1-emv_ctl_lp)   .* sigma .* TG_ctl_lp.^4   ))                                      ); % thus not correct, and only accounts for changes in the canopy...
%                         
dT_WHF_lp  = term .*         (WHF_irr_lp  - WHF_ctl_lp );
dT_AHF_lp  = term .*         (AHF_irr_lp  - AHF_ctl_lp );
dT_RES_lp  = dT_G_lp + dT_em_lp + dT_WHF_lp + dT_AHF_lp; % Residual
dT_lp      = [dT_alb_lp; dT_SWin_lp; dT_LWin_lp; dT_LHF_lp; dT_SHF_lp; dT_RES_lp];


% again check closure - land pixels
dTs_lp            = Ts_irr_lp - Ts_ctl_lp;
closure_dT_lp     = dTs_lp - sum(dT_lp);
closure_dT_lp_rel = closure_dT_lp ./ dTs_lp .* 100; %#ok<NASGU>


% get the contribution to temperature change - irrigated pixels
term       = 1 ./ (4 .* sigma .* Ts_ctl_ip.^3 );
dT_alb_ip  = term .* (-1) .*  SWin_irr_ip .* (SWout_irr_ip./SWin_irr_ip - SWout_ctl_ip./SWin_ctl_ip);
dT_SWin_ip = term .* (1 - SWout_irr_ip./SWin_irr_ip) .* (SWin_irr_ip - SWin_ctl_ip);
dT_LWin_ip = term .*         (LWin_irr_ip - LWin_ctl_ip);
dT_LHF_ip  = term .* (-1) .* (LHF_irr_ip  - LHF_ctl_ip );
dT_SHF_ip  = term .* (-1) .* (SHF_irr_ip  - SHF_ctl_ip ); % niet af!!!
dT_G_ip    = term .* (-1) .* (G_irr_ip    - G_ctl_ip   );
dT_em_ip   = 0;                                           % neglect
% dT_em_ip   = term .* - ((( (1-emg_irr_ip) .* (1-emv_irr_ip)  .* (1-emv_irr_ip)  .* LWin_ctl_ip )                           + ...
%                         (  emv_irr_ip .* ( 1 + (1-emg_irr_ip).*(1-emv_irr_ip) ) .* sigma .* TV_ctl_ip.^3 .* TV_ctl_ip )     + ...
%                         (  emg_irr_ip     .* (1-emv_irr_ip)  .* sigma        .* TG_ctl_ip.^4 ) )                              ...
%                         -                                                                                                     ...   % compute change in Lvg_up due to the changee in emissivity
%                         (( (1-emg_ctl_ip) .* (1-emv_ctl_ip)   .* (1-emv_ctl_ip) .* LWin_ctl_ip )                            + ...   % (eq.4.15 p.42 (pdf: p.54) in CLM3.5_TechnicalDescription.pdf)
%                         (  emv_ctl_ip .* ( 1 + (1-emg_ctl_ip).*(1-emv_ctl_ip) ) .* sigma .* TV_ctl_ip.^3 .* TV_ctl_ip )     + ...   % but note that we ignored the time step terms and that this is 
%                         (  emg_ctl_ip     .* (1-emv_ctl_ip)   .* sigma .* TG_ctl_ip.^4   ))                                      ); % thus not correct, and only accounts for changes in the canopy...
%                         
dT_WHF_ip  = term .*         (WHF_irr_ip  - WHF_ctl_ip );
dT_AHF_ip  = term .*         (AHF_irr_ip  - AHF_ctl_ip );
dT_RES_ip  = dT_G_ip + dT_em_ip + dT_WHF_ip + dT_AHF_ip; % Residual
dT_ip      = [dT_alb_ip; dT_SWin_ip; dT_LWin_ip; dT_LHF_ip; dT_SHF_ip; dT_RES_ip];


% again check closure - irrigated pixels
dTs_ip            = Ts_irr_ip - Ts_ctl_ip;
closure_dT_ip     = dTs_ip - sum(dT_ip);
closure_dT_ip_rel = closure_dT_ip ./ dTs_ip .* 100; %#ok<NASGU>



% --------------------------------------------------------------------
% visualisation
% --------------------------------------------------------------------


% % initialisation
% caxes.SEBerr       = [ -0.001 0.001];
% colormaps.SEBerr   = mf_colormap_cpt('dkbluered'    , 20);
% [lat_mod, lon_mod] = mf_load('f.e122.F1850PDC5.f09_g16.irrigation-io192.ensmean_constants.nc');
% 
% 
% % visualise SEB closure for CTL run
% mf_plot_dom2(lon_mod, lat_mod, closure_SEB_ctl, [], caxes.SEBerr, colormaps.SEBerr, 0, 1, ' ', '2003 SEB error - ctl', 'W m^-^2'); hold on;
% export_fig figures/SEB_closure_ctl -transparent -png % save figure
% 
% 
% % visualise SEB closure for CTL run
% mf_plot_dom2(lon_mod, lat_mod, closure_SEB_irr, [], caxes.SEBerr, colormaps.SEBerr, 0, 1, ' ', '2003 SEB error - irr', 'W m^-^2'); hold on;
% export_fig figures/SEB_closure_irr -transparent -png % save figure



end
