function [FWHM, xl, xr, mx, xmx] = findFWHM(x, fx, methods)
%findFWHM: Finds the full width half max (FWHM) of a function
%
%	[FWHM, xl, xr, m, xm] = findFWHM(x, fx, [methods]);
%
%	FWHM	= Full width half maximum
%	xl, xr	= x positions of the half maximum (left & right)
%	m		= Maximum
%	xm		= Position of maximum
%
%	x		= Domain
%	fx		= f(x) - function to find width
%	methods = 2x1 vector to determine method of finding FWHM
%
%methods(1): How to find maximum (m), xm(nx) = MAXIMUM[f(x)]
%	0, 'simple': [m, nx] = max(fx);
%	1, 'interp': [xm, mx] = fminbnd(@(xm) ppval(pp, xm), x(max(1, nmx-1)), 
%					x(min(Nx, nmx+1))) [DEFAULT]
%
%methods(2): How to find positions of half maximum
%	0, 'linear': Linear fit (approximate, fastest)
%	1, 'newton': Newton-Raphson style (fzero) (prob. most accurate, OK speed) 
%			[DEFAULT]
%
%NOTES:
%	This method will find the first & last half maximum only.
%
%	Authors:
%		Dr Adam S Wyatt (a.wyatt@physics.ox.ac.uk)
%
%	See also: findFWHM, fminsearch, fzero

if (~exist('methods', 'var') || isempty(methods))
	methods = [1; 2];
end

if isscalar(methods)
	methods = [1; 1]*methods;
end

if x(2)<x(1)
	x = flipud(x);
	fx = flipud(fx);
end

Nx = length(x);

%	Get index of maximum value
%	----------------------------------------------------------------------------
[mx, nmx] = max(fx);		%	Find maximum value and index
xmx = x(nmx);
mx = abs(mx);

%	Extract half-data sets
%	----------------------------------------------------------------------------
indl = find(x<=xmx);
indr = find(x>=xmx);
xl = x(indl);
xr = x(indr);
fxl = fx(indl);
fxr = fx(indr);

%	Get peak value & half peak value
%	----------------------------------------------------------------------------
switch (lower(methods(1)))
	%	search for peak
	case {1, 'interp'}
		pp = spline(x, -fx);
		[xmx, mx] = fminbnd(@(xm) ppval(pp, xm), x(max(1, nmx-1)), ...
			x(min(Nx, nmx+1)));
% 		[xm, mx] = fminsearch(@(xm) ppval(pp, xm), x(nmx));
		mx = abs(mx);
		mx2 = mx/2;
	otherwise
		mx2 = mx/2;
end

%	Find positions of half maxima
%	----------------------------------------------------------------------------

%	Find first/last crossings with half maximum
nl = find(fxl<mx2, 1, 'last');
nr = find(fxr<mx2, 1, 'first');

switch lower(methods(2))
	
	case {0, 'linear'}
		if length(xl)<=1 || isempty(nl)
			xl = xl(1);
		else
			dxl = xl(nl+1) - xl(nl);
			dfxl = fxl(nl+1) - fxl(nl);
			xl = xl(nl) + (mx2-fxl(nl)) * dxl/dfxl;
		end
		
		if length(xr)<=1 || isempty(nr)
			xr = xr(end);
		else
			dxr = xr(nr) - xr(nr-1);
			dfxr = fxr(nr) - fxr(nr-1);
			xr = xr(nr) + (mx2-fxr(nr)) * dxr/dfxr;
		end

	%	Newton-Raphson (fzero)
	otherwise
		if length(xl)<=1 || isempty(nl)
			xl = xl(1);
		else
			pp = spline(xl, fxl-mx2);
			xl = fzero(@(xl) ppval(pp, xl), xl(nl + [0 1]));
		end
		
		if length(xr)<=1 || isempty(nr)
			xr = xr(end);
		else
			pp = spline(xr, fxr-mx2);
			xr = fzero(@(xr) ppval(pp, xr), xr(nr - [1 0]));
		end
		
end
		
%	Get FWHM
FWHM = abs(xr-xl);

if isempty(FWHM)
	FWHM = nan;
end

end