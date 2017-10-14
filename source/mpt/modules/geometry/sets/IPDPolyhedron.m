classdef IPDPolyhedron < Polyhedron
    methods
        function obj = IPDPolyhedron(optprob)
            % Polyhedron implicitly defined by primal/dual feasibility conditions
            
            obj.Dim = optprob.d;
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
                    [A, b, Ae, be] = obj(i).getHalfspaces();
                    tf(i) = fast_isEmptySet([A b], [Ae be]);
                    obj(i).Internal.Empty = tf(i);
                end
            end
        end
        
        function tf = isFullDim(obj)
            % Checks if a given set is fully dimensional
            
            tf = true(size(obj));
            for i = 1:numel(obj)
                if ~isempty(obj(i).Internal.FullDim)
                    tf(i) = obj(i).Internal.FullDim;
                else
                    % slow but simple:
                    %tf(i) = isFullDim(toPolyhedron(obj(i)));
                    
                    % faster: solve a feasibility LP
                    [A, b, Ae, be] = obj(i).getHalfspaces();
                    tf(i) = fast_isFullDim([A b], [Ae be]);
                    obj(i).Internal.FullDim = tf(i);
                    if tf(i)
                        obj(i).Internal.Empty = false;
                    end
                end
            end
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
                %dual = P(i).Functions('dual-ineqlin').feval(x);
                dual_f = P(i).Data.DualIneq;
                dual = dual_f.F*x+dual_f.g;
                if isempty(dual), dual=zeros(1, P(i).Dim); end
                
                % check dual feasibility first
                if min(dual)>=0
                    primal_f = P(i).Data.Primal;
                    primal = primal_f.F*x+primal_f.g;
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
            primal = obj.Data.Primal;
            dual = obj.Data.DualIneq;
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
                Ae = zeros(0, size(A, 2)); be = zeros(0, 1);
            end
        end
	end
    
end
