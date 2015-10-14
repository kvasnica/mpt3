function test_polyhedron_52_pass
% all inputs should be converted from sparse to full (issues #134 and #135)

A = sparse([0 1; 1 0]);
b = sparse([0; 0]);
P = Polyhedron(A, b);
assert(~issparse(P.H));
assert(~issparse(P.He));
assert(~issparse(P.A));
assert(~issparse(P.b));
assert(~issparse(P.Ae));
assert(~issparse(P.be));

P = Polyhedron('A', A, 'b', b);
assert(~issparse(P.H));
assert(~issparse(P.He));
assert(~issparse(P.A));
assert(~issparse(P.b));
assert(~issparse(P.Ae));
assert(~issparse(P.be));

P = Polyhedron('H', [A, b]);
assert(~issparse(P.H));
assert(~issparse(P.He));
assert(~issparse(P.A));
assert(~issparse(P.b));
assert(~issparse(P.Ae));
assert(~issparse(P.be));

P = Polyhedron('H', [A, b], 'Ae', sparse([1 0]), 'be', sparse(0));
assert(~issparse(P.H));
assert(~issparse(P.He));
assert(~issparse(P.A));
assert(~issparse(P.b));
assert(~issparse(P.Ae));
assert(~issparse(P.be));

% from issue #135 (this used to fail)
P = Polyhedron('A',sparse([1 0;0 1]),'b',[1;1],'Ae',sparse([1 1]),'be',1)
assert(~issparse(P.H));
assert(~issparse(P.He));
assert(~issparse(P.A));
assert(~issparse(P.b));
assert(~issparse(P.Ae));
assert(~issparse(P.be));

end
