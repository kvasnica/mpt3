function test_polyhedron_16_pass
%
% empty by construction 
%

% empty polyhedron lb < Inf
P1=Polyhedron('lb', [1; Inf]);

if ~P1.isEmptySet
    error('This polyhedron must be empty.');
end

% empty polyhedron ub < -Inf
P2=Polyhedron('ub', -Inf);

if ~P2.isEmptySet
    error('This polyhedron must be empty.');
end



end