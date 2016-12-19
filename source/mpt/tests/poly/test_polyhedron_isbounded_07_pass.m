function test_polyhedron_isbounded_07_pass
%
% isbounded test
% 
% 

% all should be bounded
P = [Polyhedron(randn(3,7)) Polyhedron Polyhedron(randn(12,2),ones(12,1))];

if ~all(isBounded(P))
    error('Given polyhedron objects should be bounded.');
end

end
