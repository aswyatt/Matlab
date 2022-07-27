function H = AnnotateAxes(varargin)
if nargin && isscalar(varargin{1}) && ishghandle(varargin{1})
	H = varargin{1};
	dn = 1;
else
	H = gca;
	dn = 0;
end

grid(H, 'on');
FUN = {@title @xlabel @ylabel @zlabel};
STR = {'Title', 'x-axis', 'y-axis', 'z-axis'};
for n=1:4
	N = n+dn;
	if nargin>=N && ~isempty(varargin{N})
		str = varargin{N};
	else
		str = STR{n};
	end
	FUN{n}(H, str);
end

if nargin>dn+4
	set(H, varargin{dn+4:end});
end