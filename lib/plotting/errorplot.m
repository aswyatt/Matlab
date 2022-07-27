function h = errorplot(x, y, e, LineProp, ErrorProp)
% errorplot: Plots data and its error as a transparent area
%
%	h = errorplot(x, y, e, LineProp, ErrorProp)
%
%	h = array of plot handles: h(1) = data, h(2) = error
%	x = x-axis
%	y = data
%	e = error (half-width of shaded area)
%	col = RGB colour plot of data, default = [0 0 1] = blue
%
%  	Authors:
%  		Dr Adam S. Wyatt (a.wyatt1@physics.ox.ac.uk)

h = gobjects(2,1);
tmp = get(gca, 'NextPlot');

if (~exist('x', 'var') || isempty(x))
	x = (1:length(y))';
end

if (~exist('LineProp', 'var') || isempty(LineProp))
	LineProp = {'Color', 'b', 'LineStyle', '-'};
end
h(1) = line(x, y, LineProp{:});

if (~exist('ErrorProp', 'var') ||isempty(ErrorProp))
	ErrorProp = {'FaceColor', get(h(1), 'Color'), 'EdgeColor', 'n', ...
		'FaceAlpha', .25};
end

ErrorProp = FindStr(ErrorProp, 'FaceColor', get(h(1), 'Color'));
ErrorProp = FindStr(ErrorProp, 'EdgeColor', 'n');
ErrorProp = FindStr(ErrorProp, 'FaceAlpha', .25);

set(gca, 'NextPlot', 'add');
h(2) = fill([x; flipud(x)], [y+e; flipud(y-e)], [0 0 1], ErrorProp{:});
set(gca, 'NextPlot', tmp);

if ~strcmpi(get(gcf, 'Renderer'), 'OpenGL')
	set(h(2), 'FaceAlpha', 1, 'FaceColor', 1-(1-get(h(2), 'FaceColor'))/4);
end

delete(h(1))
h(1) = line(x, y, LineProp{:});

end

function CellArray = FindStr(CellArray, Str, Val)

N = length(CellArray);
Found = false;
for n=1:N
	if strcmpi(CellArray{n}, Str)
		Found = true;
		break;
	end
end

if ~Found
	CellArray{N+1} = Str;
	CellArray{N+2} = Val;
end

end
% set(h(1), '
% line_handles = line(x,y,'Color','b');
% style = 1;
% for i = 1:length(line_handles)
%     if style > length(LSO), style = 1;end
%     set(line_handles(i),'LineStyle',LSO(style,:))
%     style = style + 1;
% end
% grid on

% h = zeros(2,1);
% hld = get(gca, 'NextPlot');
% h(1) = plot(x, y);
% 
% % hold on
% tmp = get(gca, 'NextPlot');
% set(gca, 'NextPlot', 'add');
% 
% h(2) = fill(COPY(x), COPY(y)+INVERT(e), col);
% set(gca, 'NextPlot', hld);
% set(h(1), 'Color', col);
% set(h(2), 'Linestyle', 'n', 'Facealpha', alpha);
% 
% set(gca, 'NextPlot', tmp);
