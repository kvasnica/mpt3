classdef AffFunction < Function
    %
    % class for representing affine functions F*x + g
    %
    % syntax: L = AffFunction(F,g)
    %         L = AffFunction(F)
    %         L = AffFunction(F,g,Data)
    
    properties (SetAccess=private)
        F % linear term
        g % affine term
        D=0; % dimension of the domain
        R=0; % dimension of the range        
	end
	properties(Dependent=true, SetAccess=private, Transient=true)
		weight % used to access the leading term in penalties
	end
    
    methods
        
		function weight = get.weight(obj)
			% AffFunction.weight getter
			%
			% Returns the leading term of F*x+g, i.e., F, when the function
			% is employed to represent a penalty
			weight = obj.F;
		end

        % Constructor
        function obj = AffFunction(F, g, data)
            %
            % syntax: L = AffFunction(F,g)
            %         L = AffFunction(F)
            %         L = AffFunction(F,g,Data)
            %
            % for more details, type "help AffFunction"
            
            error(nargchk(1,3,nargin));
            
            % check F
            validate_realmatrix(F);
            
            % assign F
            obj.F = F;
            
            % get the dimension of the domain and the range
			[obj.R, obj.D] = size(F);
            
            % only F provided
            if nargin==1
				obj.g = zeros(obj.R, 1);
			else
				validate_realvector(g);
				if length(g) ~= obj.R
                    error('The vector "g" must be of the size %d.',obj.R);
				end
				obj.g = g;
			end
			
            % Data provided
            if nargin>2
                obj.Data = data;
            end
            
            % full syntax
            obj.Handle = @obj.af;
            
		end

		function status = eq(f, g)
			% Returns true if the two functions are identical

			global MPTOPTIONS
			if isempty(MPTOPTIONS)
				MPTOPTIONS = mptopt;
			end

			if numel(f)~=numel(g)
				error('Matrix dimensions must agree.');
			elseif numel(f)>1
				% for arrays
				status = false(size(f));
				for i = 1:numel(f)
					status(i) = (f(i)==g(i));
				end
			else
				% for scalars
				
				% TODO: maybe we could alllow comparing AffF with QuadF that
				% has zero quadratic term
				status = isa(f, 'AffFunction') && isa(g, 'AffFunction') && ...
					(f.R==g.R) && (f.D==g.D) && ...
					norm(f.F-g.F)<MPTOPTIONS.zero_tol && ...
					norm(f.g-g.g)<MPTOPTIONS.zero_tol && ...
					isequal(f.Data, g.Data);
			end
		end

		function status = ne(f, g)
			% Returns true if two functions are not identical

			status = ~eq(f, g);
		end
        
    end
    methods (Hidden)
        function y=af(obj, x)
            
			if ~isequal(size(x), [obj.D, 1])
				error('The input must be a %dx1 vector.', obj.D);
			end
            % output
            y = obj.F*x + obj.g;
        end
    end
    
end
