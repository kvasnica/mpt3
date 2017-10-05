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
                    [A, b, Ae, be] = obj(i).getHalfspaces();
                    if isempty(be)
                        P(i) = Polyhedron(A, b);
                    else
                        P(i) = Polyhedron('H', [A b], 'He', [Ae be]);
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
            % Checks if a given set is empty

            tf = true(size(obj));
            for i = 1:numel(obj)
                if ~isempty(obj(i).Internal.Empty)
                    tf(i) = obj(i).Internal.Empty;
                else
                    % slow but simple:
                    % tf(i) = isEmptySet(toPolyhedron(obj(i)));
                    
                    % faster: solve a feasibility LP
                    [S.A, S.b, S.Ae, S.be] = obj(i).getHalfspaces();
                    S.f = zeros(size(S.A, 2), 1);
                    S.lb = []; S.ub = []; S.quicklp = true;
                    sol = mpt_solve(S);
                    tf(i) = ~isequal(sol.how, 'ok');
                    obj(i).Internal.Empty = tf(i);
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
                    primal = P(i).Functions('primal-kkt').feval(x);
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
        
        function [A, b, Ae, be] = getHalfspaces(obj)
            % Returns the half-space representation of the implicit
            % polyhedron
            
            prob = obj.Data.OptProb;
            primal = obj.Functions('primal-kkt'); % F*x+g
            dual = obj.Functions('dual-ineqlin'); % M*x+m
            % CR = { x | A*primal<=b+pB*x, dual>=0 }
            %    = { x | A*(F*x+g)<=b+pB*x, M*x+m>=0 }
            %    = { x | (A*F-pB)*x<=b-A*g, -M*x<=m }
            %    = { x | H*x<=h }
            A = [ prob.A*primal.F-prob.pB; -dual.F ];
            b = [ prob.b-prob.A*primal.g; dual.g ];
            if prob.me>0
                Ae = prob.Ae*primal.F-prob.pE;
                be = prob.be-prob.Ae*primal.g;
            else
                Ae = []; be = [];
            end
        end
	end
    
end
