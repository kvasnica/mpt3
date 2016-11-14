function test_polyhedron_eq_03_pass
%
% empty polyhedron-polyhedron
% 

P = Polyhedron;
Q = Polyhedron;

ts = (P==Q);

if ~ts
    error('The result should be true.');
end

end
