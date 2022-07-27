function UnwrappedPhase = simple(WrappedPhase, nx0, ny0, Options)
arguments
	WrappedPhase {mustBeFloat}
	nx0 {mustBeScalarOrEmpty, mustBeInteger, mustBePositive, mustBeFinite} = []
	ny0 {mustBeScalarOrEmpty, mustBeInteger, mustBePositive, mustBeFinite} = []
	Options.ColumnBased(1,1) logical = true
	Options.Tol = pi
end

%	Check inputs
assert(ismatrix(WrappedPhase) && ~isvector(WrappedPhase) ...
	&& ~isscalar(WrappedPhase), ...
	"PHASE:Unwrap2D:MustBeMatrix", ...
	"Input phase must be a matrix")

[Ny, Nx] = size(WrappedPhase);

if isempty(nx0)
	nx0 = ceil(Nx/2);
end

if isempty(ny0)
	ny0 = ceil(Ny/2);
end

Tol = Options.Tol;

p0 = WrappedPhase(ny0, nx0);

if Options.ColumnBased
	UnwrappedPhase = unwrap(WrappedPhase, Tol, 1);
	p = unwrap(UnwrappedPhase(ny0, :), Tol);
	UnwrappedPhase = UnwrappedPhase - UnwrappedPhase(ny0, :) ...
		+ p-p(nx0) + p0;
else
	UnwrappedPhase = unwrap(WrappedPhase, Tol, 2);
	p = unwrap(UnwrappedPhase(:, nx0), Tol);
	UnwrappedPhase = UnwrappedPhase - UnwrappedPhase(:, nx0) ...
		+ p-p(ny0) + p0;
end

end

