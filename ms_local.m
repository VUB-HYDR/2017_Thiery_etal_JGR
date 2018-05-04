
% --------------------------------------------------------------------
% Local effects routine
% note: preferably run "main"
% --------------------------------------------------------------------


% note:
% Since we expected there would be some non-linearities, we tested computing
% the total, local and non-local effect for each member, and then averaging
% out at the end only. This yields exactly the same result as performing
% the analysis on the ensemble mean!



% --------------------------------------------------------------------
% manipulations: compute local effect
% --------------------------------------------------------------------


% % % TV change
% % dTV_total        = TV_irr             - TV_ctl;
% % dTV_local        = TV_pft_irr(:,:,17) - TV_pft_irr(:,:,16);
% % dTV_local_scaled = dTV_local .* pct_irr ./ 100;
% % dTV_local_scaled(isnan(dTV_local_scaled)) = 0;
% % dTV_nonlocal     = dTV_total - dTV_local_scaled;


% TS change
dTS_total        = TS_irr             - TS_ctl;
dTS_local        = TS_pft_irr(:,:,17) - TS_pft_irr(:,:,16);
% % dTS_local_scaled = dTS_local .* pct_irr ./ 100;
% % dTS_local_scaled(isnan(dTS_local_scaled)) = 0;
% % dTS_nonlocal     = dTS_total - dTS_local_scaled;

% ET change
dET_total        = ET_irr             - ET_ctl;
dET_local        = ET_pft_irr(:,:,17) - ET_pft_irr(:,:,16);
% % dET_local_scaled = dET_local .* pct_irr ./ 100;
% % dET_local_scaled(isnan(dET_local_scaled)) = 0;
% % dET_nonlocal     = dET_total - dET_local_scaled;
