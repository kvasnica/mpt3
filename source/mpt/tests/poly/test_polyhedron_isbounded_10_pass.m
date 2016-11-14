function test_polyhedron_isbounded_10_pass
%
% isbounded test
% 
% 

% unbounded
P = Polyhedron(eye(3),2*ones(3,1));

% test on operations
R = [2*P +P P+ones(3,1) P-5*ones(3,1)];
if any(isBounded(R))
   error('Given polyhedron object should be unbounded.');
end
