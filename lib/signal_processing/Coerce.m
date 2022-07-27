%	Coerce values into defined range
%
%	[out, coerced] = Coerce(in, [mn], [mx]
%
%	If mn defined:
%		out(in<mn) = mn
%
%	If mx defined:
%		out(in>mx) = mx
%
%	Author(s)
%		Dr Adam S Wyatt (adam.wyatt@stfc.ac.uk)
function [out, coerced] = Coerce(in, mn, mx)

% if nargin>=3 && ~isempty(mn) && ~isempty(mx)
% 	ind = mx<mn;
% 	if any(ind(:))
% 		[mx(ind), mn(ind)] = Swap(mn(ind), mx(ind));
% 	end
% end

out = in;
% coerced = false(size(out));

if nargin>=2 && ~isempty(mn)
	out = max(out, mn);
% 	ind = (in<mn);
% 	if isscalar(mn)
% 		out(ind) = mn;
% 	else
% 		sz = size(ind)-size(mn);
% 		if any(sz)
% 			mn = repmat(mn, sz+1);
% 		end
% 		out(ind) = mn(ind);
% 	end
% 	coerced(ind) = true;
end

if nargin>=3 && ~isempty(mx)
	out = min(out, mx);
% 	ind = (in>mx);
% 	if isscalar(mx)
% 		out(ind) = mx;
% 	else
% 		sz = size(ind)-size(mx);
% 		if any(sz)
% 			mx = repmat(mx, sz+1);
% 		end
% 		out(ind) = mx(ind);
% 	end
% 	coerced(ind) = true;
end

if nargout>1
	coerced = (out~=in);
end

end
