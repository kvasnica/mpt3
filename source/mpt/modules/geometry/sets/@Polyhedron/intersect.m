function PnS = intersect(P, S)
% INTERSECT Compute the intersection of the given polyhedron with this one.
% 
% PnS = P.intersect(S)
% PnS = intersect(P, S)
%
% Note: If P or S are in V-rep, then this function will first compute their
% convex hull.
%
% Parameters: 
%  S - Polyhedron of dimension P.Dim
%
% Returns:
%  PnS - New polyhedron that it the intersection of P and S
%

global MPTOPTIONS

% check polyhedron
validate_polyhedron(S);
if numel(S)>1
    error('Only one polyhedron S is allowed.');
end

% deal with arrays
if numel(P)>1
    PnS(size(P)) = Polyhedron;
    for i=1:numel(P)
        PnS(i) = intersect(P(i),S);
    end
    return;
end

% check dimension
if S.Dim ~= P.Dim,
    error('Dimension of S must be the same as P (%i).', P.Dim);
end

% if we have outer approximations, use them to quickly determine
% non-intersecting polyhedra
if isfield(P.Internal, 'lb') && isfield(P.Internal, 'ub') && ...
		isfield(S.Internal, 'lb') && isfield(S.Internal, 'ub')
	Plb = P.Internal.lb;
	Pub = P.Internal.ub;
	Slb = S.Internal.lb;
	Sub = S.Internal.ub;
	if any(Pub+MPTOPTIONS.rel_tol < Slb) || ...
			any(Sub+MPTOPTIONS.rel_tol < Plb)
		% outer box approximations do not intersect, hence polyhedra do not
		% intersect
		PnS = Polyhedron.emptySet(P.Dim);
		return
	end
end

% do convex hull if does not exist
if ~P.hasHRep,
    P.minHRep();
end
if ~S.hasHRep,
    S.minHRep(); 
end

if isempty(P.He_int) && isempty(S.He_int)
	if isempty(P.H_int) || isempty(S.H_int)
		% intersection with an empty set gives an empty set
		PnS = Polyhedron.emptySet(P.Dim);
	else
		% faster call using just Ax<=b
		PnS = Polyhedron([P.A; S.A], [P.b; S.b]);
	end
else
	PnS = Polyhedron('H', [P.H_int;S.H_int], 'He', [P.He_int;S.He_int]);
end


% if P.hasHRep
%   % Cheaper to just compute the convex hull for low-dimensions
% %   if ~S.hasHRep && S.Dim < 4, S.minHRep(); end 
%   
%   if S.hasHRep
%     PnS = Polyhedron('H', [P.H;S.H], 'He', [P.He;S.He]);
%   else
%     % Hrep P cap Vrep S
%     % Form Polyhedron Q = {[A 0; 0 -I]*[x;lam;gam] <= [b;0], 
%     % [Ae 0 0;-I V' R';0 1' 0]*[x;lam;gam] = [e;0;1]}
%     nV = size(S.V,1); nR = size(S.R,1);
%     H  = [P.A zeros(size(P.A,1),nV+nR) P.b];
%     H  = [H;zeros(nV+nR,P.Dim) -eye(nV+nR) zeros(nV+nR,1)];
%     He = [P.Ae zeros(size(P.Ae,1),nV+nR) P.be;...
%       -eye(P.Dim) S.V' S.R' zeros(P.Dim,1);...
%       zeros(1,P.Dim) ones(1,nV) zeros(1,nR) 1];
%     Q = Polyhedron('H', H, 'He', He);
%     PnS = Q.projection(1:P.Dim);
%   end
% else
%   if S.hasHRep
%     PnS = intersect(S,P);
%   else % Vrep P cap Vrep S
%     error('Intersection of two Vrep polyhedra not implemented yet');
%   end
% end

end
