function test_polyhedron_facetInteriorPoints_03_pass
%
% empty polyhedron returns empty interior points
%

P(1) = Polyhedron;
P(2) = Polyhedron('A',randn(56,2),'b',randn(56,1));

% Polyhedron/facetInteriorPoints must reject arrays
[~, msg] = run_in_caller('x = P.facetInteriorPoints;');
asserterrmsg(msg, 'This method does not support arrays. Use the forEach() method.');

% forEach must require UniformOutput=false
[~, msg] = run_in_caller('x=P.forEach(@(e) e.facetInteriorPoints);');
asserterrmsg(msg, 'Non-scalar in Uniform output, at index 1, output 1.');

% this must work
x = P.forEach(@(e) e.facetInteriorPoints, 'UniformOutput', false);

if ~all(cellfun('isempty',x))
    error('Must return empty points.');
end

end
