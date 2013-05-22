function test_union_contains_05_pass
%
% empty union 
%

for i=1:5
    P(i) = Polyhedron;
end

U = Union('Set',P);

% the point must be a column vector
[~, msg] = run_in_caller('U.contains([])');
asserterrmsg(msg, 'The point must be a column vector.');

end
