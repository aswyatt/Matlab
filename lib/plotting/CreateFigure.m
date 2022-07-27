function fig = CreateFigure(FontName, FontSize, LineWidth, varargin)

if ~exist('FontName', 'var') || isempty(FontName)
	FontName = 'Times';
end

if ~exist('FontSize', 'var') || isempty(FontSize)
	FontSize = 16;
end

if ~exist('LineWidth', 'var') || isempty(LineWidth)
	LineWidth = 3;
end

if ishghandle(varargin{1})
	fig = varargin{1};
	set(fig, varargin{2:end});
elseif isnumeric(varargin{1})
	fig = figure(varargin{1});
	set(fig, varargin{2:end});
else
	fig = figure(varargin{:});
end

set(fig, 'WindowStyle', 'normal');
set(fig, 'PaperPositionMode', 'auto');

%	Set default font sizes etc
set(fig, ...
	'DefaultLineLineWidth', LineWidth, ...
	'DefaultTextFontName', FontName, ...
	'DefaultTextFontSize', FontSize, ...
	'DefaultAxesFontName', FontName, ...
	'DefaultAxesFontSize', FontSize, ...
	'DefaultAxesLineWidth', LineWidth);

end
