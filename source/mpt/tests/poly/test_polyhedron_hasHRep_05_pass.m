function test_polyhedron_hasHRep_05_pass
%
% ray
%

P = Polyhedron('R',[0 0 1]);

if P.hasHRep
    error('This must be ray.');
end
    

end