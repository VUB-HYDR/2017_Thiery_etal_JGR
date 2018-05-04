
% --------------------------------------------------------------------
% subroutine to perform manipulations on loaded variables
% note: preferably run "main"
% --------------------------------------------------------------------



% --------------------------------------------------------------------
% manipulations: general
% --------------------------------------------------------------------


% get grid dimensions
[nlat, nlon] = size(lat_mod);


% get number of srex regions
nreg = length(srex_reg);


% get land pixel indices - excluding Antarctica
island                = pct_land > 50; 
island(lat_mod < -60) = 0;             % remove antarctica


% get land pixel indices - excluding Antarctica
isirr                = pct_irr > 10; 
isirr(lat_mod < -60) = 0;             % remove antarctica


% create date vectors
date_vec = datevec(datenum(time_begin):1:datenum(time_end));


% get corners of SREX regions used in this study and use them to generate srex masks
for i=1:nreg
    [~, pol_lat(i), pol_lon(i)] = mf_srex(lat_mod, lon_mod, PRECT_ctl, island, [], srex_reg{i}); %#ok<*SAGROW>
    issrex(:,:,i)               = inpolygon(lon_mod, lat_mod, pol_lon{i}, pol_lat{i}) & island;
end


