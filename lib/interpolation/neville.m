%% NEVILLE algorithm for polynomial interpolation
% Creates a matrix to perform piecewise polynomial interpolation
% 
%	This function calculates the polynomial fitting co-efficients given the
%	original domain, and the interpolant domain (and order).
%
%	Usage:
%		P = neville(x, xx, n)
%
%		P	= polynomial coefficients
%		x	= Original axis
%		xx	= Interpolated axis
%		n	= Polynomial order
%%
function P = neville(x, xx, n) %#codegen
	coder.varsize('P');

	%	Padding array of zeros
	Nxx = length(xx);
	Z = zeros(Nxx, 1);
	if (Nxx==1)
		x = x(:);
	end
	
	%	Initial values
	xi = x(:, 1);
	xj = x(:, end);
	dx = xi - xj;

	P = [(xx-xj)./dx, (xi-xx)./dx];

	%	Traverse Neville's tree to calculate polynomial co-efficients
	for nn = n-1:-1:1
		xi = x(:, 1:end-nn);
		xj = x(:, nn+1:end);
		dx = xi - xj;
		
		vj = bsxfun(@minus, xx, xj)./dx;
		vi = bsxfun(@minus, xi, xx)./dx;
		P = [P.*vj Z] + [Z P.*vi];
	end
end