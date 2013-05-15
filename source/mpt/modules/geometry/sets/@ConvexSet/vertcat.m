function y=vertcat(varargin)
%
% avoids concatenation into matrices
%

% check for empty arguments
e = cellfun(@(x)builtin('isempty',x),varargin,'UniformOutput',false);

% delete empty entries
varargin(cell2mat(e))=[];

% check if the sets are the same
s = cellfun(@class,varargin,'UniformOutput',false);
if length(unique(s))~=1
   error('Only the same sets can be concatenated.');
end

parfor i=1:length(varargin)
    if size(varargin{i},2)>size(varargin{i},1)
        varargin{i} = transpose(varargin{i});
    end
end

y = builtin('vertcat',varargin{:});


end