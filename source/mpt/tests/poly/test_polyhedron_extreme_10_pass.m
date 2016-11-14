function test_polyhedron_extreme_10_pass
%
% array of empty polyhedron & unbounded
%

% too many inequalities, empty
H = [randn(143,8), 5*randn(143,8)];  
P(1) = Polyhedron('H',H);

% unbounded
P(2) = Polyhedron(rand(14,5));

% test if p(1) is built from zeros
if any(any(P(1).V)) || any(any(P(1).R))
    error('P(1) is empty, zeros should be returned in V.')
end

end
