function test_polyhedron_plus_19_pass
% issue reported by Truong Nghiem on March 30, 2014

A = [1 0 0.02 0; 0 1 0 0.02; 0 0 1 0; 0 0 0 1];
wmax = 0; epsilon = 0.2;

P1 = Polyhedron('lb', -wmax*ones(4,1), 'ub', wmax*ones(4,1));
P2 = Polyhedron('lb', -epsilon*ones(4,1), 'ub', epsilon*ones(4,1));
P3 = Polyhedron('lb', -epsilon*ones(4,1), 'ub', epsilon*ones(4,1));

What1 = P1 + A*P2 + (-P3);
What2 = minVRep(P1) + minVRep(A*P2) + minVRep((-P3));

assert(What1.isBounded);
assert(What2.isBounded);
assert(What1==What2);

end
