%CHNG_RNG:	Converts between frequency and wavelength
%
%	y = chng_rng(x)
%	y = chng_rng(x1, x2, ..., xN)
%	y = chng_rng(..., 'SpeedOfLight', val)
%
%	Uses formula:
%		y = 2*pi*c./x;
%
%	Default value of SpeedOfLight = 299.792458 (converts [nm] <--> [rad/fs])
%
%  	Authors:
%  		Dr Adam S. Wyatt (adam.wyatt@stfc.ac.uk)

function varargout = Convert_wl(varargin, Opt)
arguments (Repeating)
	varargin
end
arguments
	Opt.SpeedOfLight = 1e-6*Constants.c
end

N = max(1, min(nargout, nargin));
varargout = varargin(1:N);
for n=1:N
	if iscell(varargin{n})
		[varargout{n}{1:length(varargin{n})}] = Convert_wl(varargin{n}{:});
	else
		varargout{n} = 2*pi*Opt.SpeedOfLight./varargin{n};
	end
end
