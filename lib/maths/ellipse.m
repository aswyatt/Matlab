function I_out = ellipse(x, y, x0, y0, dx, dy, theta)
%ELLIPSE: Creates an elliptical mask
%
%	I_out = ellipse(X, Y, x0, y0, dx, dy, theta)
%
%	I_out	= Output mask (1s & 0s)
%	X		= Input matrix of X indices (as created by repmat)
%	Y		= Input matrix of Y indices (as created by repmat)
%	x0		= Centre of ellipse (x-coord.)
%	y0		= Centre of ellipse (y-coord.)
%	dx		= Radius of ellipse (x-coord.)
%	dy		= Radius of ellipse (y-coord.)
%	theta	= Angle of rotation (degrees)
%
%  	Authors:
%  		Dr Adam S. Wyatt (a.wyatt1@physics.ox.ac.uk)


x = bsxfun(@minus, x, x0);
y = bsxfun(@minus, y, y0);
if (exist('theta', 'var') && ~isempty(theta) && theta)
	%	Rotate matrices
	c = cosd(theta);
	s = sind(theta);
	X = bsxfun(@minus, ...
		bsxfun(@times, c, x), ...
		bsxfun(@times, s, y));
	Y = bsxfun(@plus, ...
		bsxfun(@times, s, x), ...
		bsxfun(@times, c, y));
	I_out = (bsxfun(@plus, bsxfun(@rdivide, X, dx).^2, ...
		bsxfun(@rdivide, Y, dy).^2) <= 1);
else
	I_out = (bsxfun(@plus, bsxfun(@rdivide, x, dx).^2, ...
		bsxfun(@rdivide, y, dy).^2) <= 1);
end