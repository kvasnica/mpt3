function test_polyhedron_isbounded_08_pass
%
% isbounded test
% 
% 

% all should be unbounded
P = [Polyhedron([1:5;-2:2],[0.5;-1.4]) Polyhedron(toeplitz(1:5),(1:5)')];

if any(isBounded(P))
    error('Given polyhedron objects should be unbounded.');
end

end
