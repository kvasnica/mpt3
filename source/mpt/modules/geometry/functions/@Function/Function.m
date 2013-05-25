classdef Function < handle & IterableBehavior
  %
  % class for representing functions
  %
  % syntax: F = Function('Handle',@fun,'Data',any_data)
  %         F = Function(@fun)
  %
  %         F = Function('Data',struct('p',2));
  %         F.setHandle(@(x)*F.Data.p)

  
  %%
  properties(SetAccess = protected)
    Handle % function handle
    Internal % internal data
  end
  
  properties(SetAccess = public)
    Data; % additional user data
  end
  
  %%
  methods(Access = public)
    
      % Constructor      
      function F = Function(Handle, Data)
          %
          % sets data for Function object
          %
          % syntax: F = Function(@fun, any_data)
          %         F = Function(@fun)
          %
          %         F = Function(struct('p',2));
          %         F.setHandle(@(x)*F.Data.p)
          %
          % for more details, type "help Function"
          
		  if nargin==0
			  % nothing to do, an empty object will be automatically
			  % constructed
		  elseif nargin==1
			  if isa(Handle, 'function_handle')
				  F.Handle = Handle;
			  else
				  F.Data = Handle;
			  end
		  elseif nargin==2
			  F.Handle = Handle;
			  F.Data = Data;
		  end
	  end
	  
	  function out = feval(obj, x)
		  % evaluates the function at a point
		  
		  % For performance reasons we really don't want to declare "feval"
		  % as a method. Instead, remove this method, and rename the
		  % "Handle" property to "feval". Then "obj.feval(x)" works
		  % correctly without any overhead due to method call.
		  out = obj.Handle(x);
	  end
  end
  
  methods (Hidden)
      
      function obj = setInternal(obj,name,value)
          %
          % overwrites internal property for the Function object
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
          % DO NOT USE THIS METHOD UNLESS YOU PERFECTLY KNOW WHAT
          % YOU ARE DOING
          %
          
          error(nargchk(3,3,nargin));
          
          if ~ischar(name)
              error('Name must be a string.');
          end
          
          obj.Internal.(name) = value;
          
      end
  end

end
