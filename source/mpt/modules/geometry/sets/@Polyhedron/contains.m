function tf = contains(P, x, fastbreak)
%
% Polyhedron/contains
%
% Synopsis
% ---
%
% Tests whether a point or a polyhedron is a subset of another polyhedron
%
% Syntax
% ---
%
% status = P.contains(x)
% status = P.contains(x, fastbreak)
%
% Inputs:
% ---
%
% P: polyhedron or an array of polyhedra with "m" elements
% x: point or set of "n" points (see note below)
%    polyhedron or polyhedron array with "n" elements
% fastbreak: boolean, if true, test will be aborted as soon as at least one
%            element of "P" contains point "x"
%            (false by default)
%
% Note: if "x" is a double, then it must be either a column vector, or a
% matrix composed of column vectors. No automatic transposition of "x" is
% performed!
%
% Outputs:
% ---
%
% if "x" is a single point or a single polyhedron:
%   "status" is a (m x 1) vector of true/false, 
%   "status(i)=true" iff "P(i)" contains "x"
%
% if "x" is a matrix of points (i.e., x = [x_1, ..., x_n])
%   "status" is a (m x n) matrix of true/false, 
%   "status(i, j)=true" iff "P(i)" contains point "x(:, j)"
%
% if "x" is a polyhedron, then "P.contains(x)" <=> "x \subseteq P"

global MPTOPTIONS

error(nargchk(2, 3, nargin));
if ~( isnumeric(x) || isa(x, 'Polyhedron') )
	error('The input must be a real vector/matrix or a Polyhedron object.');
end
if nargin<3
	fastbreak = false;
end

m = numel(P);
if isnumeric(x)
	[d,n] = size(x);    
else
	n = numel(x);
	if n > 1
		% TODO: use setdiff for arrays
		error('Can only test containment of a single polyhedron.');
	end
end

if m==0
	% empty polyhedron array
	tf = [];
	
elseif isnumeric(x) && m==1 && P.hasHRep
	% special case:
	%   P = single polyhedron in H-rep
	%   x = single or multiple points
	%
	% this is a frequent case in Polyhedron/meshGrid, which needs to be as
	% fast as possible to have decent runtime of Polyhedron/fplot
    if d~=P.Dim
        error('The point(s) must have the dimension %i as the set.',P.Dim);
    end
	tf = false(m, n);
	for i = 1:n
		% iterate over points
		if any(P.H_int*[x(:, i); -1] > MPTOPTIONS.abs_tol)
			% not in the inequality Hrep
		elseif ~isempty(P.He_int) && ...
				any(abs(P.He_int*[x(:, i); -1]) > MPTOPTIONS.abs_tol)
			% not in the equality Hrep
		else
			tf(i) = true;
		end
	end
	
elseif isnumeric(x) && all([P.hasHRep])
	% special case:
	%   P = array of H-rep polyhedra
	%   x = single or multiple points
	%
	% this is so frequently used by PolyUnion/contains that it deserves a
	% fast implementation
	tf = false(m, n);
	for i = 1:n
		[~, inwhich] = P.isInside(x(:, i), struct('fastbreak', fastbreak));
		tf(inwhich, i) = true;
	end
	
elseif m>1
	% "P" is an array
	tf = false(m, n);
	for i = 1:m
		tf(i, :) = P(i).contains(x, fastbreak);
	end
	
elseif isnumeric(x) && n>1
	% "P" is a single polyhedron, "x" = multiple points
	tf = false(1, n);
	for i = 1:n
		tf(i) = P.contains(x(:, i), fastbreak);
	end
	
elseif isnumeric(x)
	% "P" is a single polyhedron, "x" is a single point
	tf = sub_contains_point(P, x);
	
else
	% "P" is a single polyhedron, "x" is a single polyhedron
	tf = sub_contains_polyhedron(P, x);
	
end

end

%-------------------------------------
function tf = sub_contains_polyhedron(P, S)

global MPTOPTIONS

if S.isEmptySet()
	% empty set is always contained in any other set
	tf = true;
	return
	
elseif P.isEmptySet()
	% empty set cannot contain a non-empty set (note that at this
	% point, due to the previous check of x.isEmptySet(), we know that
	% "x" is not empty)
	tf = false;
	return
	
elseif S.Dim ~= P.Dim
	error('Polyhedron S must be of the dimension %i.', P.Dim);
	
end

tf = true;
if S.hasVRep
	if P.hasHRep
		% Easiest case => test each ray and vertex
		P.minHRep();
		
		% check also equalities
		A = [P.A;P.Ae;-P.Ae]; b = [P.b;P.be;-P.be];
		
		I = A*S.R' - repmat(b,1,size(S.R,1));
		if any(I(:) > MPTOPTIONS.rel_tol),
			tf = false;
			return
		end
		
		I = A*S.V' - repmat(b,1,size(S.V,1));
		if any(I(:) > MPTOPTIONS.rel_tol),
			tf = false;
			return
		end
		
		% if all of the tests passed, check containment of a single point to
		% verify it is ok
		ip = S.interiorPoint;
		if ~P.contains(ip.x)
			tf = false;
			return
		end
		
	else
		% Test containment of each vertex of S in the points of P
		if any(~P.contains(S.V')) % points must be stored column-wise
			tf = false;
			return
		end
		
	end
else
	% S is an H-rep => Need an H-rep of P
	P.minHRep();
	
	% check outer approximations first
	P.outerApprox();
	S.outerApprox();
	Plb = P.Internal.lb;
	Pub = P.Internal.ub;
	Slb = S.Internal.lb;
	Sub = S.Internal.ub;
	bbox_tol = MPTOPTIONS.rel_tol*1e2;
	if any(Slb + bbox_tol < Plb) || any(Sub - bbox_tol > Pub),
		% outer approximation of S is not contained in the outer
		% approximation of P, hence S cannot be contained in P
		tf = false;
		return
	end
	
	% check also equalities
	A = [P.A;P.Ae;-P.Ae]; b = [P.b;P.be;-P.be];
	
	% Easy case => support for each row of S must be less than that for P
	for i=1:size(A,1)
		s = S.extreme(A(i,:)');
		if s.exitflag~=MPTOPTIONS.OK
			% infeasible, or unbounded, or error  -> return false
			tf = false;
			return
		end
		% check also equalities if present
		if ~isempty(P.He_int)
			nhe = norm(P.Ae*s.x - P.be,Inf);
		else
			nhe=0;
		end
		
		% scaling the support is better if normalizing by b(i) -> see
		% test_polyhedron_contains_05_pass for P, 10*P, 100*P, etc.
		if norm(b(i),Inf)>MPTOPTIONS.rel_tol
			if ( s.supp/abs(b(i)) > b(i)/abs(b(i)) + MPTOPTIONS.rel_tol) || nhe>MPTOPTIONS.rel_tol
				tf = false;
				return
			end
		elseif ( s.supp > b(i) + MPTOPTIONS.rel_tol) || nhe>MPTOPTIONS.rel_tol
			tf = false;
			return
		end
	end
end

end

%-------------------------------------
function tf = sub_contains_point(P, x)

global MPTOPTIONS

nx = numel(x);
if P.isEmptySet()
	% empty set cannot contain any point
	tf = false;
	
elseif nx~=P.Dim
	error('The vector/matrix "x" must have %i rows.', P.Dim);

elseif P.hasHRep
	tf = P.isInside(x);
	
else
	% We only have V-rep, so do it the hard way
	sol = P.project(x);
	% normalized distance scales better for increasing the size of the
	% polyhedron -> try test_polyhedron_contains_04_pass for P, 10*P, 100*P, etc.
	tf = (sol.dist < MPTOPTIONS.rel_tol);

end

end
