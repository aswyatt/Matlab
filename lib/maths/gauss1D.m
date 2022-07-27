function y = gauss1D(x, x0, FWHM, order)
%GAUSS1D: Creates a gaussian function.
%
%   E = gauss1D(x, x0, FWHM, order)
%     = exp(-log(2)*(2*(x-x0)./FWHM).^(2*floor(abs(order))));
%
%	x		= Domain
%	x0		= Centre position
%	FWHM	= Full width half max
%	order	= Gaussian order
%
%  	Authors:
%  		Dr Adam S. Wyatt (a.wyatt1@physics.ox.ac.uk)
%
%	See also: gauss2D_R, gauss2D_XY

% E = exp(-log(2)*(2*(x-x0)./FWHM).^(2*floor(abs(order))));

x = x - x0;
x = 2*x ./ FWHM;
xn = x .^ (2*floor(abs(order)));
y = exp(-log(2)*xn);