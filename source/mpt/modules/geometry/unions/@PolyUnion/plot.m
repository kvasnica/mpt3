function varargout = plot(PU,varargin)
%
% plots regions for PolyUnion object
%

error(nargoutchk(0,1,nargout));

if length(PU(:)) > 1,
    prevHold = ishold;
    if ~ishold, clf; end
    hold on;

    if nargout>0
        varargout = cell(size(PU));
    end
    for i=1:length(PU),
        if nargout>0
            varargout{i} = plot(PU(i), varargin{:});
        else
            plot(PU(i), varargin{:});
        end
    end
    
    if ~prevHold, hold off; end
    
    if ~ishold
        if PU(1).Set(1).Dim >= 3, view(3); end
        grid on;
    end
    
    return
end

if PU.Num>0
    varargout = {PU.Set.plot(varargin{:})};
else
	varargout{1} = figure;
end
if nargout==0
	clear varargout
end

end
