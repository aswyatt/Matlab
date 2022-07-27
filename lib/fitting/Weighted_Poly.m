%% Weighted_Poly: Performs weighted polynomial fit
%
%	P	= Weighted_Poly(x, y, w, n)
%
%	P	= Column vector of polynomial co-efficients (n:-1:0)'
%
%	x	= x-axis (column vector)
%	y	= Data (matrix of column vectors)
%	w	= Weights (e.g. 1./sigma(y) - column vector)
%	n	= Order of fitting
%
%	Uses ldivide to calculate the weighted fit of the function:
%		Y = sum(P(i+1) * xi^(n-i), i=0..n)
%
%  	Authors:
%  		Dr Adam S. Wyatt (a.wyatt1@physics.ox.ac.uk)
%
%	See also LDIVIDE
%
%	Numerical Receipes 3rd Edition (15.4.2)
function [P, x0, Dx] = Weighted_Poly(x, y, w, n, normalize)	

if nargin>4 && normalize
	I = abs2(w);
	Is = abs(trapz(x, I));
	I = I ./ Is;
	x0 = abs(trapz(x, x.*I));
	Dx = sqrt(abs(trapz(x, (x-x0).^2.*I)));
	x = (x-x0)./Dx;
end

X = x.^(n:-1:0);
if exist('w', 'var') && ~isempty(w)
	X = X.*w;
	y = y.*w;
end


P = X\y;

