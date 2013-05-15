classdef ConvexSet < ConvexSetInterface & IterableBehavior
  %%
  % ConvexSet
  %
  % Represents a convex set in . Getting the basic functionality of all
  % operations given in this class requires that only two additional
  % functions be specified - those in Set: extreme and project.

  properties (SetAccess=protected)
      Dim % Dimension of the set
  end
  properties (SetAccess=protected, Hidden)
      Internal % Internal data
	  Functions % Storage of attached functions
  end

  properties
      Data % any user changeable data
  end
  
  properties (Dependent=true, Transient=true, Hidden)
	  Func
  end
  
  methods
	  
	  function F = get.Func(obj)
		  F = obj.Functions.values();
	  end
	  
	  function obj = addFunction(obj, F, FuncName)
		  % adds a function to the object
		  
		  error(nargchk(3, 3, nargin));
		  if numel(obj)==1
			  % check domain
			  if (isa(F, 'AffFunction') || isa(F, 'QuadFunction')) && ...
					  obj.Dim ~= F.D
				  error('The function must have the same domain as the set.');
			  elseif isa(F, 'function_handle')
				  F = Function(F);
			  elseif isa(F, 'char')
				  error('First input must be a function object.');
			  end
			  % add the function to the map
			  obj.Functions(FuncName) = F;
			  
		  elseif numel(obj)>1
			  % deal with arrays
			  for j=1:numel(obj)
				  obj(j) = obj(j).addFunction(F,FuncName);
			  end
		  end
	  end
	  
	  function F = getFunction(obj, FuncName)
		  % returns function indexed by the string FuncName
		  for i = 1:numel(obj)
			  F(i) = obj(i).Functions(FuncName);
		  end
	  end
	  
	  function obj = removeFunction(obj, FuncNames)
		  % removes function indexed by the string FuncName
		  for i = 1:numel(obj)
			  obj(i).Functions.remove(FuncNames);
		  end
	  end
	  
	  function obj = removeAllFunctions(obj)
		  % removes all attached functions
		  for i = 1:numel(obj)
			  obj(i).Functions.remove(obj(i).Functions.keys);
		  end
	  end
	  
	  function out = listFunctions(obj)
		  % lists attached functions
		  out = obj.Functions.keys();
	  end
	  
	  function out = hasFunction(obj, FuncName)
		  % returns true if the object contains function(s) indexed by
		  % FuncName
		  out = obj.Functions.isKey(FuncName);
	  end

	  function [F, map] = uniqueFunctions(obj, FuncName)
		  % Returns unique occurences of function "FuncName" and their map
		  % to elements of the array.
		  %
		  % Given an array of sets "P" whose all elements have the function
		  % "FuncName" attached, this method returns list of unique
		  % functions "F" attached to each element of "P". The method also
		  % returns indices "map", such that P(i) uses function F(map(i)).

		  F = []; % list of unique functions
		  map = zeros(1, numel(obj));
		  for i = 1:numel(obj)
			  if ~obj(i).hasFunction(FuncName)
				  error('No such function "%s".', FuncName);
			  end
			  f = obj(i).getFunction(FuncName);
			  % is the function unique?
			  u = find(arrayfun(@(x) x==f, F));
			  if isempty(u)
				  % unique function found
				  F = [F f];
				  map(i) = length(F);
			  else
				  % another identical function was already seen
				  map(i) = u(1);
			  end
		  end
	  end

  end
  
  methods (Hidden)
	  % private APIs
  
	  function target = copyFunctionsFrom(target, source)
		  % copies functions attached to "source" to "target"
		  
		  if length(source.Functions)>0
			  funs = source.listFunctions;
			  for i=1:length(funs)
				  target.addFunction(source.getFunction(funs{i}), funs{i});
			  end
		  end

	  end
	  
      function obj = setInternal(obj,name,value)
          %
          % overwrites internal property for the ConvexSet object
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
	  
  end
  
end

