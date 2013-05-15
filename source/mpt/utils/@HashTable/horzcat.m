function y=horzcat(varargin)
%
% avoids concatenation into matrices
%

y = vertcat(varargin{:});
%y = num2cell(builtin('horzcat',varargin{:}));

end