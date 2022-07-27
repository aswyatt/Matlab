function Elapsed_Time(n, IDstr, dn1, N1, str1, RS)
%	Elapsed_Time: Displays time elapsed and remaining in an iteration loop
%
%	Elapsed_Time(n, IDstr, dn, N, str, RS)
%
%	n = current iteration
%	IDstr = ID string to identify timer (default = 'DEFAULT')
%	dn = Output step size (only output when ~mod(n, dn) *persistent*
%	N = Maximum iterations *persistent*
%	str = Display string function *persistent*
%		= @(n, N, sr, se, st)
%			--> n = iteration number
%			--> N = total number of iterations
%			--> sr = remaining time string (HH:MM:SS)
%			--> se = elapsed time string (HH:MM:SS)
%			--> st = total time string (HH:MM:SS)
%	RS = reset timing flag
%
%	Usage:
%		Elapsed_Time([], IDstr, dn, N, [str], true)
%		Loop over n
%			Elapsed_Time(n, IDstr)
%		end loop
persistent N dn str ticID

if isempty(N)
	N = struct;
end
if isempty(dn)
	dn = struct;
end
if isempty(str)
	str = struct;
end

if isempty(ticID)
	ticID = struct;
end

if ~exist('IDstr', 'var') || isempty(IDstr)
	IDstr = 'DEFAULT';
end

if exist('N1', 'var') && ~isempty(N1)
	N.(IDstr) = N1;
end

if exist('dn1', 'var') && ~isempty(dn1)
	dn.(IDstr) = dn1;
end

if exist('str1', 'var') && ~isempty(str1)
	str.(IDstr) = str1;
end

if ~isfield(N, IDstr)
	error('Must supply maximum iterations');
end

if ~isfield(dn, IDstr)
	dn.(IDstr) = 1;
end

if ~isfield(str, IDstr)
	%	String should have 5 input arguments:
	%	ID = ID string
	%	n = iteration number (integer)
	%	N = total iterations (integer)
	%	sr = time remaining string ('HH:MM:SS')
	%	se = time elapsed string ('HH:MM:SS')
	%	st = total time string ('HH:MM:SS')
	str.(IDstr) = @(ID, n, N, sr, se, st) sprintf(...
		['ID: %s, Remaining: %s, Elapsed: %s, Total: %s, ' ...
		'iteration: %d of %d (%.1f%%%%)\n'], ...
		ID, sr, se, st, n, N, n/N*100);
end

if exist('RS', 'var') && ~isempty(RS) && RS
	ticID.(IDstr) = tic;
end

if exist('n', 'var') && ~isempty(n) && ~mod(n, dn.(IDstr))
	Elapsed = toc(ticID.(IDstr));
	Ratio = n/N.(IDstr);
	Total = Elapsed/Ratio;
	Remaining = Total - Elapsed;
	fprintf(str.(IDstr)(IDstr, n, N.(IDstr), MakeStr(Remaining), ...
		MakeStr(Elapsed), MakeStr(Total)));
end
end

function s = MakeStr(T)
[S, M] = mymod(T, 60);
[M, H] = mymod(M, 60);
s = sprintf('%02d:%02d:%02d', H, M, round(S));
end