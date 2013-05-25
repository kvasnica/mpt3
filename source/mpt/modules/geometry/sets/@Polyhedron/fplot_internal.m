function h = fplot_internal(obj, function_name, options)
%
% Plot function over a single polyhedron
%
% This is an internal helper called from ConvexSet/fplot. No error checks
% are performed. Implicitly assumes the object is a single polyhedron.

fun = obj.getFunction(function_name);

h = [];

% if the Polyhedon consist of just one point change the default marker to "."
if size(obj.He,1)>=obj.Dim
	marker = '.';
else
	marker = 'none';
end

% get color as RGB vector
if ischar(options.color) || isempty(options.color)
	options.color = charToColor(options.color, options.colormap, ...
		options.array_index, options.colororder);
end

if obj.Dim<2
	% plot 1D sets
	obj.outerApprox();
	x = linspace(obj.Internal.lb, obj.Internal.ub, options.grid)';
	y = zeros(size(x));
	for j=1:numel(x)
		v = fun.feval(x(j));
		y(j) = v(options.position);
	end
	
	hl = line(x, y, 'Color', options.color, ...
		'LineStyle', options.linestyle, ...
		'LineWidth', options.linewidth, ...
		'Marker', marker);
	h = [h; hl(:)];
	
else
	% plot 2D sets
	if isa(fun, 'AffFunction') && ~options.contour
		obj.minVRep();
		X = obj.V;
		V = zeros(size(X,1), 1);
		
		% TODO: exploit vectorization once Function/feval supports it
		% V = fun.feval(V');
		for j=1:size(X,1)
			t = fun.feval(X(j, :)');
			V(j, 1) = t(options.position);
		end
		[~, ~, vv]= svd([X V]);
		n = vv(:, 3);
		I = orderForPlot([X V], n);
		
		hp = patch('Vertices', [X V], 'Faces', I(:)', ...
			'LineStyle', options.linestyle, ...
			'LineWidth', options.linewidth, ...
			'FaceAlpha', options.alpha,...
			'EdgeColor', [0 0 0],...
			'FaceLighting', 'phong',...
			'AmbientStrength', 0.7,...
			'FaceColor', options.color,...
			'Marker', marker);
		h = [h; hp(:)];
		
	else
		[X,Y] = obj.meshGrid(options.grid);
		
		% Sample the function at the X,Y points
		%             if obj.Func{i}.canVectorize
		%                 q = [X(:) Y(:)];
		%                 I = ~any(isnan(q),2);
		%                 v = obj.Func{i}.feval(q(I,:));
		%                 V = NaN*X(:);
		%                 V(I,:) = v(pos2);
		%                 V = reshape(V,size(X,1),size(X,2));
		%             else
		V = NaN*X;
		for j = 1:size(X,1)
			for k = 1:size(X,2)
				x = [X(j,k);Y(j,k)];
				if isnan(x(1)) || isnan(x(2)), continue; end
				t = fun.feval(x');
				if isempty(t) || any(isnan(t)), continue; end
				V(j,k) = t(options.position);
			end
		end
		%             end
		
		% Plot the function
		if options.alpha == 0 && strcmp(options.linestyle, 'none')
			hs = [];
		else
			if options.contour
				hs = surfc(X,Y,V,'facecolor', options.color,...
					'linestyle', options.linestyle, ...
					'linewidth', options.linewidth, ...
					'facealpha', options.alpha,...
					'facelighting', 'phong',...
					'AmbientStrength', 0.7,...
					'Marker', marker);
			else
				hs = surf(X,Y,V,'facecolor', options.color,...
					'linestyle', options.linestyle, ...
					'linewidth', options.linewidth, ...
					'facealpha', options.alpha,...
					'facelighting', 'phong',...
					'AmbientStrength', 0.7,...
					'Marker', marker);
			end
		end
		h = [h; hs(:)];
		
		%                 % Add a contour plot
		%                 if  options.contour
		%                     held=ishold;
		%                     hold on;
		%                     [C,c] = contour3(X,Y,V,options.contourGrid);
		%                     set(c,'linewidth',options.linewidth,'linestyle',options.linestyle);
		%                     h = [h;c(:)];
		%                     if ~held, hold off; end
		%                 end
		
	end
end

% plot the polyhedron if required
if options.show_set
	hv = obj.plot(options);
	h = [h; hv(:)];
end

smoothLines(h);

end
