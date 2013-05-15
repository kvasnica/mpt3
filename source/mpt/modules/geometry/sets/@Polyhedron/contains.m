function tf = contains(P, x) 
% CONTAINS Test if the point/polyhedron is contained within this
% polyhedron.
%
% ------------------------------------------------------------------
% tf = contains(x)
% 
% Param
%  x - vector of the same length as the dimension of the polyhedron
%     or column composed matrix from the multiple vectors x
%
% Returns true if x is within this polyhedron, false otherwise.
% Returns [] if this polyhedron is empty.
%
% ------------------------------------------------------------------
% tf = contains(S)
% 
% Param
%  S - polyhedron
%
% Returns true if S is within this polyhedron, false otherwise.
% Returns [] if this polyhedron is empty.

global MPTOPTIONS
if isempty(MPTOPTIONS)
    MPTOPTIONS = mptopt;
end

%% tolerance settings taken from global options
% tolerance for polyhedron
% MPTOPTIONS.rel_tol;

% tolerance for point inside the polyhedron
% H-polyhedron -> MPTOPTIONS.abs_tol
% V-polyhedron -> MPTOPTIONS.rel_tol

%% deal with arrays
no = numel(P);
if no>1
    if isvector(x)        
        % allocate false for all statements
        tf = false(size(P));
        parfor i=1:no
            tf(i) = P(i).contains(x);
        end
    else
        % x is matrix, number of cols=dim of P, number of rows determines        
        % how many points to evaluate
        if size(P,1)>size(P,2)
            tf = false(no,size(x,1));
            parfor i=1:no
                tf(i,:) = P(i).contains(x);
            end
        else
            tf = false(size(x,1),no);
            parfor i=1:no
                tf(:,i) = P(i).contains(x);
            end
        end
    end
    return
end


%% Case 2 above : Test if S is contained in P
if isa(x, 'Polyhedron')
  S = x;
  if numel(S)>1
      error('Can test only single polyhedron S.');
  end
  if S.isEmptySet()
	  % empty set is always contained in any other set
	  tf = true;
	  return
  end
  if P.isEmptySet()
	  % empty set cannot contain a non-empty set (note that at this point,
	  % due to the previous check of S.isEmptySet(), we know that S is not
	  % empty)
	  tf = false;
  	  return
  end
  if S.Dim ~= P.Dim,
      error('Polyhedron S must be of the dimension %i.', P.Dim);
  end
  if numel(S)>1
      error('Can test containment only for one polyhedron.');
  end

  
  % Affine hull of P must contain that of S
%   if rank([P.He;S.He], MPTOPTIONS.abs_tol) > rank(P.He, MPTOPTIONS.abs_tol)
%     tf = false;
%     return;
%   end

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
          return;
      end
      
      I = A*S.V' - repmat(b,1,size(S.V,1));
      if any(I(:) > MPTOPTIONS.rel_tol),
          tf = false;
          return;
      end
      
      % if all of the tests passed, check containment of a single point to
      % verify it is ok
      ip = S.interiorPoint;
      if ~P.contains(ip.x)
          tf = false;
          return;
      end
      
    else
      % Test containment of each vertex of S in the points of P
      if any(~P.contains(S.V))
          tf = false;
          return;
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
            return;
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
                return;
            end
        elseif ( s.supp > b(i) + MPTOPTIONS.rel_tol) || nhe>MPTOPTIONS.rel_tol
            tf = false;
            return;
        end
    end
  end
  
  return;
end


%% Case 1 above: test if the point x is contained in P
validate_realmatrix(x);

% check if it is vector and make it row
if isvector(x)
    if size(x,1)>1 && P.Dim~=1
        x = transpose(x);
    end
end
np = size(x,1);
if size(x,2)~=P.Dim
    error('The vector (or matrix) "x" must have %i number of columns.', P.Dim);
end

% allocate outputs
tf = false(np,1);

% empty polyhedron does not contain anything
if P.isEmptySet
    return;
end

for i=1:np
    % If we have an H-rep, use C-version isInside instead
    if P.hasHRep    
        tf(i) = P.isInside(x(i,:)');  
    else    
        % We only have V-rep, so do it the hard way
        sol = P.project(x(i,:));
        % normalized distance scales better for increasing the size of the
        % polyhedron -> try test_polyhedron_contains_04_pass for P, 10*P, 100*P, etc.
        if sol.dist < MPTOPTIONS.rel_tol
            tf(i) = true;
        end
    end
end

end
