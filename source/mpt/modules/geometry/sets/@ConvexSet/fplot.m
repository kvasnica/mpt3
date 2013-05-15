function h = fplot(obj, pos1, pos2, varargin)
%
% plot(varargin)
%
% Plot the object by sampling the boundary
%
% Params are given as param/value pairs
%  grid - Grid density of plotting sphere [10]
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
end
if nargin==2
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
            h = [h; fplot(obj(i), pos1, pos2, varargin{:})];
        else
            fplot(obj(i), pos1, pos2, varargin{:});
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

% check dimension
if obj.Dim>=3
    error('Cannot plot functions over dimension 3.');
end

% check boundedness
if ~obj.isBounded
    error('Can currently only plot bounded sets.');
end


ip = inputParser;
ip.KeepUnmatched = true;
ip.addParamValue('grid',  40,   @isnumeric);

ip.parse(varargin{:});
p = ip.Results;

if isa(obj,'Polyhedron');
    % polyhedron
    P = obj;
else
    % for any other convex set do gridding
    
    if obj.Dim ==1        
        B = obj.outerApprox;
        % lb and ub only
        X = [B.Internal.lb;
            B.Internal.ub];
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
    
    % Create a polyhedron out of given extreme points
    P = Polyhedron('V',E,'R',R);
	% Copy functions
	P.copyFunctionsFrom(obj);
end


if nargout>0
    h = P.fplot(pos1,pos2,varargin{:});
else
    P.fplot(pos1,pos2,varargin{:});
end


end
