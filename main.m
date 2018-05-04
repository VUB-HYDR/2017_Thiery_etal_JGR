
% --------------------------------------------------------------------
% main script to postprocess and visualise CESM output: CTL and IRR
% --------------------------------------------------------------------


tic


% clean up
clc;
clear;
close all;


% flags
flags.eval  = 0; % 0: do not evaluate model
                 % 1: evaluate model
flags.stat  = 1; % 0: do not compute statistical significance of change
                 % 1: compute statistical significance of change
flags.STCD  = 0; % 0: do not decompose the Surface Temperature change
                 % 1: decompose the Surface Temperature change
flags.perc  = 0; % 0: do not compute percentile changes
                 % 1: compute percentile changes
flags.local = 0; % 0: do not compute local effect
                 % 1: compute local effect
flags.offli = 0; % 0: do not process offline simulations
                 % 1: process offline simulations
flags.valp  = 0; % 0: do not compute values used in the paper
                 % 1: compute values used in the paper
flags.plot  = 1; % 0: do not plot
                 % 1: plot



% --------------------------------------------------------------------
% initialisation
% --------------------------------------------------------------------


% declare globals
global island                                                              %#ok<NUSED>


% add matlab scripts directory to path
addpath(genpath('C:\Users\u0079068\Documents\Research\matlab_scripts'));


% add directory containing nc files to path
addpath(genpath('C:\Users\u0079068\Documents\Research\CESM_present\ncfiles'));


% initialise model parameters
nens        = 5;   % number of ensemble members


% initialise time parameters - CESM
time_begin  = [1981, 1, 1, 0,0,0];
time_end    = [2010,12,31,23,0,0];
years       = (time_begin(1):time_end(1))';
nyears      = length(years);


% initialise physical constants
[Lvap, rhow, a_earth] = mf_inicon('Lvap', 'rhow', 'a_earth');


% initialise srex variable/unit/region names - TSA                           
srex_vars    = {'QIRRIG'  , 'TSA'  , 'Qle'    , 'FSH'    , 'FSA'     , 'FIRA'    , 'PRECT'        , 'QRUNOFF'       }; % srex variables considered in this study ...
srex_ylabels = {'Q_i_r_r' , 'T_2_m', 'LHF'    , 'SHF'    , 'SW_n_e_t', 'LW_n_e_t', 'Precipitation', 'Q_R_U_N_O_F_F' }; % ... their y-axis label,
srex_units   = {'mm d^-^1', 'K'    , 'W m^-^1', 'W m^-^1', 'W m^-^1' , 'W m^-^1' , 'mm d^-^1'     , 'mm d^-^1'      }; % ... their units,
srex_block   = {'lnd'     , 'lnd'  , 'lnd'    , 'lnd'    , 'lnd'     , 'lnd'     , 'atm'          , 'lnd'           }; % ... and whether it's a land or atmospheric variable
srex_reg     = {'WNA', 'CNA', 'MED', 'WAS', 'SAS', 'SEA', 'EAS'};                                                      % srex regions considered in this study


% initialise observational product names   
prod_names = {'Qirr census', 'LHF LandFlux', 'LHF GLEAM', 'SWnet SRB', 'LWnet SRB', 'T2m CRU', ' Precipitation CRU', ' Precipitation GPCP', 'TXx GHCNDEX', 'TXx HadEx2', 'TNn GHCNDEX', 'TNn HadEx2'};



% --------------------------------------------------------------------
% load data
% --------------------------------------------------------------------


ms_load



% --------------------------------------------------------------------
% manipulations: general
% --------------------------------------------------------------------


ms_manip



% --------------------------------------------------------------------
% Model evaluation
% --------------------------------------------------------------------


if flags.eval == 1   
   ms_evaluation;
end



% --------------------------------------------------------------------
% Statistical significance
% --------------------------------------------------------------------


if flags.stat == 1   
   ms_statsign;
end



% --------------------------------------------------------------------
% Surface Energy Balance decomposition
% --------------------------------------------------------------------


if flags.STCD == 1
   ms_STCdecomp
end



% --------------------------------------------------------------------
% Percentile change
% --------------------------------------------------------------------


if flags.perc == 1
   ms_perc
end



% --------------------------------------------------------------------
% local effects
% --------------------------------------------------------------------


if flags.local == 1
   ms_local
end



% --------------------------------------------------------------------
% get values used in the paper
% --------------------------------------------------------------------


if flags.valp == 1
   ms_valp
end



% --------------------------------------------------------------------
% visualise output
% --------------------------------------------------------------------


if flags.plot == 1
   ms_plotscript
end




toc
