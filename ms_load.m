
% --------------------------------------------------------------------
% subroutine to load the variables
% note: preferably run "main"
% --------------------------------------------------------------------



% --------------------------------------------------------------------
% Load observational data
% --------------------------------------------------------------------


% only needed if evaluation is performed
if flags.eval == 1


% load CRU data
[~, ~, T2M_cru   , PRECT_cru   ] = mf_load('CRU_1981-2010_timmean.nc' , 'T2M', 'Prec');
[~, ~, T2M_cru_mm, PRECT_cru_mm] = mf_load('CRU_1981-2010_ymonmean.nc', 'T2M', 'Prec');


% load ERA-interim/Land data
[~, ~, ET_eral   , QRUNOFF_eral   ] = mf_load('ERAL_1981-2010_timmean.nc' , 'ET', 'RUNOFF');
[~, ~, ET_eral_mm, QRUNOFF_eral_mm] = mf_load('ERAL_1981-2010_ymonmean.nc', 'ET', 'RUNOFF');


% load FLUXNET-MTE data
[~, ~, LHF_mte_8210   , SHF_mte_8210   ] = mf_load('MTE_1982-2010_timmean.nc' , 'LHF', 'SHF');
[~, ~, LHF_mte_8210_mm, SHF_mte_8210_mm] = mf_load('MTE_1982-2010_ymonmean.nc', 'LHF', 'SHF');


% load GHCNDEX data
[~, ~, TXx_ghcn   , TNn_ghcn   ] = mf_load('GHCNDEX_1981-2010_timmean.nc' , 'TXx', 'TNn');
[~, ~, TXx_ghcn_mm, TNn_ghcn_mm] = mf_load('GHCNDEX_1981-2010_ymonmean.nc', 'TXx', 'TNn');


% load GPCP data
[~, ~, PRECT_gpcp   ] = mf_load('GPCP_1981-2010_timmean.nc' , 'Prec');
[~, ~, PRECT_gpcp_mm] = mf_load('GPCP_1981-2010_ymonmean.nc', 'Prec');


% load HadEx2 data
[~, ~, TXx_had   , TNn_had   ] = mf_load('HadEX2_1981-2010_timmean.nc' , 'TXx', 'TNn');
[~, ~, TXx_had_mm, TNn_had_mm] = mf_load('HadEX2_1981-2010_ymonmean.nc', 'TXx', 'TNn');


% load irrigation amount data
[~, ~, QIRR_obs]       = mf_load('IRAM_2000.nc', 'QIRRIG');
QIRR_obs(QIRR_obs < 0) = 0; % remove unphysical values


% load LandFlux-EVAL data
[~, ~, ET_lfev_8905   ] = mf_load('LFEV_1989-2005_timmean.nc' , 'ET_mean');
[~, ~, ET_lfev_8905_mm] = mf_load('LFEV_1989-2005_ymonmean.nc', 'ET_mean');


% load GLEAM data
[~, ~, ET_glea   ] = mf_load('GLEAM_1981-2010_timmean.nc' , 'ET_mean');
[~, ~, ET_glea_mm] = mf_load('GLEAM_1981-2010_ymonmean.nc', 'ET_mean');


% load GEWEX-SRB data
[~, ~, SWnet_srb_8407   , LWnet_srb_8407   ] = mf_load('SRB_1984-2007_timmean.nc' , 'SWnet', 'LWnet');
[~, ~, SWnet_srb_8407_mm, LWnet_srb_8407_mm] = mf_load('SRB_1984-2007_ymonmean.nc', 'SWnet', 'LWnet');


end



% --------------------------------------------------------------------
% Load CESM model data
% --------------------------------------------------------------------


% load 2D model constants (pct_irr = percent of grid cell that is irrigated, see mksrfdat.F90)
[lat_mod, lon_mod, pct_irr, pct_land, area] = mf_load('f.e122.F1850PDC5.f09_g16.irrigation-io192.001_constants.nc', 'PCT_IRRIG', 'landfrac', 'AREA');


% load 2D model atm variables
[~, ~, TS_ctl, TXx_ctl, TNn_ctl, PRECT_ctl, CDD_ctl, HWDI_ctl, WSDI_ctl, PSL_ctl] = mf_load('f.e122.F1850PDC5.f09_g16.control-io192.ensmean_atm_h1_timmean.nc'   , 'TS', 'TXx', 'TNn', 'PRECT', 'CDD', 'HWDI', 'WSDI', 'PSL');
[~, ~, TS_irr, TXx_irr, TNn_irr, PRECT_irr, CDD_irr, HWDI_irr, WSDI_irr, PSL_irr] = mf_load('f.e122.F1850PDC5.f09_g16.irrigation-io192.ensmean_atm_h1_timmean.nc', 'TS', 'TXx', 'TNn', 'PRECT', 'CDD', 'HWDI', 'WSDI', 'PSL');


% load 2D model lnd variables
[~, ~, Rx1day_ctl, Rx5day_ctl, QIRR_ctl, QRUNOFF_ctl, ET_ctl, T2M_ctl, TV_ctl, LHF_ctl, SHF_ctl] = mf_load('f.e122.F1850PDC5.f09_g16.control-io192.ensmean_lnd_h1_timmean.nc'   , 'Rx1day', 'Rx5day', 'QIRRIG', 'QRUNOFF', 'ET', 'TSA', 'TV', 'Qle', 'FSH');
[~, ~, Rx1day_irr, Rx5day_irr, QIRR_irr, QRUNOFF_irr, ET_irr, T2M_irr, TV_irr, LHF_irr, SHF_irr] = mf_load('f.e122.F1850PDC5.f09_g16.irrigation-io192.ensmean_lnd_h1_timmean.nc', 'Rx1day', 'Rx5day', 'QIRRIG', 'QRUNOFF', 'ET', 'TSA', 'TV', 'Qle', 'FSH');


% load 2D model lnd variables for evaluation (subsetting for observational periods)
if flags.eval == 1   
[~, ~, SWnet_ctl_ym   , LWnet_ctl_ym   , SHF_ctl_ym   , LHF_ctl_ym   ] = mf_load('f.e122.F1850PDC5.f09_g16.control-io192.ensmean_lnd_h1_yearmean.nc'           , 'FSA', 'FIRA', 'FSH', 'Qle');
[~, ~, SWnet_irr_ym   , LWnet_irr_ym   , SHF_irr_ym   , LHF_irr_ym   ] = mf_load('f.e122.F1850PDC5.f09_g16.irrigation-io192.ensmean_lnd_h1_yearmean.nc'        , 'FSA', 'FIRA', 'FSH', 'Qle');

[~, ~, SWnet_ctl_mm_py, LWnet_ctl_mm_py, SHF_ctl_mm_py, LHF_ctl_mm_py] = mf_load('f.e122.F1850PDC5.f09_g16.control-io192.ensmean_lnd_h1_monmean_selname.nc'   , 'FSA', 'FIRA', 'FSH', 'Qle');
[~, ~, SWnet_irr_mm_py, LWnet_irr_mm_py, SHF_irr_mm_py, LHF_irr_mm_py] = mf_load('f.e122.F1850PDC5.f09_g16.irrigation-io192.ensmean_lnd_h1_monmean_selname.nc', 'FSA', 'FIRA', 'FSH', 'Qle');

[~, ~, QIRR_ctl_mm, QRUNOFF_ctl_mm, ET_ctl_mm, T2M_ctl_mm] = mf_load('f.e122.F1850PDC5.f09_g16.control-io192.ensmean_lnd_h1_ymonmean.nc'   , 'QIRRIG', 'QRUNOFF', 'ET', 'TSA');
[~, ~, QIRR_irr_mm, QRUNOFF_irr_mm, ET_irr_mm, T2M_irr_mm] = mf_load('f.e122.F1850PDC5.f09_g16.irrigation-io192.ensmean_lnd_h1_ymonmean.nc', 'QIRRIG', 'QRUNOFF', 'ET', 'TSA');

[~, ~, TXx_ctl_mm, TNn_ctl_mm, PRECT_ctl_mm] = mf_load('f.e122.F1850PDC5.f09_g16.control-io192.ensmean_atm_h1_ymonmean.nc'   , 'TXx', 'TNn', 'PRECT');
[~, ~, TXx_irr_mm, TNn_irr_mm, PRECT_irr_mm] = mf_load('f.e122.F1850PDC5.f09_g16.irrigation-io192.ensmean_atm_h1_ymonmean.nc', 'TXx', 'TNn', 'PRECT');
end


% load 2D model lnd variables for STC decomposition
if flags.perc == 1  
for i=1:length(srex_vars)    
    for j=1:length(srex_reg)
        for k=1:nens
            srex_ctl{i,j,k} = squeeze(ncread(['f.e122.F1850PDC5.f09_g16.control-io192.00'    num2str(k) '_' srex_block{i} '_h1_srex.nc'], [srex_vars{i} '_' srex_reg{j}])); %#ok<*SAGROW>
            srex_irr{i,j,k} = squeeze(ncread(['f.e122.F1850PDC5.f09_g16.irrigation-io192.00' num2str(k) '_' srex_block{i} '_h1_srex.nc'], [srex_vars{i} '_' srex_reg{j}]));
        end
    end
end
end


% load 2D model lnd variables for STC decomposition - total, local and monthly effect
if flags.STCD == 1 || flags.eval == 1
[~, ~, SWnet_ctl    , LWnet_ctl    , SWin_ctl   , SWout_ctl    , LWin_ctl   , LWout_ctl    , G_ctl    , WHF_ctl    , AHF_ctl                ] = mf_load('f.e122.F1850PDC5.f09_g16.control-io192.ensmean_lnd_h1_timmean.nc'    , 'FSA'    , 'FIRA'    , 'SWdown', 'SWup'    , 'LWdown', 'LWup'    , 'FGR'    , 'WASTEHEAT'    , 'HEAT_FROM_AC'        );
[~, ~, SWnet_irr    , LWnet_irr    , SWin_irr   , SWout_irr    , LWin_irr   , LWout_irr    , G_irr    , WHF_irr    , AHF_irr                ] = mf_load('f.e122.F1850PDC5.f09_g16.irrigation-io192.ensmean_lnd_h1_timmean.nc' , 'FSA'    , 'FIRA'    , 'SWdown', 'SWup'    , 'LWdown', 'LWup'    , 'FGR'    , 'WASTEHEAT'    , 'HEAT_FROM_AC'        );

[~, ~, SWnet_pft_irr, LWnet_pft_irr,              SWout_pft_irr,              LWout_pft_irr, SHF_pft_irr, LHF_pft_irr, G_pft_irr, WHF_pft_irr, AHF_pft_irr            ] = mf_load('f.e122.F1850PDC5.f09_g16.irrigation-io192.ensmean_lnd_h2_timmean.nc' , 'FSA_pft', 'FIRA_pft',           'SWup_pft',           'LWup_pft', 'FSH_pft', 'Qle_pft', 'FGR_pft', 'WASTEHEAT_pft', 'HEAT_FROM_AC_pft'    );

[~, ~, SWnet_ctl_mm , LWnet_ctl_mm , SWin_ctl_mm, SWout_ctl_mm , LWin_ctl_mm, LWout_ctl_mm , SHF_ctl_mm , LHF_ctl_mm , G_ctl_mm , WHF_ctl_mm , AHF_ctl_mm , T2M_ctl_mm] = mf_load('f.e122.F1850PDC5.f09_g16.control-io192.ensmean_lnd_h1_ymonmean.nc'   , 'FSA'    , 'FIRA'    , 'SWdown', 'SWup'    , 'LWdown', 'LWup'    , 'FSH'    , 'Qle'    , 'FGR'    , 'WASTEHEAT'    , 'HEAT_FROM_AC', 'TSA' );
[~, ~, SWnet_irr_mm , LWnet_irr_mm , SWin_irr_mm, SWout_irr_mm , LWin_irr_mm, LWout_irr_mm , SHF_irr_mm , LHF_irr_mm , G_irr_mm , WHF_irr_mm , AHF_irr_mm , T2M_irr_mm] = mf_load('f.e122.F1850PDC5.f09_g16.irrigation-io192.ensmean_lnd_h1_ymonmean.nc', 'FSA'    , 'FIRA'    , 'SWdown', 'SWup'    , 'LWdown', 'LWup'    , 'FSH'    , 'Qle'    , 'FGR'    , 'WASTEHEAT'    , 'HEAT_FROM_AC', 'TSA' );
end


% load 2D model lnd variables per pft (!) for local effects
if flags.local == 1 || flags.STCD == 1
[~, ~, T2M_pft_ctl, TV_pft_ctl, ET_pft_ctl, TS_pft_ctl] = mf_load('f.e122.F1850PDC5.f09_g16.control-io192.ensmean_lnd_h2_timmean.nc'   , 'TSA_pft', 'TV_pft', 'ET_pft', 'TS_pft');
[~, ~, T2M_pft_irr, TV_pft_irr, ET_pft_irr, TS_pft_irr] = mf_load('f.e122.F1850PDC5.f09_g16.irrigation-io192.ensmean_lnd_h2_timmean.nc', 'TSA_pft', 'TV_pft', 'ET_pft', 'TS_pft');
end


% load irrigation amounts from offline simulations
if flags.offli == 1
[~, ~, QIRR_ctl_offline    ]      = mf_load('i.e122.I_2000.f09_g16.control-io48.001_lnd_h1_timmean.nc'   , 'QIRRIG');
[~, ~, QIRR_irr_offline_w00]      = mf_load('i.e122.I_2000.f09_g16.irrigation-io48.001_lnd_h1_timmean.nc', 'QIRRIG');
[~, ~, QIRR_irr_offline_w03]      = mf_load('i.e122.I_2000.f09_g16.irrigation-io48.002_lnd_h1_timmean.nc', 'QIRRIG');
[~, ~, QIRR_irr_offline_w07]      = mf_load('i.e122.I_2000.f09_g16.irrigation-io48.003_lnd_h1_timmean.nc', 'QIRRIG');
[~, ~, QIRR_irr_offline_w10]      = mf_load('i.e122.I_2000.f09_g16.irrigation-io48.004_lnd_h1_timmean.nc', 'QIRRIG');
[~, ~, QIRR_ctl_offline_2deg    ] = mf_load('i.e122.I_2000.f19_g16.control-io48.001_lnd_h1_timmean.nc'   , 'QIRRIG');
[~, ~, QIRR_irr_offline_2deg_w00] = mf_load('i.e122.I_2000.f19_g16.irrigation-io48.001_lnd_h1_timmean.nc', 'QIRRIG');
[~, ~, QIRR_irr_offline_2deg_w03] = mf_load('i.e122.I_2000.f19_g16.irrigation-io48.002_lnd_h1_timmean.nc', 'QIRRIG');
[~, ~, QIRR_irr_offline_2deg_w07] = mf_load('i.e122.I_2000.f19_g16.irrigation-io48.003_lnd_h1_timmean.nc', 'QIRRIG');
[~, ~, QIRR_irr_offline_2deg_w10] = mf_load('i.e122.I_2000.f19_g16.irrigation-io48.004_lnd_h1_timmean.nc', 'QIRRIG');

% load 2D model constants from offline simulations (pct_irr = percent of grid cell that is irrigated, see mksrfdat.F90)
[lat_mod_2deg, lon_mod_2deg pct_irr_2deg, pct_land_2deg, area_2deg] = mf_load('i.e122.I_2000.f19_g16.irrigation-io48.002_constants.nc', 'PCT_IRRIG', 'landfrac', 'AREA');
pct_land_2deg                                                       = pct_land_2deg .* 100; % [] to [%]
end


% load 2D model lnd variables per year and member (!) for std computation
if flags.valp == 1  
for i=1:nens
    ind                             = (1:nyears) + (i-1)*nyears;
    [~, ~, QIRR_irr_ym_pe(:,:,ind)] = mf_load(['f.e122.F1850PDC5.f09_g16.irrigation-io192.00' num2str(i) '_lnd_h1_yearmean_QIRRIG.nc'], 'QIRRIG'); %#ok<SAGROW>
end
end


% load 2D model variables per year and member (!) for statsign computation
if flags.stat == 1  
for i=1:nens
    ind                             = (1:nyears) + (i-1)*nyears;
    [~, ~, SHF_ctl_ym_pe(:,:,ind), LHF_ctl_ym_pe(:,:,ind), T2M_ctl_ym_pe(:,:,ind), ET_ctl_ym_pe(:,:,ind)] = mf_load(['f.e122.F1850PDC5.f09_g16.control-io192.00'    num2str(i) '_lnd_h1_yearmean_selname.nc'], 'FSH', 'Qle', 'TSA', 'ET'); %#ok<SAGROW>
    [~, ~, SHF_irr_ym_pe(:,:,ind), LHF_irr_ym_pe(:,:,ind), T2M_irr_ym_pe(:,:,ind), ET_irr_ym_pe(:,:,ind)] = mf_load(['f.e122.F1850PDC5.f09_g16.irrigation-io192.00' num2str(i) '_lnd_h1_yearmean_selname.nc'], 'FSH', 'Qle', 'TSA', 'ET'); %#ok<SAGROW>
    [~, ~, CDD_ctl_ym_pe(:,:,ind), HWDI_ctl_ym_pe(:,:,ind), PRECT_ctl_ym_pe(:,:,ind), TNn_ctl_ym_pe(:,:,ind), TXx_ctl_ym_pe(:,:,ind), TS_ctl_ym_pe(:,:,ind)] = mf_load(['f.e122.F1850PDC5.f09_g16.control-io192.00'    num2str(i) '_atm_h1_yearmean_selname.nc'], 'CDD', 'HWDI', 'PRECT', 'TNn', 'TXx', 'TS'); %#ok<SAGROW>
    [~, ~, CDD_irr_ym_pe(:,:,ind), HWDI_irr_ym_pe(:,:,ind), PRECT_irr_ym_pe(:,:,ind), TNn_irr_ym_pe(:,:,ind), TXx_irr_ym_pe(:,:,ind), TS_irr_ym_pe(:,:,ind)] = mf_load(['f.e122.F1850PDC5.f09_g16.irrigation-io192.00' num2str(i) '_atm_h1_yearmean_selname.nc'], 'CDD', 'HWDI', 'PRECT', 'TNn', 'TXx', 'TS'); %#ok<SAGROW>
    [~, ~, ET_pft_irr_ym_pe(:,:,:,ind), TS_pft_irr_ym_pe(:,:,:,ind)] = mf_load(['f.e122.F1850PDC5.f09_g16.irrigation-io192.00'    num2str(i) '_lnd_h2_yearmean_selname.nc'], 'ET_pft', 'TS_pft');
end
end



% --------------------------------------------------------------------
% unit conversions
% --------------------------------------------------------------------


% pct_land
pct_land = pct_land .* 100; % [] to [%]


% Mean Sea Level Pressure
PSL_ctl = PSL_ctl ./ 100; % [Pa] to [hPa]
PSL_irr = PSL_irr ./ 100; % [Pa] to [hPa]


% convert LandFlux-EVAL and GLEAM evapotranspiration fluxes
if flags.eval == 1   
LHF_lfev_8905    = ET_lfev_8905    ./ 1E3 ./ 365.25 ./ 86400 .* Lvap .* rhow; % from [mm yr^-1] to [W m^-2]
LHF_glea         = ET_glea         ./ 1E3 ./ 365.25 ./ 86400 .* Lvap .* rhow; % from [mm yr^-1] to [W m^-2]
LHF_lfev_8905_mm = ET_lfev_8905_mm ./ 1E3           ./ 86400 .* Lvap .* rhow; % from [mm d^-1] to [W m^-2]
LHF_glea_mm      = ET_glea_mm      ./ 1E3           ./ 86400 .* Lvap .* rhow; % from [mm d^-1] to [W m^-2]
end

