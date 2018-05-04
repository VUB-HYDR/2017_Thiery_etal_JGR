

% --------------------------------------------------------------------
% function to plot domain data
% --------------------------------------------------------------------


function [] = mf_plot_dom2_log(lon,lat,var,caxis_dom,colormap_dom, flag_sp, flag_cb, panel, experiment, cbcaption)


% invoke globals
global island



% --------------------------------------------------------------------
% Initialisation
% --------------------------------------------------------------------


% Set grid characteristics - whole domain
% lat_min_dom =  -80.0;
lat_min_dom =  -70.0;
lat_max_dom =   80.0;
lon_min_dom = -177.5;
lon_max_dom =  177.5;


% set model resolution
res_lat = 0.9; 
res_lon = 1.25;


% set sea color
seacolor = [0.9 0.9 0.9]; % light grey


% define contours
Contours = [0.1 1 10 100 1000 10000];



% --------------------------------------------------------------------
% Visualisation
% --------------------------------------------------------------------


% design figure
if flag_sp == 0
figure('OuterPosition',[100 200 800 500]);
set(gcf, 'color', 'w');
set(gca,'color','w');
end


% Initialise grid and projection
m_proj('Equidistant Cylindrical','long',[lon_min_dom lon_max_dom],'lat',[lat_min_dom lat_max_dom]);                                        % generate Equidistant Cylindrical projection (alternatives: Miller or Mercator)
m_grid('box','on','tickdir','in','color',[0, 0, 0], 'Fontweight', 'Bold', 'FontSize', 11, 'linewidth', 1.5, 'linestyle', 'none'); hold on; % draw grid with normal box


% plot light grey background
var(island==0) = NaN;
hback          = m_pcolor(lon - res_lon/2,lat + res_lat/2,ones(size(var))); hold on;                                 
set(hback, 'edgecolor', 'none', 'facecolor', seacolor); 


% plot data
g = m_pcolor(lon - res_lon/2,lat + res_lat/2, log(var .* island));                                                               % with shading flat will draw a panel between the (i,j),(i+1,j),(i+1,j+1),(i,j+1) coordinates of the lon/lat matrices with a color corresponding to the data value at (i,j).
set(g, 'edgecolor', 'none');                                                                                       % remove black grid around pixels 
set(gca, 'Fontsize', 14, 'Fontweight', 'Bold');                                                                    % set axes properties
caxis(log(caxis_dom));                                                                                                  % set colorscale axes
colormap(colormap_dom); mf_freezeColors;                                                                           % select colormap and freeze it
if flag_cb == 1
    colorbar('Fontsize', 14, 'Fontweight', 'Bold', 'YTick',log(Contours),'YTickLabel',Contours); hold on;     
    cbfreeze; mf_freezeColors;
elseif flag_cb == 2
    c=colorbar('location', 'SouthOutside', 'Fontsize', 14, 'Fontweight', 'Bold', 'XTick',log(Contours),'XTickLabel',Contours, 'TickLength', [0 0]); hold on;     
    y1=get(gca,'position');
    y=get(c,'Position');
    y(4)=0.03;
    set(c,'Position',y)
    set(gca,'position',y1)
    mf_freezeColors;
end
hold on;
m_gshhs('cc','color','k');                                                                                         % add coastline


% add text
m_text(-175,81,panel,'ver','bottom','hor','left', 'Fontweight', 'Bold', 'Fontsize', 12); hold on;
m_text(175,81,experiment,'ver','bottom','hor','right', 'Fontweight', 'Bold', 'Fontsize', 11); hold on;
if flag_cb == 1
    m_text(240,0,cbcaption,'ver','bottom','hor','center', 'Fontweight', 'Bold', 'Fontsize', 12,'rotation',-90); hold off;
elseif flag_cb == 2
    m_text(0,-125,cbcaption,'ver','bottom','hor','center', 'Fontweight', 'Bold', 'Fontsize', 12); hold off;
end


end
