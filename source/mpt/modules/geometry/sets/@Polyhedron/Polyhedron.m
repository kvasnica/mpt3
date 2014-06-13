classdef Polyhedron < ConvexSet
	%<matDoc>
	% <funcName>Polyhedron</funcName>
	% <shortDesc>Create a polyhedron object.</shortDesc>
	% <longDesc>
	% Define a polyhedron:
	%
	%  P = {x | H*[x;-1] &lt;= 0} cap {x | He*[x;-1] = 0}
	%
	% or
	%
	%  P = {V'lam | lam &gt;= 0, sum(lam) = 1} + {R'gam | gam &gt;= 0}
	% </longDesc>
	%
	% <!-- The standard calling form -->
	% <syntax>
	%  <input  name='H' type='paramValue'>Inequality description (must be full-dimensional) {x | H*[x;-1] &lt;= 0}</input>
	%  <input  name='He' type='paramValue'>Affine set {x | He*[x;-1] = 0}</input>
	%  <input  name='V' type='paramValue'>Points defining the set conv(V)</input>
	%  <input  name='R' type='paramValue'>Rays defining the set cone(R)</input>
	%  <input  name='irredundantVRep' default='false' type='paramValue'>If true, then the given V-Rep is assumed irredundant</input>
	%  <input  name='irredundantHRep' default='false' type='paramValue'>If true, then the given H-Rep is assumed irredundant</input>
	%  <input  name='lb' type='paramValue'>Add a constraint of the form lb &lt; x</input>
	%  <input  name='ub' type='paramValue'>Add a constraint of the form x &lt; ub</input>
	%  <output name='P' class='Polyhedron'>The polyhedron</output>
	% </syntax>
	%
	% <!-- Copy constructor -->
	% <syntax>
	%  <desc>Copy constructor</desc>
	%  <input  name='Pin' class='Polyhedron'>Polyhedron to copy</input>
	%  <output name='P' class='Polyhedron'>Copy of Pin</output>
	% </syntax>
	%
	% <!-- Vertex form -->
	% <syntax>
	%  <desc>Shorthand for defining Vrep polyhedra</desc>
	%  <input  name='V'>Vertices of polyhedron (row-wise)</input>
	%  <output name='P' class='Polyhedron'>Vrep Polyedron conv(V)</output>
	% </syntax>
	%
	%
	% <!-- Inequality form -->
	% <syntax>
	%  <desc>Shorthand for defining Hrep polyhedra</desc>
	%  <input  name='A'>Normals of constraints (row-wise)</input>
	%  <input  name='b'>Offsets of constraints (row-wise) length(b)==size(A,1)</input>
	%  <output name='P' class='Polyhedron'>Hrep Polyhedron {x | Ax &lt;=b}</output>
	% </syntax>
	%
	% <syntax>
	%  <desc>Convert from YALMIP polyhedron</desc>
	%  <input  name='F'>Yalmip constraints</input>
	%  <input  name='vars'>All variables involved in F</input>
	%  <output name='P' class='Polyhedron'>Hrep Polyhedron {x | Ax &lt;=b}</output>
	% </syntax>
	%
	% <seeAlso>affineMap</seeAlso>
	% <seeAlso>contains</seeAlso>
	%
	% </matDoc>
	%
	
	
	% A polyhedron.
	%
	% This class repreents the following polyhedra:
	%  - unbounded polyhedra
	%  - lower-dimensional polyhedra
	%  - non-pointed polyhedra, or those that do not contain any vertices
	%  (e.g. <eq>\{x\in\mathbb{R}^2\,|\,x_1 \le 0\}</eq>)
	%
	% We examine each of these three points in the following sections.
	% <p>
	% <b>Unbounded Polyhedra</b><p>
	% All polyhedra can be decomposed into the sum of a bounded polytope a cone:
	% <eq>  P = \operatorname{conv}(V) + \operatorname{cone}(R)</eq><br>
	% and satisfy the Minkowski-Weyl theorem and can therefore be represented
	% either as the
	% intersection of a finite number of inequalities, or as the convex
	% combination of a finite
	% number of vertices (or rays).
	% <p>
	% <i>MPT3.0 will store all irredundant polyhedra as a decomposition into a polytope and a cone.</i><p>
	% <p>
	% <b>Lower-dimensional Polyhedra</b><p>
	% Theoretically there is no difference between full-dimensional and lower-dimensional
	% polyhedra either in representation or in the algorithms that operate on them. However,
	% experience has shown that if the affine hull of the polyhedron is not taken into account
	% explicitly, then virtually all algorithms will fail.
	% <p>
	% <i>MPT3.0 will store a polyhedron as the intersection of a full-dimensional polyhedron and an affine hull.</i>
	% <p>
	% <b>Unpointed Polyhedra</b><p>
	% Operations on polyhedra with non-empty lineality space (i.e. unpointed polyhedra) adds
	% significant complexity and difficulty. Thankfully, all convex sets can be decomposed into
	% the Minkowski sum of their lineality space, with their restriction onto a linear subspace
	% U that is perpendicular to <eq>\operatorname{lineal}(P)</eq><br>
	% <eq>P= \operatorname{lineal}(P) + (P \cap U)</eq><br>
	% where <eq>P \cap U</eq> has an empty lineality space. Therefore, it is always possible to
	% represent an unpointed polyhedron as the lifting of a pointed one:<br>
	% <eq>P = \{Ey\,|\,y \in \tilde P\}</eq><br>
	% where <eq>\tilde P \in \mathbb{R}^m</eq> is pointed and <eq>E \in \mathbb{R}^{n\times m}</eq> with n > m.
	% <p>
	% The requirement of dealing with an additional lifting operation for all polyhedra will add
	% more coding complexity to \mptThree than desired. Therefore, in the interest of
	% simplicity, MPT3.0 will handle unpointed polyhedra only in halfspace form, where the
	% lifting map is not required, and any operation that cannot function on lifted polyhedra
	% will return an error.
	% <p>
	% <i>MPT3.0 will have a limited ability to operate on unpointed polyhedra.  It will
	% handle unpointed polyhedra only in halfspace form, where the lifting map is not
	% required, and any operation that does not function on unpointed
	% polyhedra will throw an exception.</i>
	%
	% @author cjones
	%
	% see also Polyhedron.Polyhedron
	
	
	properties(SetAccess=private, GetAccess=private, Hidden)
		H_int  = []; % Inequality description {x | H*[x;-1] <= 0}
		He_int = []; % Affine set description {x | He*[x;-1] = 0}
		V_int  = []; % Vertex description {V'*lam | lam >= 0, sum(lam) = 1}
		R_int  = []; % Cone description {R'*gam | gam >= 0}
	end
	
	properties(SetAccess = private)
		irredundantVRep = false; % True if the V-Representation is irredundant
		irredundantHRep = false; % True if the H-Representation is irredundant
		hasHRep = false; % True if the H-representation is available
		hasVRep = false; % True if the V-representation is available
	end
	
	properties(SetAccess=private, Transient=true, Hidden)
		% Pre-computed matrices to make solving optimization problems faster
		optMat = []
	end
	
	properties(Constant=true, Hidden)
		% version of the polyhedron object is used to do proper importing in
		% loadobj()
		%
		% History:
		%   1.0: September 25, 2012 (introduction of lazy getters)
		version = 1.0
	end
	
	properties(Dependent=true, SetAccess=private, Transient=true)
		A  % Inequality description { x | A*x <= b }
		b  % Inequality description { x | A*x <= b }
		Ae % Affine set description { x | Aeq*x == be }
		be % Affine set description { x | Aeq*x == be }
		H  % Inequality description { x | H*[x; -1] <= 0 }
		He % Affine set description { x | He*[x; -1] == 0 }
		R  % Rays of the polyhedron
		V  % Vertices of the polyhedron
	end
	
	methods
		% lazy getters
		function A = get.A(obj)
			if ~obj.hasHRep && obj.hasVRep
				obj.computeHRep();
			end
			A = obj.H_int(:, 1:end-1);
		end
		function b = get.b(obj)
			if ~obj.hasHRep && obj.hasVRep
				obj.computeHRep();
			end
			b = obj.H_int(:, end);
		end
		function Ae = get.Ae(obj)
			if ~obj.hasHRep && obj.hasVRep
				obj.computeHRep();
			end
			Ae = obj.He_int(:, 1:end-1);
		end
		function be = get.be(obj)
			if ~obj.hasHRep && obj.hasVRep
				obj.computeHRep();
			end
			be = obj.He_int(:, end);
		end
		function H = get.H(obj)
			if ~obj.hasHRep && obj.hasVRep
				obj.computeHRep();
			end
			H = obj.H_int;
		end
		function He = get.He(obj)
			if ~obj.hasHRep && obj.hasVRep
				obj.computeHRep();
			end
			He = obj.He_int;
		end
		function V = get.V(obj)
			if ~obj.hasVRep && obj.hasHRep
				obj.computeVRep();
			end
			V = obj.V_int;
		end
		function R = get.R(obj)
			if ~obj.hasVRep && obj.hasHRep
				obj.computeVRep();
			end
			R = obj.R_int;
		end
		function M = get.optMat(obj)
			M = obj.optMat;
			if isempty(M)
				M = obj.buildSetRepresentation;
				obj.optMat = M;
			end
		end
	end
	
	methods(Access = public)
		
		function obj = Polyhedron(varargin)
			% POLYHEDRON Create a polyhedron object.
			%
			% -------------------------------------------------------------------
			% Description
			% -------------------------------------------------------------------
			%
			% Define a polyhedron:
			%
			%  P = {x | H*[x;-1] <= 0} cap {x | He*[x;-1] = 0}
			%
			% or
			%
			%  P = {V'lam | lam >= 0, sum(lam) = 1} + {R'gam | gam >= 0}
			%
			% -------------------------------------------------------------------
			% Syntax
			% -------------------------------------------------------------------
			%
			% P = Polyhedron(varargin)
			%
			% Parameters specified as param/value pairs: (all optional)
			%  H  - Inequality description (must be full-dimensional) {x | H*[x;-1] <= 0}
			%  He - Affine set {x | He*[x;-1] = 0}
			%  V  - Points defining the set conv(V)
			%  R  - Rays defining the set cone(R)
			%  irredundantVRep - [false] If true, then the given V-Rep is
			%                    assumed irredundant
			%  irredundantHRep - [false] If true, then the given H-Rep is
			%                    assumed irredundant
			%  lb - Lower bound
			%  ub - Upper bound
			%  Data - arbitraty user data
			%
			% -------------------------------------------------------------------
			% Shorthand syntax
			%
			%  P = Polyhedron(Polyhedron). Copy constructor
			%  P = Polyhedron(V),    V = matrix. Create Vrep Polyhedron
			%  P = Polyhedron(A, b), A = matrix, b = vector. Create Hrep Polyhedron
			
			global MPTOPTIONS
			if isempty(MPTOPTIONS)
				MPTOPTIONS = mptopt;
			end
			
			obj.Functions = containers.Map;
			% Shorthand syntax:
			if nargin==0
				% empty Polyhedron object
				obj.Dim = 0;
				obj.H_int = zeros(0, 1);
				obj.He_int = zeros(0, 1);
				obj.Internal=struct('Empty',[],'Bounded',[],'FullDim',[],...
					'InternalPoint',[],'ChebyData',[]);
				return
				
			elseif nargin==2
				A = varargin{1}; b = varargin{2};
				if isnumeric(A) && isnumeric(b)
					% Hrep polyhedron without equality constraints: Polyhedron(A, b)
					H = full([A b]);
					[n, d] = size(A);
					if n~=length(b)
						error('Number of rows does not hold between arguments "A", "b".')
					end

					% replace a'*x<=+/-Inf by 0'*x<=+/-1
					InfRows = isinf(b);
					if any(InfRows)
						% normalize a'*x <= +/-Inf to 0'*x <= +/- 1
						A(InfRows, :) = 0*A(InfRows, :);
						b(InfRows) = sign(b(InfRows));
						H = full([A, b]);
					end

					% replace nearly-zero entries by zero
					H(abs(H)<MPTOPTIONS.zero_tol) = 0;

					obj.Dim = d;
					obj.H_int = H;
					obj.He_int = zeros(0, d+1);
					obj.hasHRep = ~isempty(obj.H_int);
					obj.V_int = zeros(0, d);
					obj.R_int = zeros(0, d);
					obj.Internal=struct('Empty',[],'Bounded',[],'FullDim',[],...
						'InternalPoint',[],'ChebyData',[]);
					obj.Data = [];
					obj.irredundantVRep = false;
					obj.irredundantHRep = false;
					return
					
				elseif isa(A, 'lmi') && isa(b, 'sdpvar')
					% Convert from YALMIP format
					F = A;
					x = b;
					
					h = 0; % Cost func
					solving_parametric = 0;
					options = sdpsettings;
					[interfacedata,recoverdata,solver,diagnostic,F,Fremoved] = compileinterfacedata(F,[],[],h,options,0,solving_parametric);
					
					vars = find(ismember(recoverdata.used_variables,getvariables(x)));
					interfacedata.requested_variables = vars;
					mat = yalmip2mpt(interfacedata);
					
					% Often end up with inf in the RHS of YALMIP objects
					i = isinf(mat.W);
					mat.G(i,:) = [];
					mat.W(i,:) = [];
					obj = Polyhedron('H', full([mat.G mat.W]), 'He', full([mat.Aeq mat.beq]));
					return
				end
				
			elseif nargin==1 && isa(varargin{1}, 'Polyhedron')
				% copy constructor
				obj = varargin{1}.copy();
				return
				
			elseif nargin==1 && isnumeric(varargin{1})
				% Vrep polyhedron: Polyhedron(V)
				obj = Polyhedron('V', varargin{1});
				return
				
			end
			
			% otherwise parse all inputs
			ip = inputParser;
			ip.KeepUnmatched = false;
			ip.addOptional('P', [], @validate_polyhedron);
			ip.addParamValue('H',  [], @validate_realmatrix);
			ip.addParamValue('He', [], @validate_realmatrix);
			ip.addParamValue('V',  [], @validate_realmatrix );
			ip.addParamValue('R',  [], @validate_realmatrix);
			ip.addParamValue('irredundantVRep', false, @validate_logicalscalar );
			ip.addParamValue('irredundantHRep', false, @validate_logicalscalar );
			ip.addParamValue('lb', [], @validate_realinfvector );
			ip.addParamValue('ub', [], @validate_realinfvector );
			ip.addOptional('Data', []); % user data can be anything
			ip.addOptional('A', [], @validate_realmatrix);
			ip.addOptional('b', [], @validate_realinfvector);
			ip.addOptional('Ae', [], @validate_realmatrix);
			ip.addOptional('be', [], @validate_realvector);
			
			ip.parse(varargin{:});
			p = ip.Results;
			
			% collect data from A, b, Ae, be if provided
			if ~isempty(p.A) && ~isempty(p.b)
				if size(p.A,1)~=numel(p.b(:))
					error('Number of rows does not hold between arguments "A", "b".')
				end
				if isempty(p.H)
					p.H =[p.A, p.b(:)];
				else
					if size(p.H,2)~=size(p.A,2)+1
						error('Number of columns does not hold between arguments "H", "A", "b".')
					end
					p.H = [p.H; p.A, p.b(:)];
				end
			end
			if ~isempty(p.Ae) && ~isempty(p.be)
				if size(p.Ae,1)~=numel(p.be(:))
					error('Number of rows does not hold between arguments "Ae", "be".')
				end
				if isempty(p.He)
					p.He = [p.Ae, p.be(:)];
				else
					if size(p.He,2)~=size(p.Ae,2)+1
						error('Number of columns does not hold between arguments "H", "A", "b".')
					end
					p.He = [p.He; p.Ae, p.be(:)];
				end
			end
			
			% Check that dimensions are correct
			d = max([size(p.H,2)-1 size(p.He,2)-1 size(p.V,2) size(p.R,2)]);
			%       if d == 0, error('Dimension must be strictly positive'); end
			if size(p.H,2)  > 0 && size(p.H,2)-1  ~= d || ...
					size(p.He,2) > 0 && size(p.He,2)-1 ~= d || ...
					size(p.V,2)  > 0 && size(p.V,2)    ~= d || ...
					size(p.R,2)  > 0 && size(p.R,2)    ~= d
				error('Input matrices must have the same dimension');
			end
			if d > 0
				if ~isempty(p.lb) && length(p.lb)   ~= d || ...
						~isempty(p.ub) && length(p.ub)  ~= d
					error('Upper lower bounds must be of length %i', d);
				end
			else
				d = max([length(p.lb) length(p.ub)]);
				if ~isempty(p.lb) && length(p.lb) ~= d || ...
						~isempty(p.ub) && length(p.ub) ~= d
					error('Upper lower bounds must be of length %i', d);
				end
			end
			obj.Dim = d;
			
			% check if every LB is actually lower than UB
			if ~isempty(p.lb) && ~isempty(p.ub)
				for i=1:d
					if p.lb(i)>p.ub(i) + MPTOPTIONS.zero_tol
						error('Polyhedron: Lower bound at element %d must not be greater than its upper bound.',i);
					end
				end
			end
			
			% Add upper/lower bounds
			if ~isempty(p.lb), p.H = [p.H;-eye(d) -p.lb(:)]; end
			if ~isempty(p.ub), p.H = [p.H; eye(d)  p.ub(:)]; end

			if ~isempty(p.H)
				% replace a'*x<=+/-Inf by 0'*x<=+/-1
				InfRows = isinf(p.H(:, end));
				if any(InfRows)
					% normalize a'*x <= +/-Inf to 0'*x <= +/- 1
					A = p.H(:, 1:end-1);
					b = p.H(:, end);
					A(InfRows, :) = 0*A(InfRows, :);
					b(InfRows) = sign(b(InfRows));
					p.H = [A, b];
				end
				
				% replace nearly-zero entries by zero
				p.H(abs(p.H)<MPTOPTIONS.zero_tol) = 0;
			end
			if ~isempty(p.He)
				% replace nearly-zero entries by zero
				p.He(abs(p.He)<MPTOPTIONS.zero_tol) = 0;
			end
			if ~isempty(p.V)
				% replace nearly-zero entries by zero
				p.V(abs(p.V)<MPTOPTIONS.zero_tol) = 0;
			end
			if ~isempty(p.R)
				% replace nearly-zero entries by zero
				p.R(abs(p.R)<MPTOPTIONS.zero_tol) = 0;
			end

			% Assign data
			obj.H_int  = full(p.H);
			obj.He_int = full(p.He);
			obj.V_int  = full(p.V);
			obj.R_int  = full(p.R);
			obj.irredundantVRep = false;
			obj.irredundantHRep = false;
			obj.hasHRep = ~isempty(p.H) || ~isempty(p.He);
			obj.hasVRep = ~isempty(p.V) || ~isempty(p.R);
			
			obj.Internal=struct('Empty',[],'Bounded',[],'FullDim',[],'InternalPoint',[],'ChebyData',[]);
			obj.Data = p.Data;
						
			if size(obj.R_int,1) > 0 || size(obj.V_int,1) > 0
				obj.irredundantVRep = p.irredundantVRep;
			end
			if size(obj.H_int,1) > 0
				obj.irredundantHRep = p.irredundantHRep;
			end
			
			% Fix sizes of empty data
			if isempty(obj.H_int),  obj.H_int  = zeros(0,d+1); end
			if isempty(obj.He_int), obj.He_int = zeros(0,d+1); end
			if isempty(obj.V_int),  obj.V_int  = zeros(0,d);   end
			if isempty(obj.R_int),  obj.R_int  = zeros(0,d);   end
			
			% Add the origin if this is a cone
			if size(obj.R_int,1)>0 && size(obj.V_int,1)==0
				% fprintf('Adding the origin to this cone');
				obj.V_int = zeros(1,d);
            end

			% Compute a minimum representation for the affine set
			obj.minAffineRep;
			
		end

		function answer = isPointed(P)
			% returns true if the polyhedron is pointed
			%
			% A polyhedron { x | A*x<=b, C*x=d } is pointed if and only if
			% its lineality space null([A; C]) is empty.
			%
			% Literature:
			% http://www.ee.ucla.edu/ee236a/lectures/polyhedra.pdf
			
			answer = false(size(P));
			for i = 1:numel(P)
				% note that conversion to H-rep will be performed!
				answer(i) = isempty(null([P.A; P.Ae]));
			end
		end
		
		function R = and(P, Q)
			% P&Q computes intersection of two polytopes
			
			R = intersect(P, Q);
		end
		
		function [H, isConvex] = or(P, Q)
			% P|Q computes union of two polytopes
			%
			% U = P | Q returns a single polyhedron (the convex hull) if
			% the union of P and Q is convex. Otherwise U=[P; Q].
			%
			% [U, isConvex] = P | Q also returns a binary flag indicating
			% convexity.
			
			U = PolyUnion([P(:); Q(:)]);
			isConvex = U.isConvex();
			if isConvex
				H = U.convexHull();
			else
				H = [P(:); Q(:)];
			end
        end
        
        function [new, unique_idx, idx] = unique(P)
            % Returns unique components of an array of Polyhedron objects
            %
            % U = P.unique() returns only the unique elements of the array
            % P. [U, idx] = P.unique() returns the indices of unique
            % elements as the second output.
            
            idx = false(numel(P), numel(P));
            is_unique = true(size(P));
            for i = 1:numel(P)-1
                for j = i+1:numel(P)
                    if ~(idx(j, i))
                        answer = P(i)==P(j);
                        idx(j, i) = answer;
                        if answer
                            is_unique(j) = false;
                            break
                        end
                    end
                end
            end
            new = copy(P(is_unique));
            unique_idx = find(is_unique);
        end
        
        function Q = projectOnAffineHull(P)
            % Projects the polyhedron on its affine hull
            %
            % Given a polyhedron P = { x | A*x<=b, Ae*x=be }, calling
            % Q = P.projectOnAffineHull() produces a new polyhedron
            % Q = { z | A*F*z <= b - A*x0 } where F is in the null space of
            % Ae and x0 is any solution to Ae*x0=be.
            %
            % The equality constraints are identified via
            % Polyhedron/affineHull().
            %
            % The dimensionality of Q is dim(P)-rank(Ae, be).
            
            P.minHRep();
            Q = P.copy();
            for i = 1:numel(P)
                He = P(i).affineHull();
                if ~isempty(He)
                    % fully dimensional in a lower dimension
                    F = null(He(:, 1:end-1));
                    x0 = He(:, 1:end-1)\He(:, end);
                    A = P(i).A*F;
                    b = P(i).b - P(i).A*x0;
                    if isempty(A)
                        % projection is R^m with m = dim(P)-rank(Ae)
                        Q(i) = Polyhedron.fullSpace(size(A, 2));
                    else
                        Q(i) = Polyhedron(A, b);
                    end
                end
            end
                
        end
		
		function answer = isFullSpace(P)
			% returns true if the polyhedron represents R^n
			
			global MPTOPTIONS
			
			answer = false(size(P));
			for i = 1:numel(P)
				if P(i).hasHRep
					
					if ~isempty(P(i).He_int)
						% affine set is not R^n
					
					elseif isempty(P(i).He_int) && ...
						all(matNorm(P(i).H_int(:, 1:end-1)) < MPTOPTIONS.zero_tol) && ...
							all(P(i).H_int(:, end) > -MPTOPTIONS.zero_tol)
						% 0*x<=b with "b" non-negative => R^n
						%
						% Note that the polyhedron constructor already
						% removed rows like a'*x<=Inf, which are the only
						% other description of R^n
						answer(i) = true;
					end
					
				elseif P(i).hasVRep && ~isempty(P(i).R_int)
					% check whether rays span R^n
					
					% the rays span R^n if there exists lambda>=0 such
					% that R*lambda gives each basis vector of R^n
					
					answer(i) = true; % will be unset later if necessary
					
					% set of basis vectors
					E = [eye(P(i).Dim), -eye(P(i).Dim)];
					R = P(i).R_int';
					nR = size(R, 2);
					lp.f = zeros(nR, 1);
					lp.A = -eye(nR);
					lp.b = zeros(nR, 1);
					lp.Ae = R;
					lp.be = [];
					lp.lb = zeros(nR, 1);
					lp.ub = Inf(nR, 1);
					lp.quicklp = true;
					for j = 1:size(E, 2)
						% solve the feasibility LP:
						%   find lambda>=0, s.t. R*lambda=E(:, j)
						lp.be = E(:, j);
						res = mpt_solve(lp);
						if res.exitflag ~= MPTOPTIONS.OK
							% infeasible, the conic combinations of
							% rays failed to provide a basis vector
							answer(i) = false;
							break
						end
					end
					
				end
			end
		end
	end
	
	methods(Hidden)
		% non-public methods

		% Polyhedron/isInside() implicitly assumes that the
		% H-representation is available. Use it only if you know what you
		% are doing! In general cases you should use Polyhedron/contains()
		% instead.
		[isin, inwhich, closest] = isInside(P, x, Options);
		
	end
	
	methods(Static)
	
		function S = emptySet(dim)
			% Polyhedron.emptySet(n) constructs an empty set in R^n

			error(nargchk(1, 1, nargin));
			S = Polyhedron(zeros(0, dim), zeros(0, 1));
			S.Internal.Empty = true;
			S.Internal.FullDim = false;
			S.Internal.lb = Inf(dim, 1);
			S.Internal.ub = -Inf(dim, 1);
		end

		function S = fullSpace(dim)
			% Polyhedron.fullSpace(n) constructs the H-representation of R^n

			% R^n is represented by 0'*x<=1
			S = Polyhedron(zeros(1, dim), 1);
			S.irredundantHRep = true;
			S.Internal.Empty = (dim==0); % R^0 is an empty set
			S.Internal.FullDim = (dim>0); % R^0 is not fully dimensional
			S.Internal.Bounded = (dim==0); % R^0 is bounded
			S.Internal.lb = -Inf(dim, 1);
			S.Internal.ub = Inf(dim, 1);
		end
		
		function B = unitBox(dim)
			% Polyhedron.unitBox(n) constructs a unit box in "n" dimensions
			
			error(nargchk(1, 1, nargin));
			B = Polyhedron('lb', -ones(dim, 1), 'ub', ones(dim, 1), ...
				'irredundantHRep', true);
		end

		function new = loadobj(obj)
			% load Polyhedron objects
			
			% NOTE: loadobj() must be a static method!
			
			% empty polyhedron will provide us with the version in
			% base.version
			base = Polyhedron;
			if ~isprop(obj, 'version')
				% ancient version before September 25, 2012
				if isempty(obj.H) && isempty(obj.He)
					% Vrep
					new = Polyhedron('V', obj.V, 'R', obj.R);
				elseif isempty(obj.V) && isempty(obj.R)
					% Hrep
					new = Polyhedron('H', obj.H, 'He', obj.He);
				else
					% mixed V/H rep
					new = Polyhedron('H', obj.H, 'He', obj.He, ...
						'V', obj.V, 'R', obj.R);
				end
				% TODO: import functions?
			elseif obj.version > base.version
				error('Version of loaded object: %.1f, supported version: %.1f.', ...
					obj.version, base.version);
			else
				% object is up-to-date, just use the copy constructor
				new = Polyhedron(obj);
			end
		end
	end
	
	methods (Access=protected)
		
		% function prototypes (plotting methods must remain protected)
		h = fplot_internal(obj, function_name, options)
		h = plot_internal(obj, options)

	end
	
end

