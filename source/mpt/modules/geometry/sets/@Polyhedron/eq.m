function ts = eq(P, S)
% EQUAL Test if the polyhedron is equal to this one.
%
% ------------------------------------------------------------------
% tf = P.eq(S) or P == S
% 
% Param
%  S - polyhedron
%
% Returns true if S is equal to this polyhedron, false otherwise.


validate_polyhedron(S);

% both polyhedra are empty arrays
if numel(P)==0 && numel(S)==0
    ts = true;
    return
end
% of the polyhedra is empty array
if numel(P)==0 || numel(S)==0
    ts = false;
    return
end
    
dimP = [P.Dim];
if any(diff(dimP))
    error('All polyhedra "P" must be of the same dimension.');
end
dimS = [S.Dim];
if any(diff(dimS))
    error('All polyhedra "S" must be of the same dimension.');
end

if dimP(1)~=dimS(1)
  error('Polyhedra must be of the same dimension.');
end

if numel(P)>1 || numel(S)>1
	% first compare outer approximations
	B1 = PolyUnion(P).outerApprox;
	B2 = PolyUnion(S).outerApprox;
	if ~(B1==B2)
		% bounding boxes differ, sets cannot be equal
		ts = false;
	else
		no_construction = true;
		ts = all(isEmptySet(mldivide(S, P, no_construction))) && ...
			all(isEmptySet(mldivide(P, S, no_construction)));
		% Note the special syntax of mldivide with three input arguments,
		% which makes checking for P\S==0 and S\P==0 much faster.
	end
else
    ts = P.contains(S) && S.contains(P);    
end

end
