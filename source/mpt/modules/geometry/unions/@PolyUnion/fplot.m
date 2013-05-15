function varargout = fplot(obj,pos1,pos2,varargin)
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
end
if nargin<=2
    pos2=[];
end

if numel(obj) > 1,
    prevHold = ishold;
    if ~ishold, clf; end
    hold on;
    
    tic
    if nargout>1
        varargout = cell(size(obj));
    end
    for i=1:length(obj),
        if toc > 2, drawnow; tic; end
        if nargout>1
            varargout{i} = fplot(obj(i), pos1, pos2, varargin{:});
        else
            fplot(obj(i), pos1, pos2, varargin{:});
        end
    end
    
    if ~prevHold, hold off; end
    
    if ~ishold
        if obj(1).Dim >= 3, view(3); end
        grid on;
    end
    
    return;
end

% call the polyhedron method
if nargout>0
    varargout{1} = obj.Set.fplot(pos1,pos2,varargin{:});
else
    obj.Set.fplot(pos1,pos2,varargin{:});
end


end
