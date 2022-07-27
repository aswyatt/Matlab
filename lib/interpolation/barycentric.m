function [R, w] = barycentric(x, xx, d)
% barycentric: Performs Barycentric Rational Interpolation
%
%	[R, w] = barycentric(x, xx, d)
%
%	R	= interpolation matrix: yy = R*y
%	w	= Vector of weights used for interpolation
%	x	= Sampling axis (column vector)
%	xx	= Interpolation axis (column vector)
%	d	= Order of interpolation
%
%	This function could be optimized for speed.
%
%	see also PWBARYCENTRIC, NEVILLE1, NEVILLE2, INTERP1
%
%  	Authors:
%  		Dr Adam S. Wyatt (a.wyatt1@physics.ox.ac.uk)


Nx = length(x);
w = zeros(1, Nx);

%	Calculate vector of weights
for k=0:Nx-1
	nmin = max(k-d, 0);
	if (k>=Nx-d)
		nmax = Nx-d-1;
	else
		nmax = k;
	end
	
	if mod(nmin, 2)
		temp = -1;
	else
		temp = 1;
	end
	
	summ = 0;
	for n=nmin:nmax
		mmax=min(n+d, Nx-1);
		m = [(n:k-1) (k+1:mmax)]';
		term = prod((x(k+1) - x(m+1)));
		term = temp/term;
		temp = -temp;
		summ = summ + term;
	end
	w(k+1) = summ;
end


%	Calculate interpolation matrix
temp = bsxfun(@rdivide, w, bsxfun(@minus, xx, x.'));
R = bsxfun(@rdivide, temp, sum(temp, 2));
R(~isfinite(R)) = 1;
R = bsxfun(@rdivide, R, sum(R, 2));
