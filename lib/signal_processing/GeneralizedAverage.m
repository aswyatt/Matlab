%% GENERALIZED AVERAGE
% Calculates the generalized average of a series of data
%
%  Malek, J.; Kolinsky, P.; Strunc, J. & Valenta, J. 
%  Generalized average of signals (GAS) - A new method for detection of very
%  weak waves in seismograms
%  ACTA Geodynamica Et Geomaterialia, 2007, 4, -5
%
%	yp = GeneralizedAverage(y, p, [window])
%
%	yp		= generalized average (to power p)
%	y		= Original data 2D: y(x, n) = y_n(x)
%	window	= Optional window to wavelet analysis
%
%	For a series of data y(x, n) = y_n(x), the generalized average is given by:
%	yp = y0*s^p
%	y0 = mean(y, 2)
%	s = |y0|/sqrt(N*sum(abs(y).^2, 2))
%
%	The generalized average works for delta functions. For sinusoidal data, the
%	generalized average should be performed on the Fourier transform:
%
%	yp = ifft(GeneralizedAverage(fft(y), p))
%
%	For general data, one needs to apply a windowing function such as a hann /
%	hamming window:
%
%	yp = GeneralizedAverage(y, p, @window(Nw))
%
%	Where Nw is even and 2*size(y, 1)/Nw is an integer and @window is a window
%	generator (see wintool)
%
%	Example:
%
%	N = 1000;
%	x = (1:N)';
%	y = gauss1D(x, N/2, N/5, 1).*cos(.1*x);
%	Y = bsxfun(@plus, y, randn(N, 10));
%	yp = GeneralizedAverage(Y, 5, hann(N/10));
%	plot(x, normalize([y mean(Y, 2), yp], 1))
%
%	Authors: 
%		Adam S Wyatt
%
%	See also WINTOOL, HANN, HAMMING
%%
function y = GeneralizedAverage(y, p, window, FT)

if ~exist('p', 'var') || isempty(p)
	p = 1;
end

dim = ndims(y);

if exist('window', 'var') && ~isempty(window)
	N = ones(1, ndims(y)+1);
	[N(1), N(end)] = size(window);
	y = y.*reshape(window./sum(window, 2), N);
	windowed = true;
else
	windowed = false;
end

if windowed || ~exist('FT', 'var') || isempty(FT)
	FT = true;
end

if FT
	y = fft(y);
end

ym = mean(y, dim);
S = abs(ym)./sqrt(mean(abs(y).^2, dim));

y = ym.*S.^p;
if FT
	y = ifft(y);
end

if windowed
	y = sum(y, ndims(y));
end

end