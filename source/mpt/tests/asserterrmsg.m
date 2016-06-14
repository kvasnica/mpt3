function asserterrmsg(msg, varargin)

error(nargchk(2, Inf, nargin));

for i = 1:length(varargin)
    if ~isempty(strfind(msg, varargin{i}))
        return
    end
end
assert(~isempty(strfind(msg, varargin{1})));
