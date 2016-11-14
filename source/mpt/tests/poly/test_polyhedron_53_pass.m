function test_polyhedron_53_pass
% affine set 0*x=0 is not empty
% reported by Magnus Nilsson on Aug 18, 2016

P = Polyhedron('Ae',0,'be',0);
assert(P.Dim==1);
assert(isempty(P.He));
assert(~isempty(P.H));
assert(~P.isEmptySet());
assert(P.isFullDim());
assert(P.isFullSpace());

P = Polyhedron('Ae',[0 0],'be',0);
assert(P.Dim==2);
assert(isempty(P.He));
assert(~isempty(P.H));
assert(~P.isEmptySet());
assert(P.isFullDim());
assert(P.isFullSpace());

P = Polyhedron('Ae',[0 0; 0 0],'be', [0; 0]);
assert(P.Dim==2);
assert(isempty(P.He));
assert(~isempty(P.H));
assert(~P.isEmptySet());
assert(P.isFullDim());
assert(P.isFullSpace());

P = Polyhedron('Ae',[0 0; 0 0],'be', [0; 0], 'A', [0 0], 'b', 0);
assert(P.Dim==2);
assert(isempty(P.He));
assert(~isempty(P.H));
assert(~P.isEmptySet());
assert(P.isFullDim());
assert(P.isFullSpace());

P = Polyhedron('Ae',[0 0],'be', 0, 'A', [1 0], 'b', 1);
assert(isempty(P.He));
assert(~isempty(P.H));
assert(P.Dim==2);
assert(~P.isEmptySet());
assert(P.isFullDim());
assert(~P.isFullSpace());

end
