function h = fplot(obj,pos1,pos2,varargin)
%
% function over polyhedron
%

% global options
global MPTOPTIONS
if isempty(MPTOPTIONS)
    MPTOPTIONS = mptopt;
end

error(nargoutchk(0,1,nargout));

if nargin==1
    pos1=[];
    pos2=[];
elseif nargin<=2
    pos2=[];
end

if numel(obj) > 1,
    prevHold = ishold;
    if ~ishold, clf; end
    hold on;
    
    tic
    if nargout>0
        h = [];
    end
    for i=1:length(obj),
        if toc > 2, drawnow; tic; end
        if nargout>0
            h = [h; fplot(obj(i), pos1, pos2, varargin{:}, 'index', i)];
        else
            fplot(obj(i), pos1, pos2, varargin{:}, 'index', i);
        end
    end
    
    if ~prevHold, hold off; end
        
    return;
end

if isempty(pos1)
	pos1 = obj.listFunctions;
end
if ~iscell(pos1)
	pos1 = {pos1};
end
if isempty(obj.Functions)
    error('There is no function to be plotted over this set.');
end
if isempty(pos2)
	pos2 = 1;
end

if any(~obj.hasFunction(pos1))
	error('One or more functions are not defined.');
end
validate_dimension(pos2);

for i = 1:length(pos1)
	f = obj.getFunction(pos1{i});
	if (isa(f, 'AffFunction') || isa(f, 'QuadFunction')) && pos2>f.R
		error('The position index for Function %d must be less than %d.',i,f.R);
	end
end

if obj.Dim>=3
    error('Cannot plot functions over dimension 3.');
end

ip = inputParser;
ip.KeepUnmatched = true;
ip.addParamValue('color',  [], @validate_color);
ip.addParamValue('wire',       false,  @(x) islogical(x) || x==1 || x==0);
ip.addParamValue('linestyle',  '-', @validate_linestyle);
ip.addParamValue('linewidth',  1,   @isnumeric);
ip.addParamValue('alpha',      1, @(x) isnumeric(x) && x>=0 && x<=1);
ip.addParamValue('contour',    false, @(x) islogical(x) || x==1 || x==0);
ip.addParamValue('polyhedron', false, @(x) islogical(x) || x==1 || x==0);
ip.addParamValue('grid',  20,   @isnumeric);
ip.addParamValue('contourGrid',  30,   @isnumeric);
ip.addParamValue('colormap', 'mpt', @(x) (isnumeric(x) && size(x, 2)==3) || ischar(x)); 
ip.addParamValue('colororder', 'fixed', @(x) isequal(x, 'fixed') || isequal(x, 'random'));
% "index" is an internal property which denotes position of the plotted
% object in an array. It is used to get properl color in charToColor()
ip.addParamValue('index', 1, @validate_indexset);

ip.parse(varargin{:});
p = ip.Results;

h = [];
if true %~isempty(obj.Func)
    
    % check boundedness
    if ~obj.isBounded
        error('Can currently only plot bounded polyhedra.');
    end
    
    % check emptyness
    if obj.isEmptySet
        error('Cannot plot function over empty polyhedron.');
    end
    
    % if the Polyhedon consist of just one point change the default marker to "."
    if size(obj.He,1)>=obj.Dim
        marker = '.';            
    else
        marker = 'none';
    end

    
    prevHold = ishold;
    if ~ishold, clf; end
    hold on;
    
    for i=1:length(pos1)
        % get color as RGB vector
		fun_i = obj.getFunction(pos1{i});
        if ischar(p.color) || isempty(p.color)
			clr = charToColor(p.color, p.colormap, p.index, p.colororder);
        else
            clr = p.color;
        end
        if obj.Dim<2
            % plot 1D sets
            B = obj.outerApprox;
            x = linspace(B.Internal.lb,B.Internal.ub,p.grid)';
            y = zeros(size(x));
            for j=1:numel(x)
                v = fun_i.Handle(x(j));
                y(j) = v(pos2);
            end

            hl = line(x,y,'Color',clr,'LineStyle', p.linestyle, ...
                'LineWidth', p.linewidth,'Marker',marker);
            h = [h; hl(:)];

        else
            % plot 2D sets
            if isa(fun_i,'AffFunction') && ~p.contour
                X = obj.minVRep();
                X = X.V;
                V = zeros(size(X,1),1);
                %             if obj.Func{i}.canVectorize
                %                 t = obj.Func{i}.Handle(X);
                %                 V = t(pos2);
                %             else
                for j=1:size(X,1)
                    t = fun_i.Handle(X(j,:));
                    V(j,1) = t(pos2);
                end
                %             end
                %           n = pinv([X V])*ones(size(X,1),1);
                [uu,ss,vv]= svd([X V]);
                %           if ss(3,3) > 1e-2,
                %             warning('Function being plotted is not linear'); end
                n = vv(:,3);
                I = orderForPlot([X V], n);
                
                hp = patch('Vertices', [X V], 'Faces', I(:)', ...
                    'LineStyle', p.linestyle, ...
                    'LineWidth', p.linewidth, ...
                    'FaceAlpha', p.alpha,...
                    'EdgeColor', [0 0 0],...
                    'FaceLighting', 'phong',...
                    'AmbientStrength', 0.7,...
                    'FaceColor',clr,...
                    'Marker',marker);
                h = [h; hp(:)];
                
            else
                [X,Y] = obj.meshGrid(p.grid);
                
                % Sample the function at the X,Y points
                %             if obj.Func{i}.canVectorize
                %                 q = [X(:) Y(:)];
                %                 I = ~any(isnan(q),2);
                %                 v = obj.Func{i}.Handle(q(I,:));
                %                 V = NaN*X(:);
                %                 V(I,:) = v(pos2);
                %                 V = reshape(V,size(X,1),size(X,2));
                %             else
                V = NaN*X;
                for j = 1:size(X,1)
                    for k = 1:size(X,2)
                        x = [X(j,k);Y(j,k)];
                        if isnan(x(1)) || isnan(x(2)), continue; end
                        t = fun_i.Handle(x');
                        if isempty(t) || any(isnan(t)), continue; end
                        V(j,k) = t(pos2);
                    end
                end
                %             end
                
                % Plot the function
                if p.alpha == 0 && strcmp(p.linestyle,'none')
                    hs = [];
                else
                    if p.contour
                        hs = surfc(X,Y,V,'facecolor',clr,...
                            'linestyle', p.linestyle, ...
                            'linewidth', p.linewidth, ...
                            'facealpha', p.alpha,...
                            'facelighting', 'phong',...
                            'AmbientStrength', 0.7,...
                            'Marker',marker);                        
                    else
                        hs = surf(X,Y,V,'facecolor',clr,...
                            'linestyle', p.linestyle, ...
                            'linewidth', p.linewidth, ...
                            'facealpha', p.alpha,...
                            'facelighting', 'phong',...
                            'AmbientStrength', 0.7,...
                            'Marker',marker);
                    end
                end
                h = [h; hs(:)];
                
%                 % Add a contour plot
%                 if  p.contour
%                     held=ishold;
%                     hold on;
%                     [C,c] = contour3(X,Y,V,p.contourGrid);                    
%                     set(c,'linewidth',p.linewidth,'linestyle',p.linestyle);
%                     h = [h;c(:)];
%                     if ~held, hold off; end
%                 end

            end
        end
    end
    if ~prevHold, hold off; end
    
    % plot the polyhedron if required
    if p.polyhedron
        held=ishold;
        hold on;        
        hv = obj.plot(varargin{:});
        h = [h; hv(:)];
        if ~held
            hold off;
        end
    end
    
    % put 3D view for 2D and 3D plots
    if obj.Dim>1
        view(3);
        %if size(obj.He,1)<obj.Dim
        %    axis tight        
        %    %axis vis3d
        %end
    end
    grid on;
    

    smoothLines(h);
end

if nargout==0
    clear h;
end

end
