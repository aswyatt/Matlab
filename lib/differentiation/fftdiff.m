function gxn = fftdiff(fx, dx, n, dim, tol, dump)
%fftdiff: Differentiation via FFT
%
%	gxn = fftdiff(fx, [dx], [n], [dim], [tol], [dump])
%
%	gxn	= nth order gradient (integral if n<0)
%	fx	= Function, must be evenely sampled
%	dx	= Sampling resolution (default = 1)
%	n	= nth order gradient (default = 1)
%	dim = Dimension to operate on (default = first non-singleton)
%	tol	= Tolerance for boundary conditions (default = 1e-6)
%	dump = Clear persistent variables
%
%	NOTES:
%		This method has periodic boundary conditions. Hence if the function is
%		non-periodic (i.e. fx(1) ~= fx(end)), the function is symmeterized.
%		The gradient/integral will be incorrect near the boundary.
%
%	Authors:
%		Dr Adam S Wyatt (a.wyatt1@physics.ox.ac.uk
%
%	See also: fft, ifft, diff, gradient

persistent N DIM yn nn DX;

if (exist('dump', 'var') && dump)
	chng_N = 1;
	chng_dim = 1;
	chng_n = 1;
	chng_dx = 1;
else
	chng_N = 0;
	chng_dim = 0;
	chng_n = 0;
	chng_dx = 0;
end

%	Get dimension & size of dimension
Nf = size(fx);
if (~exist('dim', 'var') || isempty(dim))
	dim = find(Nf>1, 1, 'first');
end
Nfd = Nf(dim);

%	Check for resolution
if (~exist('dx', 'var') || isempty(dx))
	dx = 1;
end

%	Check for differential order
if (~exist('n', 'var') || isempty(n))
	n = 1;
end

%	Check for tolerance
if (~exist('tol', 'var') || isempty(tol))
	tol = 1e-6;
end

%	Check if dimension changed
if (isempty(DIM) || (DIM~=dim))
	DIM = dim;
	chng_dim = 1;
end

%	Check if order changed
if (isempty(nn) || nn ~= n)
	nn = n;
	chng_n = 1;
end

%	Check for periodic boundary conditions - symmeterize otherwise
sym = 0;
if (abs(fx(1)-fx(end)) > tol)
	mask = cat(DIM, false(size(fx)), true(size(fx)));
	fx = cat(DIM, fx, flip(fx, DIM));
	Nfd = 2*Nfd;
	sym = 1;
end

%	Check of dimension size changed
if (isempty(N) || (N~=Nfd))
	N = Nfd;
	chng_N = 1;
end

%	Check if resolution changed
if (isempty(DX) || (isgpuarray(DX)&&~existsOnGPU(DX)) || (DX ~= dx))
	DX = dx;
	chng_dx = 1;
end

%	Update y axis if any dependent variable has changed, or it does not exist
if (chng_N || chng_dim || chng_n || chng_dx || isempty(yn))
	dy = 2*pi/(N*dx);
	yn = (1i*ifftshift(((0:N-1)'-floor(N/2))*dy)).^nn;
	if (DIM>1)
		yn = reshape(yn, [ones(1, DIM-1) N]);
	end
	if (nn<0)
		yn(~isfinite(yn)) = 0;
	end
end

gxn = real(ifft(fft(fx, [], DIM) .*yn, [], DIM));

if sym
	gxn = reshape(gxn(~mask), Nf);
end