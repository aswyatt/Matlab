%% 2D phase unwrapping
%
%	Method based on Martinez-Carranza et al (2017)
%	"Fast and accurate phase-unwrapping algorithm based on the transport of
%	intensity equation"
%	https://doi.org/10.1364/AO.56.007079
%
%	Usage:
%		UnwrappedPhase = unwrap2D(WrappedPhase)
%		UnwrappedPhase = unwrap2D(___, Name, Value)
%
%	WrappedPhase	= Wrapped 2D phase (Ny x Nx matrix)
%
%	Options
%		Tol		= Error tolerance (default = 0.1)
%		IterMax = Maximum number of iterations (default = 1)
%		Method	= Either "FFT" or "DCT" (default)
%
%	Author(s):
%		Adam S Wyatt (adam.wyatt@stfc.ac.uk)

function [UnwrappedPhase, err] = MartinezCarranza(WrappedPhase, Options)
arguments
	WrappedPhase {mustBeFinite, mustBeFloat}
	Options.Method(1,1) string {mustBeMember(Options.Method, ...
		["FFT", "DCT"])} = "DCT"
	Options.IterMax(1,1) {mustBePositive} = 1
	Options.Tol(1,1) {mustBeFinite, mustBePositive} = 0.1
end

%	Make sure phase is a matrix
assert(ismatrix(WrappedPhase) && ~isvector(WrappedPhase), ...
	"PHASE:Unwrap2D:MustBeMatrix", ...
	"Input phase must be a matrix")

%	Get size of phase array
[Ny, Nx] = size(WrappedPhase);

EXP = exp(1i*WrappedPhase);
switch Options.Method
	case "FFT"
		ny = (-Ny:Ny-1).';
		nx = (-Nx:Nx-1);
		f2 = ifftshift(ny.^2 + nx.^2);
		f2(1, 1) = 1;

		HREP = @(M) [M flip(M, 2)];
		VREP = @(M) [M; flip(M, 1)];
		REP = @(M) VREP(HREP(M));
		SUBS = @(M) M(1:Ny, 1:Nx);
		
		EXP = REP(EXP);
		UnwrappedPhase = SUBS(ifft2(fft2(imag( ...
			conj(EXP).*ifft2(f2.*fft2(EXP))))./f2));

	case "DCT"
		ny = (0:Ny-1).';
		nx = (0:Nx-1);
		f2 = (ny.^2 + nx.^2);
		f2(1, 1) = 1;

		DCT2 = @(p) dct(dct(p, [], 1), [], 2);
		IDCT2 = @(p) idct(idct(p, [], 1), [], 2);

		UnwrappedPhase = IDCT2(DCT2(imag( ...
			conj(EXP).*IDCT2(f2.*DCT2(EXP))))./f2);
end

if nargout<2 && Options.IterMax<=1
	return
end

%	Iteration refinement
ERR = @(dP) sqrt(mean(abs2(wrapToPi(dP)), "all"));
Iter = 1;
dP = WrappedPhase-UnwrappedPhase;
err = repmat(ERR(dP), [Options.IterMax 1]);
while Iter<Options.IterMax && err(Iter)>Options.Tol
	Iter = Iter + 1;
	dP0 = dP;
	dP = unwrap2D.MartinezCarranza(dP, "Method", Options.Method);
	UnwrappedPhase = UnwrappedPhase + dP;
	dP = WrappedPhase-UnwrappedPhase;
	err(Iter) = ERR(dP-dP0);
end
err(Iter+1:end) = err(Iter);

end

