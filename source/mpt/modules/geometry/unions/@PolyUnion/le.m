function status = le(U1, U2)
% tests whether U1 is a (non-strict) subset of U2

if isa(U1, 'Polyhedron')
	U1 = PolyUnion(U1);
end
if isa(U2, 'Polyhedron')
	U2 = PolyUnion(U2);
end
if ~isa(U1,'PolyUnion') || ~isa(U2,'PolyUnion')
    error('All inputs must be PolyUnion objects.');
end
% use forEach if you have multiple unions
error(U1.rejectArray());
error(U2.rejectArray());

if (U1.Num==0 || all(isEmptySet(U1.Set)))
	% empty set is contained in any set
	status = true;
	return
end
if (U2.Num==0 || all(isEmptySet(U2.Set)));
	% non-empty set U1 cannot contain an empty set
	status = false;
	return
end

% heuristics: check containement of outer approximations
B1 = U1.outerApprox();
B2 = U2.outerApprox();
if ~(B1 <= B2)
	status = false;
	return
end

if U2.Num==1
	% simpler case, test whether each elements of U1 is contained in
	% U2.Set(1)
	for i = 1:U1.Num
		if ~(U1.Set(i) <= U2.Set(1))
			status = false;
			return
		end
	end
	status = true;

else
	% complicated case, compute set difference using the "noconstruction"
	% mode
	status = all(isEmptySet(mldivide(U1.Set, U2.Set, true)));
	
end

end
