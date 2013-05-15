classdef PolyUnion < Union
  %%
  % ConvexSet
  %
  % Represents an union of polyhedra.
  properties (SetAccess=protected)
      Dim % Dimension of the union
  end
  
  methods
      function obj = PolyUnion(varargin)
          % 
          % Union(regions)
          % Union('Set',regions,'convexity',true,'overlaps',false);
          % Union('Set',regions,'convexity',true,'overlaps',false);
          
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
          ip.addParamValue('Set', [], @(x) isa(x, 'Polyhedron'));
          ip.addParamValue('Convex',[], @(x) islogical(x) || x==1 || x==0);
          ip.addParamValue('Overlaps',[], @(x) islogical(x) || x==1 || x==0);
          ip.addParamValue('Connected',[], @(x) islogical(x) || x==1 || x==0);
          ip.addParamValue('Bounded',[], @(x) islogical(x) || x==1 || x==0);
          ip.addParamValue('FullDim',[], @(x) islogical(x) || x==1 || x==0);
          ip.addParamValue('Data', [], @(x) true);
          ip.parse(arg{:});
          p = ip.Results;
                                 
          % remove empty sets
          if ~builtin('isempty',p.Set)
              C = p.Set(:);
              c = isEmptySet(C);
              C = C(~c);
          else
              C = p.Set;
          end
                    
          nC = numel(C);
          if nC>0
              if ~isEmptySet(C)
                  % check dimension
                  D = [C.Dim];
                  if any(D(1)~=D)
                      error('All polyhedra must be in the same dimension.');
                  end
                  obj.Dim = D(1);
              end
              
              % assign properties
              obj.Set = C;
              %obj.Num = length(obj.Set);
              
              
              % check attached functions, if they are the same in all sets
			  if numel(C)>0
				  funs = C(1).listFunctions();
				  for i = 2:numel(C)
					  if any(~C(i).hasFunction(funs))
						  error('All sets must have associated the same number of functions.');
					  end
				  end
			  end
          end
          
          obj.Internal.Convex = p.Convex;
          obj.Internal.Overlaps = p.Overlaps;
          % convex union implies connected
          if p.Convex
              obj.Internal.Connected = true;
          else
              obj.Internal.Connected = p.Connected;
          end
          obj.Internal.Bounded = p.Bounded; 
          obj.Internal.FullDim = p.FullDim; % full dimensionality
          obj.Data = p.Data;

          
	  end
	  
  end  
end

