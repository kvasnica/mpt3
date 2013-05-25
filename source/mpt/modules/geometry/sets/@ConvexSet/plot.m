function h = plot(obj, varargin)
%
% plot(varargin)
%
% Plot the object by sampling the boundary
%
% Params are given as param/value pairs
%  grid - Grid density of plotting sphere [10]
%

global MPTOPTIONS

if isempty(MPTOPTIONS)
    MPTOPTIONS = mptopt;
end

error(nargoutchk(0,1,nargout));

if numel(obj) > 1,
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
    for i=1:numel(obj)
        if toc > 2, drawnow; tic; end
        if nargout>0
            ht = plot(obj(i), varargin{:});
            h = [h; ht(:)];
        else
            plot(obj(i), varargin{:});
        end
    end
    
    if ~prevHold, hold off; end
    
    return
end

% check dimension
if obj.Dim>=4
    error('Cannot plot sets over dimension 4.');
end

% check boundedness
if ~obj.isBounded
    error('Can currently only plot bounded sets.');
end


ip = inputParser;
ip.KeepUnmatched = true;
ip.addParamValue('grid', 40, @isnumeric);
ip.parse(varargin{:});
p = ip.Results;

if obj.Dim == 1
	% compute extremal point in both directions
	X = [-1; 1];
	
elseif obj.Dim == 2
    % Grid the circle
    th = linspace(0,2*pi,p.grid+1)';
    th(end) = [];
    
    X = [sin(th) cos(th)];
else
    [X Y Z] = sphere(p.grid);
    X = [X(:) Y(:) Z(:)];
end

% Compute an extreme point in each direction
E = []; % Extreme points
R = []; % Rays
tic; first = true;
for i=1:size(X,1)
    if toc > MPTOPTIONS.report_period
        tic
        if first, fprintf('Plotting...\n'); first=false; end
        fprintf('%i of %i\n', i, size(X,1));
    end
    ret = obj.extreme(X(i,:));
    switch ret.exitflag
        case MPTOPTIONS.OK
            E(end+1,:) = ret.x';
        case MPTOPTIONS.UNBOUNDED
            R(end+1,:) = ret.x';
        case MPTOPTIONS.ERROR
            error('Cannot tell if object is unbounded or infeasible. Try different solver.');
        otherwise
            error('A problem occured inside the solver. Try different solver.');
    end
end

% Create a polyhedron and plot it
if nargout>0
    h = Polyhedron('V',E,'R',R).plot(varargin{:});
else
    Polyhedron('V',E,'R',R).plot(varargin{:});
end
end
