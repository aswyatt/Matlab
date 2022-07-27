%% saddle: Performs stationary phase approximation to a Fourier transform.
%
%	Calculates the Fourier transform of A(w)exp[i phi(w)], where A(w) and phi(w) are real
%	functions, via a stationary phase approximation.
%
%	E[t(ws)]	= int{A(w)exp[i phi(w) - i w t] dw}
%				~ sqrt{i 2 pi / (d/dw)^2[phi(ws)]} 
%					* A(ws) * exp{i [phi(ws) - ws*(d/dw)[phi(ws)]}
%					where t(ws) = (d/dw)[phi(ws)] and ws is the stationary phase
%
%USAGE:
%	[E_t, t_ws, phi_t] = saddle(Aw, phiw, ws, t, NP, phiw1, phiw2)
%
%	OUTPUT:
%	E_t		= Fourier transform of A(w)exp[i phi(w)] via stationary phase approximation
%	t_ws	= values of t(ws) for which E[t(ws)] has been evalutaed at.
%
%	INPUT:
%	Aw		= Absolute value of function to FT.
%	phiw	= Phase of function to FT
%	ws		= Stationary values of the frequency to calculate the integral at.
%	t		= times to evaluate integral for	...	...	...	...	...	...	(1)
%	NP		= Order of polynomial fit of phase	... ... ... ...	...	...	(2)
%	phiw1	= First derivative of spectral phase (d/dw)[phi(ws)]	...	(2)
%	phiw2	= Second derivative of spectral phase (d/dw)^2[phi(ws)]	...	(2)
%
%NOTES:
%
%	(1)	If t is not given, E[t(ws)] is evaluated for all ws = w, and 
%		t(ws) = (d/dw)[phi(ws)]. Otherwise, E[t(ws)] is interpolated via a cubic
%		spline onto the points t.
%
%	(2)	If phiw1 and phiw2 are not given, then the first and second derivatives of
%		the	phase must be calculated. This is done by performing a polynomial fit of 
%		order NP to the phase, and then calculating the first and second derivatives 
%		from this polynomial. If NP is not supplied, a 4th order polynomial is used.
%		If phiw1 AND phiw2 are supplied, NP is not required and the input values for 
%		the first and second derivatives are used. Note that these derivatives must be
%		evaluated at ws = w.
%
% EXAMPLE:
% 	Nw = 2^15;							%	Number of sampling points
% 	c = 299.7925;						%	Speed of light (nm/fs)
% 	wmin = 2*pi*c/1500;					%	Min frequency
% 	wmax = 2*pi*c/500;					%	Max frequency
% 	w0 = 2*pi*c/800;					%	Central frequency
% 	dw = (wmax-wmin)/(Nw-1);			%	Frequency spacing
% 	w = (0:Nw-1)'*dw + wmin;			%	Frequency axis
% 	lambda = 2*pi*c./w;					%	Wavelength axis
% 	dt = 2*pi/(Nw*dw);					%	Temporal spacing
% 	t = ((0:Nw-1)'-floor(Nw/2))*dt;		%	Time axis
% 
% 	Aw = exp(-((w-w0)/.4).^2);			%	Spectral amplitude
% 	phiw = polyval([-.5 2 13 -15 0]*1e3, w-w0);	%	Spectral phase
% 	
% 	%	Temporal field via FFT (slow due to large Time-Bandwidth-Product [TBP])
% 	tic
% 	Et1 = fftshift(fft(ifftshift(Aw.*exp(i*phiw)))) * dw;
% 	toc
% 
% 	%	Temporal field via SPA (over whole range)
% 	tic
% 	[Et2, t2] = my_SPA(Aw, phiw, w, [], 4);
% 	toc
% 
% 	%	Temporal field over limited temporal range
% 	dt3 = 250*dt;
% 	t3 = (-2e4:dt3:-1e4)';
% 	tic
% 	Et3 = my_SPA(Aw, phiw, w, t3);
% 	toc
% 
% 	%	Temporal field over a range of stationary frequencies
% 	dw4 = 1000*dw;
% 	wmin4 = (wmax + 2*wmin)/3;
% 	wmax4 = (2*wmax + wmin)/3;
% 	w4 = (wmin4:dw4:wmax4)';
% 	Aw4 = exp(-((w4-w0)/.4).^2);
% 	phiw4 =  polyval([-.5 2 13 -15 0]*1e3, w4-w0);
% 	tic
% 	[Et4, t4] = my_SPA(Aw4, phiw4, w4, [], 4);
% 	toc
% 
% 	%	Temporal field over range of times, using limited range of stationary freq
% 	tic
% 	Et5 = my_SPA(Aw4, phiw4, w4, t3, 4);
% 	toc
% 
% 	%	Plot results
% 	subplot(2,1,1)
% 	plot(t, abs(Et1), '.', t2, abs(Et2), '.', t3, abs(Et3), '.', ...
% 		t4, abs(Et4), 'x-', t3, abs(Et5), '.');
% 	xlabel('Time (fs)');
% 	ylabel('Electric field amplitude (arb.)')
% 	title('Temporal electric field using different methods over different ranges')
% 	legend('DFT', 'SPA, full', 'SPA full + interpolated', ...
% 		'SPA with defined ws', 'SPA with defined ws and interpolated')
%
% 	subplot(2,1,2)
% 	plot(t, abs(Et1), '.', t2, abs(Et2)+.0025, '.', t3, abs(Et3)+.005, '.', ...
% 		t4, abs(Et4)+.0075, '.-', t3, abs(Et5)+.01, '.');
% 	xlabel('Time (fs)');
% 	ylabel('Electric field amplitude (arb.)')
% 	title('Temporal electric (offset) field using different methods over different ranges')
% 	legend('DFT', 'SPA, full', 'SPA full ws with limited output', ...
% 		'SPA with limited stationary frequencies', 'SPA with limited ws and t')

function [E_t, t_w, phi_t] = saddle(Aw, phiw, w, t, NP, phiw1, phiw2)

if (~exist('NP', 'var') || isempty(NP))
	NP = 4;
end

%	Perform polynomial fit
if (nargin<6)
	w0 = mean(w);
	ind = (0:NP);
	P = polyfit(w-w0, phiw, NP);
	P1 = (NP - ind(1:end-1)) .* P(1:end-1);
	P2 = (NP - ind(1:end-2) - 1) .* P1(1:end-1);
	phiw1 = polyval(P1, w-w0);
	phiw2 = polyval(P2, w-w0);
end

t_w = phiw1;
E_t = sqrt(2*pi*1i./phiw2);
phi_t = phiw - w.*phiw1 + angle(E_t);
E_t = abs(E_t).*Aw.*exp(1i*phi_t);

if (exist('t', 'var') && ~isempty(t))
	E_t = spline(t_w, abs(E_t), t).*exp(1i*spline(t_w, unwrap(angle(E_t)), t));
end

end
