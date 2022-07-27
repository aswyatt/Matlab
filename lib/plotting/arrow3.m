%arrow3: Draws a 3D arrow
%
%	h = arrow3;
%	h = arrow3(arrow3);
%	h = arrow3(start, finish, radii, lengths, color, vertices, edges);
%	h = arrow3(..., Property1, Value1, Property2, Value2, ...);
%	h = arrow3(Property1, Value1, Property2, Value2, ...);
%
%	radii:
%		Set the first and last values to zero to close ends.
%		For standard arrow, use radii = [0 r1 r2 r2 r3 0], where r1 and r3 are 
%		the outer width of the tail / head respect, and r2 is the width of the
%		stem.
%
%	lengths:
%		The first and last elements are always 0 and 1 respectively.
%		The relative position of each radii. For example, a standard arrow could
%		be [0 .2 .2 .8 .8 1].
%
%	color:
%		Can either be a flat color or CData
%
%	vertices:
%		Number of points along the circumference of the tail/head.
%
%	edges:
%		true/false - determines whether to draw edges
%
%	Author:
%		Adam S Wyatt
classdef arrow3 < handle

	%	========================================================================
	
	properties
% 		start(3, 1) double {mustBeFinite} = zeros(3,1);
% 		finish(3, 1) double {mustBeFinite} = ones(3,1);
% 		radii(:, 1) double {mustBeFinite, mustBeNonnegative, ...
% 			mustBeNonempty} = [0 .2 .2 1 0];
% 		lengths(:, 1) double {mustBeFinite, mustBeNonnegative, ...
% 			mustBeNonempty, mustBeLessThan(lengths, 1)} = [0 0 .9 .9 1];
		start;
		finish;
		radii;
		lengths;
		color;
		vertices;
		handle;
		edges;
		edge_handles;
	end
	
	%	========================================================================

	properties (SetAccess = protected)
		theta;
		X;
		Y;
		Z;
		Nr;
	end
			
	%	========================================================================

	methods

		%	--------------------------------------------------------------------
		
		%	Constructor
		function obj = arrow3(varargin)
			Init = {'start', [0 0 0]; ...
				'finish', [1 0 0]; ...
				'radii', [0 .1 .1 .5 0]; ...
				'lengths', [0 0 .75 .75 1]; ...
				'color', [0 0 1]; ...
				'vertices', 32; ...
				'edges', true};
			
			%	Check input type
			if nargin<1
				
				%	Empty - use defaults
				for n=1:size(Init, 1)
					obj.(Init{n, 1}) = Init{n, 2};
				end
				
				Properties = {};
				Values = {};
				
			elseif isa(varargin{1}, 'arrow3')

				Properties = varargin(2:2:end-1);
				Values = varargin(3:2:end);
				
				old = varargin{1};
				for n=1:size(Init, 1)
					obj.(Init{n, 1}) = old.(Init{n,1});
				end
				
			elseif ischar(varargin{1})
				
				%	Property/Value pair
				Properties = varargin(1:2:end-1);
				Values = varargin(2:2:end);
				for n=1:size(Init, 1)
					ind = strcmpi(Properties, Init{n,1});
					if any(ind)
						obj.(Init{n,1}) = Values{ind};
						Properties(ind) = [];
						Values(ind) = [];
					else
						obj.(Init{n,1}) = Init{n,2};
					end
				end
				
			else

				%	Ordered list
				for N=1:nargin
					if ischar(varargin{N})
						N = N-1;
						break;
					end
				end
				
				for n=1:N
					if ~isempty(varargin{n})
						obj.(Init{n,1}) = varargin{n};
					else
						obj.(Init{n,1}) = Init{n,2};
					end
				end
				
				for n=N+1:size(Init, 1)
					obj.(Init{n, 1}) = Init{n, 2};
				end
				
				for n=nargin+1:size(Init,1)
					obj.(Init{n,1}) = Init{n, 2};
				end
				
				Properties = varargin(N+1:2:end-1);
				Values = varargin(N+2:2:end);
				
			end %	Input type
			
			obj.setcoord;
			obj.draw;
			for n=1:length(Properties)
				set(obj.handle, Properties{n}, Values{n});
			end
			
		end %	Constructor
	
		%	--------------------------------------------------------------------
		
		function set.start(obj, s)
			if numel(s)~=3
				error('Start must be [x, y, z] vector')

			else
				obj.start = s(:);
			end
			
			if ~isempty(obj.X)
				obj.setcoord;
			end
		end

		%	--------------------------------------------------------------------
		
		function set.finish(obj, f)
			if numel(f)~=3
				error('Finish must be [x, y, z] vector');
			else
				obj.finish = f(:);
			end
			
			if ~isempty(obj.X)
				obj.setcoord;
			end
		end
		
		%	--------------------------------------------------------------------
		
		function set.radii(obj, r)
			
			if any(r<0)
				error('Radii must be greater than or equal to zero.');
			end
			
			if length(r)<2
				error('Radii must contain at least 2 elements.');
			end
			
			obj.Nr = numel(r);
			obj.radii = reshape(r, 1, []);
			
			if ~isempty(obj.X)
				obj.setcoord;
			end
		end
				
		%	--------------------------------------------------------------------
		
		function set.lengths(obj, l)
			Nl = length(l);
			
			if any(l<0) || any(l>1)
				error('Lengths must be in range (0,1)');
			end
			
			if Nl~=obj.Nr
				if Nl~=(obj.Nr-2)
					error('length(lengths) must be equal to length(radii)');
				else
					l = [0; l(:); 1];
				end
			else
				if l(1) ~= 0
					l(1) = 0;
				end
				if l(end) ~= 1;
					l(end) = 1;
				end
			end
			
			obj.lengths = reshape(l, 1, []);

			if ~isempty(obj.X)
				obj.setcoord;
			end
		end
		
		%	--------------------------------------------------------------------
		
		function set.vertices(obj, N)
			if N<2
				error('vertices must be greater than 1');
			end
			obj.vertices = N;
			obj.theta = (0:N-1)'*2*pi/(N-1);

			if ~isempty(obj.X)
				obj.setcoord;
			end
		end
		
		%	--------------------------------------------------------------------

		function set.color(obj, c)
			if isequal(size(c), [1, 3])
				obj.color = c;
				if ~isempty(obj.handle)
					set(obj.handle, 'FaceColor', c);
				end
			elseif isequal(size(c), size(obj.Z))
				obj.color = c;
				if ~isempty(obj.handle)
					set(obj.handle, 'CData', c);
				end
			end
		end
		
		%	--------------------------------------------------------------------
		
		function set.edges(obj, val)
			if ~isempty(obj.edges) && obj.edges ~= val
				if ~val && ~isempty(obj.edge_handles)
					delete(obj.edge_handles);
					obj.edge_handles = [];
				elseif val
					obj.drawedges;
				end
			end
			
			obj.edges = val;
		end
			
		%	--------------------------------------------------------------------
		
	end %	methods
	
	%	========================================================================

	methods (Access = private)

		%	--------------------------------------------------------------------
		
		function setcoord(obj)
			delta = obj.finish-obj.start;
			L = realsqrt(sum(delta.^2));
			phixy = atan2(delta(2), realsqrt(sum(delta([1 3]).^2)));
			phixz = -atan2(delta(3), delta(1));
			
			V = [L*reshape(ones(obj.vertices, 1)*obj.lengths, 1, []); ...
				reshape(cos(obj.theta)*obj.radii, 1, []); ...
				reshape(sin(obj.theta)*obj.radii, 1, [])];
			V = arrow3.Ry(phixz)*arrow3.Rz(phixy)*V;
			
			obj.X = obj.start(1) + reshape(V(1,:), obj.vertices, []);
			obj.Y = obj.start(2) + reshape(V(2, :), obj.vertices, []);
			obj.Z = obj.start(3) + reshape(V(3, :), obj.vertices, []);
			
			if ~isempty(obj.handle)
				obj.redraw;
			end
		end

		%	--------------------------------------------------------------------

		function redraw(obj)
			set(obj.handle, 'XData', obj.X, 'YData', obj.Y, 'ZData', obj.Z);
			if isequal(size(obj.Z), obj.color)
				set(obj.handle, 'CData', obj.color);
			else
				set(obj.handle, 'CData', obj.Z, 'FaceColor', obj.color);
			end
			
			if obj.edges && ~isempty(obj.edge_handles)
				obj.redraw_edges;
			end
		end

		%	--------------------------------------------------------------------

		function draw(obj)
			tmp = get(gca, 'NextPlot');
			set(gca, 'NextPlot', 'Add');
			obj.handle = surf(obj.X, obj.Y, obj.Z);

			if isequal(size(obj.color), [1, 3])
				set(obj.handle, 'FaceColor', obj.color);
			end
			set(obj.handle, 'Linestyle', 'none');
			
			if obj.edges
				obj.drawedges;
			end
			set(gca, 'NextPlot', tmp);
		end

		%	--------------------------------------------------------------------

		function drawedges(obj)
			ind = (obj.radii>0);
			obj.edge_handles = line(obj.X(:, ind), obj.Y(:, ind), ...
				obj.Z(:, ind), 'Color', 'k');
		end

		%	--------------------------------------------------------------------
		
		function redraw_edges(obj)
			ind = (obj.radii>0);
			if ind~=length(obj.edge_handles)
				delete(obj.edge_handles);
				obj.drawedges;
			else
				for n=1:length(ind)
					set(obj.edge_handles(n), 'XData', obj.X(:, ind(n)), ...
						'YData', obj.Y(:, ind(n)), 'ZData', obj.Z(:, ind(n)));
				end
			end
		end
		
		%	--------------------------------------------------------------------
	
	end
	
	%	========================================================================

	methods (Static)

		%	--------------------------------------------------------------------
		
		function R = Rx(theta)
			R = [	1	0			0; ...
					0	cos(theta)	-sin(theta); ...
					0	sin(theta)	cos(theta)];
		end
		
		%	--------------------------------------------------------------------
		
		function R = Ry(theta)
			R = [	cos(theta)	0	sin(theta); ...
					0			1	0; ...
					-sin(theta)	0	cos(theta)];
		end
		%	--------------------------------------------------------------------
		
		function R = Rz(theta)
			R = [	cos(theta)	-sin(theta)	0; ...
					sin(theta)	cos(theta)	0; ...
					0			0			1];
		end
		
		%	--------------------------------------------------------------------
		
	end %	methods (Static)
	
	%	========================================================================

end %	classdef
	