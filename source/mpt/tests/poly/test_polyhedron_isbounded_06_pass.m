function test_polyhedron_isbounded_06_pass
%
% isbounded test
% 
% 

% V-rep is always bounded
P = Polyhedron(randn(3,7));

if ~isBounded(P)
    error('Given polyhedron object should be bounded.');
end
