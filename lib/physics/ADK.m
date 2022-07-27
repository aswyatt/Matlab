%ADK: **INCORRECTLY** Calculates the ionization rate via the ADK formula
%
%Usage:
%	W = ADK(Et, Ip, Z, l, m, ls)
%
%	W	= Ionization rate
%	Et	= Real electric field in time
%	Ip	= Ionization potential energy
%	Z	= Final charge
%	l,m,ls = Quantum numbers
%
%Defaults:
%	Z	= 1
%	l	= 1
%	m	= 0
%	ls	= 0
%
%	Use atomic units
function W = ADK(Et, Ip, Z, l, m, ls)
arguments
	Et
	Ip
	Z = 1
	l = 1
	m = 0
	ls = 0
end

ns = Z.*(2*Ip).^(-.5);
Ep = (2*Ip).^1.5;
C2 = 2.^(2*ns)./(ns.*gamma(ns+ls+1).*gamma(ns-ls));
ms = abs(m);
r = (2*l+1).*factorial(l+ms)/(2.^ms .* factorial(ms) .* factorial(l-ms));

Et = abs(Et);
Et(Et==0)=nan;
R = Et./Ep;
R1 = 1./R;
R1(~isfinite(R1)) = 0;

%	Calculate rate
W = C2 .* sqrt((3/pi)*R) .* Ip .* r .* (2*R1).^(2*ns-ms-1) ...
	.* exp(-(2/3)*R1);
W(isnan(W)) = 0;	%	Remove nans
