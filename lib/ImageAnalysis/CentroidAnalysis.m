function [x0, y0, major, minor, rotation] = CentroidAnalysis(I, OPTIONS)
arguments
	I
	OPTIONS.Squeeze(1,1) logical = true
	OPTIONS.Dim(1,2) = 1:2
	OPTIONS.PixelSize;
end

dim = OPTIONS.Dim;
S = sum(I, dim);

%	Probably quicker to do on each integral
% I = I./S;

%	Get co-ordinates
[Ny, Nx] = size(I, dim);
x = (1:Nx);
y = (1:Ny)';

%	Calculate image marginals
x1 = sum(x .* I, dim)./S;
y1 = sum(y .* I, dim)./S;
x2 = sum(x.^2 .* I, dim)./S;
y2 = sum(y.^2 .* I, dim)./S;
xy = sum((y.*x) .* I, dim)./S;

X2 = x2 - x1.^2;
Y2 = y2 - y1.^2;
XY = xy - x1.*y1;

%	Rotation
rotation = .5*atan2d(2*XY, X2-Y2);

%	Widths
major = real(2*sqrt(X2 + Y2 + sign(X2-Y2).*sqrt((X2-Y2).^2 + 4*XY.^2)));
minor = real(2*sqrt(X2 + Y2 - sign(X2-Y2).*sqrt((X2-Y2).^2 + 4*XY.^2)));

%	Check major/minor axes
% if major<minor
% 	[major, minor] = Swap(minor, major);
% end

if OPTIONS.Squeeze
	x0 = squeeze(x1);
	y0 = squeeze(y1);
	major = squeeze(major);
	minor = squeeze(minor);
	rotation = squeeze(rotation);
end

if isfield(OPTIONS, "PixelSize")
	x0 = x0 * OPTIONS.PixelSize;
	y0 = y0 * OPTIONS.PixelSize;
	major = major * OPTIONS.PixelSize;
	minor = minor * OPTIONS.PixelSize;
end