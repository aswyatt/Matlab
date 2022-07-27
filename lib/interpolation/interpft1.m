function fxx = interpft1(x, fx, xx, dim, fun)
%interpft1: 1D Fourier interpolation
%
%	fxx = interpft(x, fx, xx, [dim], [@fun])
%
%	fxx		= interpolated data
%	x		= Original grid (evenly spaced)
%	fx		= Sampled data
%	xx		= New grid
%	dim		= Dimension to operate on (default = 1)
%	fun		= Function for performing interpolation (default = sinc((x-xj)/X)
%
%	Authors:
%		Dr Adam S Wyatt (a.wyatt1@physics.ox.ac.uk)
%
%	See also: interpft, interp1

if (~exist('fun', 'var') || isempty(fun))
	fun = @sinc;
end

if (~exist('dim', 'var') || isempty(dim))
	dim = find(size(x)>1, 1, 'first');
end

Nx = size(x);
Nxx = mysize(xx);
Nfx = mysize(fx);

xx = reshape(xx, [ones(size(Nfx)) Nxx]);

xmax = max(x, [], dim);
xmin = min(x, [], dim);
dx = (xmax-xmin)/(Nx(dim)-1);
F = fun(bsxfun(@minus, xx/dx, x/dx));
fxx = squeeze(sum(bsxfun(@times, fx, F), dim));

[Nfxx, Mfxx] = mysize(fxx);
if (numel(Nfxx)==1 && Mfxx(1)==1)
	fxx = reshape(fxx, [], 1);
end

end