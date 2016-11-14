classdef IPDPolyhedron < Polyhedron
    methods
        function obj = IPDPolyhedron(dim, optprob)
            % Polyhedron implicitly defined by primal/dual feasibility conditions
            
            % store internaly as R^n, i.e., 0'*x<=1
            %obj = obj@Polyhedron(zeros(1, dim), 1);
            obj.Dim = dim;
            obj.Data.OptProb = optprob;
        end

        function P = toPolyhedron(obj)
            % Converts implicit polyhedron to explicit form
            
            for i = 1:numel(obj)
                if isfield(obj(i).Internal, 'Polyhedron') && ...
                        ~isempty(obj(i).Internal.Polyhedron)
                    % extract pre-computed
                    P(i) = obj(i).Internal.Polyhedron;
                else
                    % compute anew
                    prob = obj(i).Data.OptProb;
                    primal = obj(i).Functions('primal'); % F*x+g
                    dual = obj(i).Functions('dual-ineqlin'); % M*x+m
                    % CR = { x | A*primal<=b+pB*x, dual>=0 }
                    % CR = { x | A*(F*x+g)<=b+pB*x, M*x+m>=0 }
                    % CR = { x | (A*F-pB)*x<=b-A*g, -M*x<=m }
                    % CR = { x | H*x<=h }
                    H = [ prob.A*primal.F-prob.pB; -dual.F ];
                    h = [ prob.b-prob.A*primal.g; dual.g ];
                    if prob.me>0
                        He = prob.Ae*primal.F-prob.pE;
                        he = prob.be-prob.Ae*primal.g;
                        P(i) = Polyhedron('H', [H h], 'He', [He he]);
                    else
                        P(i) = Polyhedron(H, h);
                    end
                    P(i).copyFunctionsFrom(obj(i));
                    obj(i).Internal.Polyhedron = P(i);
                end
            end
        end
        
        function display(obj)
            % Display for IPDPolyhedron
            
            if numel(obj)>1
                fprintf('Array of %d implicit polyhedra.\n', numel(obj));
            else
                fprintf('Implicit polyhedron in %dD.\n', obj.Dim);
            end
        end
        
        function tf = isEmptySet(obj)
            tf = true(size(obj));
            for i = 1:numel(obj)
                if ~isempty(obj(i).Internal.Empty)
                    tf(i) = obj(i).Internal.Empty;
                else
                    tf(i) = isEmptySet(toPolyhedron(obj(i)));
                end
            end
        end
        function tf = isFullDim(obj)
            tf = isFullDim(toPolyhedron(obj));
        end
        function tf = isBounded(obj)
            tf = isBounded(toPolyhedron(obj));
        end
        
        function tf = contains(P, x, varargin)
            % Tests x \in P
            
            global MPTOPTIONS
            if isempty(MPTOPTIONS)
                MPTOPTIONS = mptopt;
            end
            
            narginchk(2, 3);
            assert(isnumeric(x), 'The argument must be a real vector.');
            
            tf = false(size(P));
            for i = 1:numel(P)
                dual = P(i).Functions('dual-ineqlin').feval(x);
                % check dual feasibility first
                if min(dual)>=0
                    primal = P(i).Functions('primal').feval(x);
                    prob = P(i).Data.OptProb;
                    % check primal feasibility
                    if max(prob.A*primal-prob.b-prob.pB*x)<=MPTOPTIONS.abs_tol
                        if prob.me>0
                            % also check equalities
                            if norm(prob.Ae*primal-prob.be-prob.pE*x)<=MPTOPTIONS.abs_tol
                                tf(i) = true;
                            end
                        else
                            tf(i) = true;
                        end
                    end
                end
            end
        end
    end
    
	methods (Access=protected)
		
		% function prototypes (plotting methods must remain protected)
        function h = fplot_internal(obj, varargin)
            h = fplot_internal(toPolyhedron(obj), varargin{:});
        end
        
        function h = plot_internal(obj, varargin)
            h = plot_internal(toPolyhedron(obj), varargin{:});
        end
	end
    
end
