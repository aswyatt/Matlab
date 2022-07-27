%% Fourier Series Evaluation
% Evaluates the Fourier series along the domain x as a function of the Cosine
% (even) and Sine (odd) amplitude co-efficients and the function frequency w0:
%
%	Usage:
%		S = FourEval(A, B, w0, x)
%
%	Where:
%		A  = Cosine (even) amplitude co-efficients 
%		B  = Sine (odd) amplitude co-efficients
%		w0 = base frequency
%		x  = Domain axis
%%

function S = FourierSeries(A, B, w0, x)

S = 0;
w0 = reshape(w0, [1 size(w0)]);

Na = size(A);
if Na(1)
	S = S + sum(bsxfun(@times, reshape(A, [1 Na]), ...
		cos(bsxfun(@times, x*(1:Na), w0))), 2);
% 	S = S + sum(bsxfun(@times, reshape(A, 1, Na), cos(x*w0*(1:Na))), 2);
end

Nb = size(B);
if Nb(1)
	S = S + sum(bsxfun(@times, reshape(B, [1 Nb]), ...
		sin(bsxfun(@times, x*(1:Na), w0))), 2);
% 	S = S + sum(bsxfun(@times, reshape(B, 1, Nb), sin(x*w0*(1:Nb))), 2);
end

S = squeeze(S);
% sz = size(S);
% sz(2) = [];
% if length(
% S = reshape(S, sz, []);

% S = squeeze(S);

%	Alternative form - may implement later
% S = sum(bsxfun(@times, A, ...
% 	sin(bsxfun(@plus, bsxfun(@times, w0*(1:length(A)), x), phi))), 2);
