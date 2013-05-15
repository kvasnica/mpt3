function y=horzcat(varargin)
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

y = builtin('horzcat',varargin{:});

end