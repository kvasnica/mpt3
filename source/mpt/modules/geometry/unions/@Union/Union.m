classdef Union < handle & IterableBehavior
  %%
  % ConvexSet
  %
  % Represents a convex set in . Getting the basic functionality of all
  % operations given in this class requires that only two additional
  % functions be specified - those in Set: extreme and project.

  
  properties (SetAccess=private, Dependent=true)
      Num % number of sets
  end
  properties (SetAccess=protected)
      Set % container for sets
  end
  properties (SetAccess=protected, Hidden)
      Internal % internal data
  end
  properties
      Data % any user changeable data
  end
  
  methods
      function obj = Union(varargin)
          % 
          % constructor of Union object
          %
          
          % short syntax
          if nargin==1
              arg{1} = 'Set';
              arg{2} = varargin{1};
          else
              arg = varargin;
          end
          
          % full syntax
          ip = inputParser;
          ip.KeepUnmatched = false;
          ip.addParamValue('Set', [], @(x) isa(x, 'ConvexSet'));
          ip.addParamValue('Data', [], @(x) true);
          ip.parse(arg{:});
          p = ip.Results;

          % remove empty sets
          if ~builtin('isempty',p.Set)
              C = p.Set(:);
              c = isEmptySet(C);
              C(c) = [];
          else
              C = p.Set;
          end
          
          % check attached functions, if they are the same in all sets
		  if numel(C)>0
			  funs = C(1).listFunctions();
			  for i = 2:numel(C)
				  if any(~C(i).hasFunction(funs))
					  error('All sets must have associated the same number of functions.');
				  end
			  end
		  end
          
          % assign data
          obj.Set = num2cell(C(:));
          obj.Data = p.Data;
	  end
	 
	  function U = copy(obj)
		  % Creates a copy of the union
		  %
		  %   copy = U.copy()
		  
		  % Note: we implicitly assume that each element of the union is an
		  % instance of a class that supports the copy() method.
		  
		  % deal with arrays
		  if numel(obj)>1
			  U = obj.forEach(@(elem) elem.copy());
			  return
		  end

		  % since we don't know which union class we are copying, we
		  % need to dynamcially call the correct constructor
		  constructor = str2func(class(obj));

		  if iscell(obj.Set)
			  % per-element copying
			  U = constructor();
			  U.Set = cell(size(obj.Set));
			  for i = 1:numel(obj.Set)
				  U.Set{i} = obj.Set{i}.copy();
			  end
		  else
			  % resort to Polyhedron/copy or YSet/copy
			  U = constructor(copy(obj.Set));
		  end
		  
		  % now make a deep copy of the Internal and Data properties
		  %
		  % copy them field by field, otherwise they will refer to the same
		  % data 
		  if isstruct(obj.Internal)
			  nf = fieldnames(obj.Internal);
			  for i=1:numel(nf)
				  U.Internal.(nf{i}) = obj.Internal.(nf{i});
			  end
		  else
			  U.Internal = obj.Internal;
		  end
		  if isstruct(obj.Data)
			  nd = fieldnames(obj.Data);
			  for i=1:numel(nd)
				  U.Data.(nd{i}) = obj.Data.(nd{i});
			  end
		  else
			  U.Data = obj.Data;
		  end
	  end
	  
	  function obj = addFunction(obj, fun, FuncName)
		  % adds a function to each member of the union
		  
		  error(nargchk(3, 3, nargin));
		  
		  % attach the function to each element of the set
		  for i = 1:numel(obj)
			  cell_set = iscell(obj(i).Set);
			  for j = 1:length(obj(i).Set)
				  if cell_set
					  obj(i).Set{j}.addFunction(fun, FuncName);
				  else
					  obj(i).Set(j).addFunction(fun, FuncName);
				  end
			  end
		  end
	  end
		  
		  
	  function U = getFunction(obj, FuncName)
		  % returns function indexed by the string FuncName

		  error(nargchk(2, 2, nargin));
		  for i = 1:numel(obj)
			  % make sure the function exists
			  if any(~obj(i).hasFunction(FuncName))
				  if iscell(FuncName)
					  idx = find(~obj(i).hasFunction(FuncName));
					  missing = FuncName{idx(1)};
				  else
					  missing = FuncName;
				  end
				  error('No such function "%s" in the object.', missing);
			  end
			  
			  U(i) = obj(i).copy();
			  toremove = setdiff(obj(i).listFunctions, FuncName);
			  if ~isempty(toremove)
				  U(i).removeFunction(toremove);
			  end
		  end
	  end
	  
	  function obj = removeFunction(obj, FuncNames)
		  % removes function indexed by the string FuncName

		  error(nargchk(2, 2, nargin));
		  % make a copy before removing function(s)
		  for i = 1:numel(obj)
			  % make sure the function exists
			  if any(~obj(i).hasFunction(FuncNames))
				  if iscell(FuncNames)
					  idx = find(~obj(i).hasFunction(FuncNames));
					  missing = FuncNames{idx(1)};
				  else
					  missing = FuncNames;
				  end
				  error('No such function "%s" in the object.', missing);
			  end
			  if iscell(obj(i).Set)
				  for j = 1:length(obj(i).Set)
					  obj(i).Set{j}.removeFunction(FuncNames);
				  end
			  else
				  obj(i).Set.removeFunction(FuncNames);
			  end
		  end
	  end
	  
	  function obj = removeAllFunctions(obj)
		  % removes all attached functions

		  for i = 1:numel(obj)
			  if iscell(obj(i).Set)
				  for j = 1:length(obj(i).Set)
					  obj(i).Set{j}.removeAllFunctions;
				  end
			  else
				  obj(i).Set.removeAllFunctions;
			  end
		  end
	  end
	  
	  function out = listFunctions(obj)
		  % lists attached functions
		  %
		  % outputs:
		  % * empty cell array if "obj" is an empty object
		  % * cell array of function names if "obj" is a single union
		  % * cell array of cell arrays of function names if "obj" is an
		  %   array

		  if numel(obj)==0 || numel(obj(1).Set)==0
			  out = {};
		  elseif numel(obj)==1
			  if iscell(obj.Set)
				  out = obj.Set{1}.Functions.keys();
			  else
				  out = obj.Set(1).Functions.keys();
			  end
		  else
			  out = cell(1, numel(obj));
			  for i = 1:numel(obj)
				  if iscell(obj(i).Set)
					  out{i} = obj(i).Set{1}.Functions.keys();
				  else
					  out{i} = obj(i).Set(1).Functions.keys();
				  end
			  end
		  end
	  end
	  
	  function out = hasFunction(obj, FuncName)
		  % returns true if the object contains function(s) indexed by
		  % FuncName
		  %
		  % inputs:
		  %   FuncName: either a string or a cell array of strings
		  %
		  % outputs:
		  % * empty double if "obj" is an empty object
		  % * column logical vector if "obj" is a single union (each row
		  %   corresponds to presence of FuncName{i})
		  % * logical matrix if "obj" is an array, with "n" rows and "m"
		  %   columns, where "n" is the number of functions which are
		  %   queried, and "m" is the number of unions. then out(i, j)=true
		  %   if the j-th union contains FuncName{i}

		  error(nargchk(2, 2, nargin));
		  out = []; % default output for empty arrays
		  if numel(obj)==1 && numel(obj.Set)>0
			  if iscell(obj.Set)
				  x = obj.Set{1}.Functions.isKey(FuncName);
			  else
				  x = obj.Set(1).Functions.isKey(FuncName);
			  end
			  % make sure we always return column vector if we have
			  % multiple functions
			  out = x(:);
		  elseif numel(obj)>1
			  if iscell(FuncName)
				  n = length(FuncName);
			  else
				  n = 1;
			  end
			  out = false(n, numel(obj));
			  for i = 1:numel(obj)
				  if numel(obj(i).Set)>0
					  if iscell(obj(i).Set)
						  x = obj(i).Set{1}.Functions.isKey(FuncName);
					  else
						  x = obj(i).Set(1).Functions.isKey(FuncName);
					  end
					  out(:, i) = x(:);
				  end
			  end
		  end
	  end

	  function U = trimFunction(obj, FuncName, n)
		  % Extracts the first "n" rows of a given affine function
		  %
		  % This method creates a copy of the input union where the
		  % specified affine function is replaced by a new affine function
		  % which only contains the first "n" rows of the original
		  % function.
		  
		  if length(obj)>1
			  error('Single union please.');
		  elseif ~obj.hasFunction(FuncName)
			  error('No such function "%s".', FuncName);
		  end
		  
		  if nargout==0
			  % in-place trimming
			  U = obj;
		  else
			  % create a copy if explicitly requested
			  U = obj.copy;
		  end

		  for i = 1:U.Num
			  f = U.Set(i).getFunction(FuncName);
			  if ~isa(f, 'AffFunction')
				  error('Only affine functions can be trimmed.');
			  end
			  ft = AffFunction(f.F(1:n, :), f.g(1:n), f.Data);
			  U.Set(i).addFunction(ft, FuncName);
		  end
		  
	  end

  end
  methods (Hidden)

      function obj = setInternal(obj,name,value)
          %
          % overwrites internal property for the Union object
          % (internal function)
          %
          % If we want to add the internal property from outside of
          % this class (e.g. inside the PLCP solver) e.g.
          %
          % obj.Internal.name = value,
          %
          % use the syntax:
          %         obj.setInternal('name',value)
          %
          % DO NOT USE THIS METHOD UNLESS YOU PERFECTLY KNOW WHAT YOU ARE DOING
          %
          
          error(nargchk(3,3,nargin));
          
          if ~ischar(name)
              error('Name must be a string.');
          end
          
          obj.Internal.(name) = value;
          
      end
  end
  
  methods (Access=protected)
	  % internal APIs
	  
	  function displayFunctions(obj)
		  % displays attached functions (to be used from a disp() method)
		  
		  fprintf('Functions');
		  funs = obj.listFunctions;
		  nf = length(funs);
		  if nf==0
			  fprintf(' : none\n');
		  else
			  fprintf(' : %d attached ',nf);
			  for i = 1:nf
				  fprintf('"%s"', funs{i});
				  if i<nf
					  fprintf(', ');
				  end
			  end
			  fprintf('\n');
		  end
		  
	  end
	  
	  function out = index_Set(obj, i)
		  % returns the i-th element of obj.Set, regardless of whether Set
		  % is a cell or an ordinary array

		  if iscell(obj.Set)
			  out = obj.Set{i};
		  else
			  out = obj.Set(i);
		  end
	  end

  end

  methods      
   function n = get.Num(obj)
       % get method for number of sets
       n = numel(obj.Set);
   end
  end
  
end

