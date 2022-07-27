function I = gauss2D_XY(X, Y, FWHM_x, FWHM_y, theta, order)
%GAUSS2D_XY: Calculates a rotated 2D gaussian ('rounded square')
%
%	Usage:
%		y = gauss2(X, Y, FWHM_x, FWHM_y, theta, order);
%
%		X		= Matrix of x indices
%		Y		= Matrix of y indices
%		FWHM_x	= FWHM in x dimension
%		FWHM_y	= FWHM in y dimension
%		theta	= Rotation angle in degress (+ve = anticlockwise)
%		order	= Gaussian order
%
%	Set:
%		X = ones(Ny, 1) * ((0:Nx-1)*dx - x0)
%		Y = ((0:Ny-1)*dy - y0) * ones(1, Nx);
%
%  	Authors:
%  		Dr Adam S. Wyatt (a.wyatt1@physics.ox.ac.uk)
%
%	See also: gauss1D, gauss2D_R

order = 2*floor(abs(order));
% theta = theta*pi/180;

c = cosd(theta);
s = sind(theta);

%	Rotate co-ordinate axes:
%		Positive rotation of ellipse = counter-clockwise rotation = clockwise
%		rotation of co-ordinates --> transpose of rotation matrix
X_ = bsxfun(@plus, ...
	bsxfun(@times, c, X), ...
	bsxfun(@times, s, Y));
Y_ = bsxfun(@minus, ...
	bsxfun(@times, s, X), ...
	bsxfun(@times, c, Y));

X_ = bsxfun(@power, bsxfun(@rdivide, X_, FWHM_x), order);
Y_ = bsxfun(@power, bsxfun(@rdivide, Y_, FWHM_y), order);

I = exp(-bsxfun(@times, log(2)*(2.^order), bsxfun(@plus, X_, Y_)));
