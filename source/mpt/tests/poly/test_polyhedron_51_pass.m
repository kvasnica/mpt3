function test_polyhedron_51_pass
% constructor fails on sparse inputs (issue #135)

P = Polyhedron('A',sparse([1 0;0 1]),'b',[1;1],'Ae',sparse([1 1]),'be',1);

% all properties should be fullified:
assert(~issparse(P.A));
assert(~issparse(P.b));
assert(~issparse(P.H));

P = Polyhedron(sparse([1 0; 0 1; -1 0; 0 -1]), sparse([1; 1; 0; 0]));
assert(~issparse(P.A));
assert(~issparse(P.b));
assert(~issparse(P.H));
 
P = Polyhedron('A', sparse([1 0; 0 1; -1 0; 0 -1]), 'b', sparse([1; 1; 0; 0]));
assert(~issparse(P.A));
assert(~issparse(P.b));
assert(~issparse(P.H));

P = Polyhedron(sparse([1 0; 0 1; -1 0; 0 -1]), [1; 1; 0; 0]);
assert(~issparse(P.A));
assert(~issparse(P.b));
assert(~issparse(P.H));
 
P = Polyhedron([1 0; 0 1; -1 0; 0 -1], sparse([1; 1; 0; 0]));
assert(~issparse(P.A));
assert(~issparse(P.b));
assert(~issparse(P.H));

P = Polyhedron([1 0; 0 1; -1 0; 0 -1], [1; 1; 0; 0]);
assert(~issparse(P.A));
assert(~issparse(P.b));
assert(~issparse(P.H));

end
