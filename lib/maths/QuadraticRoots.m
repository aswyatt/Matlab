%	Find roots of quadratic equation
%
%	a*x^2 + 2*b*x + c
%
%	[x1, x2] = QuadraticRoots(a, b, c)
%	[x1, x2] = QuadraticRoots(a, b, c, Real)
%
%	x1, x2 = roots
%	If Real==true, set complex roots to nan
%
%	NOTE the factor 2b
function [x1, x2] = QuadraticRoots(a, b, c, Options)
arguments
	a {mustBeNumeric, mustBeFinite}
	b {mustBeNumeric, mustBeFinite}
	c {mustBeNumeric, mustBeFinite}
	Options.Real(1,1) logical = true
end
%	This could be improved to select the appropriate root only, and to not
%	calculate invalid roots!

b2 = b.^2;

if a==1
	ac = c;
else
	ac = a.*c;
end
q = uminus(b + sign(b).*sqrt(b.^2 - ac));

x2 = c./q;
if a~=1
	x1 = q./a;
else
	x1 = q;
end

%	Set complex roots to nan
if Options.Real
	ind = (b2<ac);
	if any(ind, 'all')
		x1(ind) = nan;
		x2(ind) = nan;
	end
end
