%	1D complex interpolation along r, phi co-ordinates:
%
%	zz = interp1z(x, z, xx)
%	[rr, pp] = interp1z(x, z, xx)
%	[...] = interp1z(..., method_r, extrap_r, method_p, extrap_p);
%	zz = z(xx) = r(xx)exp(i*phi(xx)) = rr.*exp(i*pp)
%
%	x:	Input co-ordinate
%	z:	Input complex number
%	xx:	Output co-ordinate
%
%	Optional arguments applied to radial/angle co-ordinates
%	method: Method of interpolation ('linear', 'cubic', etc.)
%	extrap: Extrapolation value
%
%	r(xx) = interp1(x, abs(z), xx, ...)
%	phi(xx) = interp1(x, unwrap(angle(phi)), xx, ...)
%
%	Aditional arguments are same 
function varargout = interp1z(x, z, xx, method_r, extrap_r, method_p, extrap_p)

if ~exist('method_r', 'var')
	method_r = 'linear';
end

if ~exist('extrap_r', 'var')
	extrap_r = [];
end

if ~exist('method_p', 'var')
	method_p = method_r;
end

if ~exist('extrap_p', 'var')
	extrap_p = extrap_r;
end

r = abs(z);
p = unwrap(angle(z));

if ~isempty(extrap_r)
	rr = interp1(x, r, xx, method_r, extrap_r);
else
	rr = interp1(x, r, xx, method_r);
end

if ~isempty(extrap_p)
	pp = interp1(x, p, xx, method_p, extrap_p);
else
	pp = interp1(x, p, xx, method_p);
end

if nargout==1
	varargout = {rr.*exp(i*pp)};
else
	varargout = {rr, pp};
end