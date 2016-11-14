function test_polyhedron_extreme_01_pass
%
% unitbox
%

P = Polyhedron('lb',[-1;-1;-1;-1;-1],'ub',[1;1;1;1;1]);

P.computeVRep();

if any(sum(abs(P.V),2)~=5)
    error('Vertices must be all equal 1.');
end

end
