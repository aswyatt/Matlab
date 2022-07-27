function I = gauss2D_R(X, Y, dx, dy, theta, order)
arguments
	X {mustBeNumeric}
	Y {mustBeNumeric}
	dx {mustBeNumeric} = 1
	dy {mustBeNumeric} = 1
	theta {mustBeNumeric} = 0
	order {mustBeNumeric, mustBePositive, mustBeInteger} = 1
end
%GAUSS2D_R: Calculates a rotated 2D gaussian (cylindrical)
%
%	Usage:
%		y = gauss2D_R(X, Y, FWHM_x, FWHM_y, theta, order);
%
%		X		= Matrix of x indices
%		Y		= Matrix of y indices
%		FWHM_x	= FWHM in x dimension
%		FWHM_y	= FWHM in y dimension
%		theta	= Rotation angle in degress (+ve = anticlockwise)
%		order	= Gaussian order
%
%
%  	Authors:
%  		Dr Adam S. Wyatt (a.wyatt1@physics.ox.ac.uk)
%
%	See also: gauss1D, gauss2D_XY

order = abs(floor(order));
X_ = ((cosd(theta) .* X) - (sind(theta) .* Y));
Y_ = ((sind(theta) .* X) + (cosd(theta) .* Y));
R_ = ((X_./dx).^2 + (Y_./dy).^2);
I = exp(-log(2)*(2.^(2*order))*(R_.^order));
