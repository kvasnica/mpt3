function h = plot(P, varargin)
% <matDoc>
% <funcName>plot</funcName>
% <shortDesc>Plot the polyhedron.</shortDesc>
% <longDesc>Plot the polyhedron.</longDesc>
%
% <syntax>
% <input name='color' type='paramValue'>- Set color
% - vector of length three specifying rgb value
% - character specifying color
% b     blue
% g     green
% r     red
% c     cyan
% m     magenta
% y     yellow
% k     black
% w     white
% - default is random
% </input>
% <input name='wire'       type='paramValue'>Plots in wireframe (true/false)</input>
% <input name='linestyle'  type='paramValue'>String giving style of the edges, e.g. '--' or '.-'</input>
% <input name='linewidth'  type='paramValue' default='1'>Edge width</input>
% <input name='alpha'      type='paramValue' default='0.9'>Level of transparency (0 - transparent, 1 - opaque)</input>
% <input name='marker'     type='paramValue'>Marker to indicate vertices (see options in Matlab plot)</input>
% <input name='markerSize' type='paramValue' default='6'>Size of markers</input>
% <input name='dim'        type='paramValue' default='1:3'>Dimensions to project the polyheron onto before plotting.</input>
% <output name='h'>Handle to the plot</output>
% </syntax>
%
% </matDoc>
%

global MPTOPTIONS
if isempty(MPTOPTIONS)
    MPTOPTIONS = mptopt;
end

error(nargoutchk(0,1,nargout));

if ~isempty(varargin)
	% allow plot(P, Q, R) and plot(P, 'color', 'y', Q, 'color', r)
	
	% put "P" into a copy of varargin
	args = {P, varargin{:}};
	
	% does varargin contain any more polyhedra?
	obj_pos = find(cellfun(@(x) isa(x, 'Polyhedron'), args));
	nobj = length(obj_pos);
	if nobj>1
		% multiple objects in arguments, extract options for each object
		obj_stack = cell(1, nobj); % stack of objects to plot
		arg_stack = cell(1, nobj); % stack of options for each object
		obj_pos = [obj_pos length(args)+1];
		for i = 1:nobj
			obj_stack{i} = args{obj_pos(i)};
			arg_stack{i} = args(obj_pos(i)+1:obj_pos(i+1)-1);
		end
		% now plot each object with its options
		h = [];
		prevHold = ishold;
		if ~ishold
			clf;
			grid on
		end
		hold on
		index = 1;
		for i = 1:length(obj_stack)
			args = arg_stack{i};
			% by putting 'index'=i at the end we override any 'index'
			% settings there might be in args
			for j = 1:length(obj_stack{i})
				hp = plot(obj_stack{i}(j), 'array_index', index, args{:});
				h = [h; hp(:)];
				index = index + 1;
			end
		end
		if ~prevHold
			hold off
		end
		if nargout==0
			clear h
		end
		return
	end
end

if length(P(:)) > 1,
	% deal with arrays
  prevHold = ishold;
  if ~ishold
      clf;
      grid on;
  end
  hold on;
  
  tic
  if nargout>0
      h = [];
  end
  for i=1:length(P),
    if toc > 2, drawnow; tic; end
    if nargout>0
        hp = plot(P(i), varargin{:}, 'array_index', i);
        h = [h; hp(:)];
    else
        plot(P(i), varargin{:}, 'array_index', i);
    end
  end
  
  if ~prevHold, hold off; end
    
  return;
end

if P.isEmptySet,
    if nargout>0
        h = []; 
    end
    return;
end

ip = inputParser;
ip.KeepUnmatched = true;
ip.addParamValue('color',  [], @validate_color);
ip.addParamValue('wire',       false,  @(x) islogical(x) || x==1 || x==0);
ip.addParamValue('linestyle',  '-', @validate_linestyle);
ip.addParamValue('linewidth',  1,   @isnumeric);
ip.addParamValue('alpha',      0.8, @(x) isnumeric(x) && x>=0 && x<=1);
ip.addParamValue('marker',     'none', @validate_marker);
ip.addParamValue('markerSize', 6, @isnumeric);
ip.addParamValue('colormap', 'mpt', @(x) (isnumeric(x) && size(x, 2)==3) || ischar(x)); 
ip.addParamValue('colororder', 'fixed', @(x) isequal(x, 'fixed') || isequal(x, 'random'));
% "array_index" is an internal property which denotes position of the plotted
% object in an array. It is used to get properl color in charToColor()
ip.addParamValue('array_index', 1, @validate_indexset);

ip.parse(varargin{:});
p = ip.Results;

% If color is a letter, rather than a vector then convert
if ischar(p.color) || isempty(p.color)
    clr = charToColor(p.color, p.colormap, p.array_index, p.colororder);
else
    clr = p.color;
end

if p.wire, p.alpha = 0; end


% Respect the current hold state
if ishold == false,
    clf;
    %   axis vis3d
    if P.Dim==1
        view(2);
    else
        view(3);
    end
    grid on;
end

if P.Dim > 3
  % TODO : Add options on what the users wants done here
  % For now... just tell them to read docs
  mpt_kblink(1); % provide the ID of the corresponding KB article
  error('Cannot plot polyhedra in more than 3 dimensions.')
end

% If we're trying to plot an affine hull, then create a bounding polytope and re-plot
if size(P.He,1) > 0 && size(P.H,1) == 0
    % some objects can be already plotted, take current axis
    xlim = get(gca,'Xlim');
    lb = xlim(1);
    ub = xlim(2);
    if P.Dim >= 2
        ylim = get(gca,'Ylim');
        lb = [lb;ylim(1)];
        ub = [ub;ylim(2)];
    end
    if P.Dim >= 3
        zlim = get(gca,'Zlim');
        lb = [lb;zlim(1)];
        ub = [ub;zlim(2)];
    end
    Q = Polyhedron('lb',lb,'ub',ub,'He',P.He);
    % in case Q is empty, put larger bounds and repeat eventually 100-times
    k=0;
    d = abs(ub-lb);
    while Q.isEmptySet
        lb = lb-d/2;
        ub = ub+d/2;
        Q = Polyhedron('lb',lb,'ub',ub,'He',P.He);
        k = k+1;
        if k>100
            break;
        end
    end
    
    if nargout>0
        h = Q.plot(varargin{:});
    else
        Q.plot;
    end
    return
end

% Compute the incidence map
% (also computes irredundant V-rep and H-rep)
iMap = P.incidenceMap;

V  = P.V;
R  = P.R;
H  = P.H;
He = P.He;

% if the Polyhedon consist of just one point change the default marker to "."
if size(He,1)>=P.Dim
    if strcmpi(p.marker,'none')
        p.marker='.';
    end
end
% Deal with silly cases. Dimension 0 and 1
if size(V,2) == 1
    if size(R,1) > 0 % Zero-dimensional or 1D ray
        if strcmp(p.marker, 'none')
            p.marker = '.';
            p.markerSize = max([15 p.markerSize]);
        end
        held = ishold; hold on;
        if nargout>0
            h = pplot(V, '.', 'marker', p.marker, 'markersize', p.markerSize, 'color', clr);
        else
            pplot(V, '.', 'marker', p.marker, 'markersize', p.markerSize, 'color', clr);
        end
        
        if size(R,1) == 1 % One dimensional ray
            if nargout>0
                h(2) = pplot([V;V+R/norm(R)],'-','linestyle',p.linestyle,'linewidth',p.linewidth);
            else
                pplot([V;V+R/norm(R)],'-','linestyle',p.linestyle,'linewidth',p.linewidth);
            end
        end
        
        if ~held, hold off; end
        return
    else % 1D or 0D polytope
        if nargout>0
            h = pplot(V, '.', 'marker', p.marker, 'markersize', p.markerSize, 'color', clr, ...
                'linestyle',p.linestyle,'linewidth',p.linewidth);
        else
            pplot(V, '.', 'marker', p.marker, 'markersize', p.markerSize, 'color', clr, ...
                'linestyle',p.linestyle,'linewidth',p.linewidth);
        end
        grid on;
        return
    end
end

% Lower-dimensional polyhedron
lowerDim = false;
if size(He,1) > 0
  H = He(1,:);
  lowerDim = true;
end

% Lift the 2D plot to 3D
if size(V,2) == 2
  V = [V zeros(size(V,1),1)];
  R = [R zeros(size(R,1),1)];
  
  % There's only one 'facet'
  H = [0 0 1 0];
  lowerDim = true;
end

newV = zeros(0,3);
if size(R,1) > 0
  
  %   % Choose a hyperplane that intersects all rays as close to the unit
  %   % circle as possible
  %   R = normalize(R);
  %   sol = Opt('H',2*(R'*R),'f',-2*sum(R,1),'A',-R,'b',zeros(size(R,1),1)).solve;
  % %   sol = mptSolve('H',2*(R'*R),'f',-2*sum(R,1),'A',-R,'b',zeros(size(R,1),1));
  %   if sol.exitflag ~= MPTOPTIONS.OK,
  %     warning('Solver error bounding the recession cone. This is likely because the polyhedron has a non-empty lineality space.');
  %     h = -1;
  %     return
  %   end

  if size(R,1) == 1
    sol.x = R';
  else
    sol.x = mean(normalize(R))';
  end
  sol.x = sol.x / norm(sol.x);
  if any(R*sol.x < -MPTOPTIONS.abs_tol),
      error('Could not find ray in strict interior of the recession cone');
  end
      
  % Move the hyperplane so that it's well outside the bounded portion of
  % the polyhedron
  PV   = Polyhedron('V',V);
  supp = PV.support(sol.x);
  B    = PV.outerApprox;
  sz   = max(B.Internal.ub - B.Internal.lb);
  supp = supp + max([2*sz 1]);
  % Our hyperplane is now sol.x'*y == supp
  
  % Add a ray to each vertex that shares at least two facets with the ray
  incVR = iMap.incVH*iMap.incRH' >= P.Dim - size(He,1) - 1;
  
  % newV are aritificial vertices generated from the rays
  nNewV = sum(incVR(:));
  newV = zeros(nNewV,3);
  k = 1;
  newLen = zeros(nNewV,1);
  for i=1:size(V,1)
    for j=1:size(R,1)
      if incVR(i,j)
        % Add vertex at x = V(i) + alpha*R(j)
        % Choose alpha s.t. x is in the hyperplane sol.x'*x == supp
        alpha = (supp-sol.x'*V(i,:)') / (sol.x'*R(j,:)');
        newV(k,:) = V(i,:) + alpha*R(j,:);
        newLen(k) = norm(alpha*R(j,:));
        k = k + 1;
      end
    end
  end
  newLen = mean(newLen);
end

% Data points
X = [newV;V];

% Compute incidence map
inc = abs(H*[X -ones(size(X,1),1)]')' < MPTOPTIONS.abs_tol;

% Convert from incidence map to Matlab face matrix
[I,J] = find(inc);
Faces = zeros(size(H,1),max([sum(inc,1) size(newV,1)]));
for i=1:size(H,1)
  v = I(J==i);
  
  % This inequality is weakly redundant
  % This happens e.q. when plotting a cone, since we add an artificial facet
  %   if isempty(v), remove(end+1) = i; continue; end
  if isempty(v),
    Faces(i,:) = NaN*ones(1,size(Faces,2));
    continue
  end
  
  % Order vertices for plot
  ord = orderForPlot(X(v,:),H(i,1:end-1));
  v = v(ord);
  
  Faces(i,:) = [v' NaN*ones(1,size(Faces,2)-length(v))];
end

% Plot!
set(gcf,'renderer','opengl');
h(1) = patch('Vertices', X, 'Faces', Faces, ...
  'FaceColor',           clr,...
  'FaceAlpha',           p.alpha,...
  'LineStyle',           p.linestyle,...
  'LineWidth',           p.linewidth,...
  'Marker',              p.marker,...
  'MarkerSize',          p.markerSize);

% Plot the 'endcap' in white
if size(R,1) > 0
  if lowerDim == false
    ord = orderForPlot(newV,sol.x);
    h(2) = patch('Vertices', newV, 'Faces', ord, ...
      'FaceColor',          [0 0 0],...
      'FaceAlpha',          0.75);
  else
    held = ishold; hold on;
    
    % newV contains two elements
    h(2) = pplot(newV, 'w-', 'linewidth', p.linewidth*2);
    
    if ~held, hold off; end
  end
  
  % Add an arrow on the unbounded facet
  held = ishold; hold on;
  %   axis(axis);
  if size(newV,1)>1
      x0 = mean(newV)';
  else
      x0 = newV';
  end
  x1 = x0 + 0.5*newLen*sol.x;
  
%   alpha = (1.5*supp-sol.x'*x0) / (sol.x'*sol.x);
%   x1 = x0 + alpha*sol.x;
  hl(1) = line([x0(1);x1(1)],[x0(2);x1(2)],[x0(3);x1(3)]);
  set(hl, 'linewidth', p.linewidth*1.5, 'color', 'k');
  hl(2) = plot3(x1(1),x1(2),x1(3),'k.','markersize',p.linewidth*15);
  h = [h(:); hl(:)];
%   axis tight; axis equal;
  if ~held, hold off; end
end

if P.Dim == 2 && ishold == false
  view(2);
%   axis normal
%   axis square
%   axis tight
end
if P.Dim == 3 %&& ishold == false
  %axis vis3d
  view(3)
end

% Make sure none of the axes collapse to zero
% v = axis;
% dx = v(2)-v(1); d = dx;
% dy = v(4)-v(3); d = [d dy];
% if length(v) == 6, dz = v(6)-v(5); d = [d dz]; end
% d = max(d);
% if abs(dx) < 0.1, v(1)=v(1)-d; v(2)=v(2)+d; end
% if abs(dy) < 0.1, v(3)=v(3)-d; v(4)=v(4)+d; end
% if length(v) == 6, if abs(dz) < 0.1, v(5)=v(5)-d; v(6)=v(6)+d; end; end
% axis(v);

% axis tight

% set(h, 'LineSmoothing', 'on');
smoothLines(h);
if nargout == 0, clear h; end

