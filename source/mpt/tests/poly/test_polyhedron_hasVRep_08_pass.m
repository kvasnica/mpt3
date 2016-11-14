function test_polyhedron_hasVRep_08_pass
%
% conflicting polyhedron
%

% H and V-rep do not match
R = Polyhedron('lb',[0 0 0],'R',[randn(1,2) 0],'V',[-1 0.2 3;-2 -1 -3]);

if ~R.hasVRep || ~R.hasHRep
    error('This must have both representations.');
end
    

end