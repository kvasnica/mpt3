function y=vertcat(varargin)
%
% avoids concatenation into matrices
%

n = numel(varargin);
arg = cell(0);
for i=1:n
    if iscell(varargin{i})        
        l=length(varargin{i});
        arg(end+1:end+l) = varargin{i}(:);
    else
        if size(varargin{i},2)>size(varargin{i},1)
            arg{end+1} = transpose(varargin{i});
        else
            arg{end+1} = varargin{i};
        end
    end
end

y = num2cell(builtin('vertcat',arg{:}));

end