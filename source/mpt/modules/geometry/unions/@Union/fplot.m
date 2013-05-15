function varargout=fplot(U,pos1,pos2,varargin)
%
% plotting function for the Union object
%

error(nargoutchk(0,1,nargout));

if nargin==1
    pos1=[];
    pos2=[];
end
if nargin==2
    pos2=[];
end

if length(U(:)) > 1,
    prevHold = ishold;
    if ~ishold, clf; end
    hold on;

    varargout = cell(size(U));
    for i=1:length(U),
        varargout{i} = fplot(U(i), pos1, pos2, varargin{:});
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
        varargout{i} = U.Set{i}.fplot(pos1,pos2,varargin{:});
    else
        U.Set{i}.fplot(pos1,pos2,varargin{:});
    end
    
end   
if ~prevHold,
    hold off;
end



end