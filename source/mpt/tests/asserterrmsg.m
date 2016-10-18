function asserterrmsg(msg, varargin)

narginchk(2, Inf);

for i = 1:length(varargin)
    if ~isempty(strfind(msg, varargin{i}))
        return
    end
end
assert(~isempty(strfind(msg, varargin{1})));
