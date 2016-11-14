function test_polyhedron_hasVRep_05_pass
%
% ray
%

P = Polyhedron('R',[0 0 1]);

if ~P.hasVRep
    error('This must be ray.');
end
    

end