%% 2D phase unwrapping
%
%	Method based on Ghiglia and Romero (1994) 
%	"Robust two-dimensional weighted and unweighted phase unwrapping that uses
%	fast transforms and iterative methods"
%	https://doi.org/10.1364/JOSAA.11.000107
%
%	Usage:
%		UnwrappedPhase = unwrap2D(WrappedPhase)
%		UnwrappedPhase = unwrap2D(WrappedPhase, Weights)
%		UnwrappedPhase = unwrap2D(ComplexAmplitude, Weights)
%		UnwrappedPhase = unwrap2D(___, Name, Value)
%
%	WrappedPhase	= Wrapped 2D phase (Ny x Nx matrix)
%	Weights			= Matrix of weights same size as psi
%	ComplexAmplitude= Weights * exp(i * WrappedPhase)
%
%	Options
%		Tol		= Error tolerance (default = 1e-6)
%		IterMax = Maximum number of iterations (default = Ny*Nx)
%
%	Author(s):
%		Adam S Wyatt (adam.wyatt@stfc.ac.uk)

function UnwrappedPhase = Ghiglia(WrappedPhase, Weights, Options)
arguments
	WrappedPhase {mustBeFinite, mustBeFloat}
	Weights {mustBeFinite, mustBeFloat} = []
	Options.Tol {mustBeFinite, mustBePositive, mustBeScalarOrEmpty} = 1e-6
	Options.IterMax {mustBePositive}
end

assert(ismatrix(WrappedPhase) && ~isvector(WrappedPhase), ...
	"PHASE:Unwrap2D:MustBeMatrix", ...
	"Input phase must be a matrix")

assert(~isgpuarray(WrappedPhase), ...
	"PHASE:Unwrap2D:gpuArrayNotSupported", ...
	"Currently GPU arrays are not supported");

if ~isreal(WrappedPhase)
	Weights = abs(WrappedPhase);
	WrappedPhase = angle(WrappedPhase);
end

%	Get size of phase array
[Ny, Nx] = size(WrappedPhase);

if ~isfield(Options, "IterMax")
	Options.IterMax = Ny*Nx;
end

%	Calculate phase array differences
dx = wrapToPi(diff(WrappedPhase, 1, 2));
dy = wrapToPi(diff(WrappedPhase, 1, 1));

%	Generate zero vectors
zx = zeros(Ny, 1, "like", WrappedPhase);
zy = zeros(1, Nx, "like", WrappedPhase);

%	Set up cosine matrix for inverse DCT
nx = cast((0:Nx-1)*pi/Nx, "like", WrappedPhase);
ny = cast((0:Ny-1)*pi/Ny, "like", WrappedPhase);
COS = 2 * (cos(ny).' + cos(nx) - 2);
COS(1) = 1;			%	Set bias

%	Difference matrix
DIFF = @(dx, dy) diff(dx, [], 2) + diff(dy, [], 1);

%	Function to Solve Poisson's equation
DCT2 = @(p) dct(dct(p, [], 1), [], 2);
IDCT2 = @(p) idct(idct(p, [], 1), [], 2);
SOLVE_POISSON = @(p) IDCT2(DCT2(p)./COS);

if isempty(Weights)
	%	========================================================================
	%	U N W E I G H T E D   S O L U T I O N
	%	========================================================================

	%	Pad the phase differences
	dx = horzcat(zx, dx, zx);
	dy = vertcat(zy, dy, zy);
	
	%	Calculate the measured Laplacian
	rho = DIFF(dx, dy);
	
	%	Solve the Poisson equation via a DCT
	UnwrappedPhase = SOLVE_POISSON(rho);
	
else
	%	========================================================================
	%	W E I G H T E D   S O L U T I O N
	%	========================================================================
	
	%	Check size of weights
	assert(isequal(size(Weights), [Ny Nx]), ...
		"PHASE:unwrap2D:IncompatibleSize", ...
		"Weights must be same size as phase")

	EPS = Options.Tol;
	
	%	Calculate b-vector (eq 15)
	dx = horzcat(dx, zx);
	dy = vertcat(dy, zy);
	
	%	Multiply the vector b by weight square (W^T * W)
	W2 = Weights.^2;
	Wx = horzcat(zx, W2 .* dx);
	Wy = vertcat(zy, W2 .* dy);
	rk = DIFF(Wx, Wy);
	normR0 = norm(rk(:));

	%	Initialize iteration
	k = 0;
	UnwrappedPhase = 0*WrappedPhase;

	%	Perform algorithm 3
	while k<Options.IterMax && any(rk, "all") && ((norm(rk(:))/normR0)>EPS)
		zk = SOLVE_POISSON(rk);
		k = k + 1;
		
		if k>1
			betak = sum(rk .* zk, "all") / sum(rk1 .* zk1, "all");
			pk = zk + betak * pk;
		else
			pk = zk;
		end
		
		%	Save values for next round
		rk1 = rk;
		zk1 = zk;
		
		%	Perform scalar/vector updates (step 6)
		dx = horzcat(diff(pk, [], 2), zx);
		dy = vertcat(diff(pk, [], 1), zy);
		Wx = horzcat(zx, W2.*dx);
		Wy = vertcat(zy, W2.*dy);
		Qpk = DIFF(Wx, Wy);

		alphak = sum(rk .* zk, "all") / sum(pk .* Qpk, "all");
		UnwrappedPhase = UnwrappedPhase + alphak * pk;
		rk = rk - alphak * Qpk;
	end
end
end
