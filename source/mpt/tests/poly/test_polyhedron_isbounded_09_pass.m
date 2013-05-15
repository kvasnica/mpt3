function test_polyhedron_isbounded_09_pass
%
% isbounded test
% 
% 

% unbounded x1,x2,x3>=0
P = Polyhedron(-eye(3),zeros(3,1));

% bounded
Q = Polyhedron('V',[0.5 -1.8 4;3 -2 0.6]);

% test on operations
R = [P+Q P-Q 2*P+1/3*Q 2*P-3*Q];
if any(isBounded(R))
   error('Given polyhedron object should be unbounded.');
end
