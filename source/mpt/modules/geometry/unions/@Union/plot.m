function varargout=plot(U,varargin)
%
% plotting the collection of sets stored inside the Union object
%

error(nargoutchk(0,1,nargout));

if length(U(:)) > 1,
    prevHold = ishold;
    if ~ishold, clf; end
    hold on;

    varargout = cell(size(U));
    for i=1:length(U),
        varargout{i} = plot(U(i), varargin{:});
    end
    
    if ~prevHold, hold off; end
    return
end

prevHold = ishold;
if ~ishold, 
    clf;
end
hold on;
for i=1:U.Num
        
    if nargout>0
        varargout{i} = U.Set{i}.plot('index', i, varargin{:});
    else
        U.Set{i}.plot('index', i, varargin{:});
    end
    
end   
if ~prevHold,
    hold off;
end

end
