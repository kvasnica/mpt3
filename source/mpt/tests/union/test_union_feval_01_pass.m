function test_union_feval_01_pass
%
% PWA function over cirle+polyhedron
%

x = sdpvar(2,1);
A = [1 -0.2; 0.4 -1];
F = set(norm(A*x-[1;1])<=2) + set( [1 -2]*x<=0.4 );
G = set([1 -2]*x>=0.4) + set(-1.5<=x <=1.5);

Y(1) = YSet(x,F).addFunction(AffFunction(2*eye(2),[1;-1]), 'f');
Y(2) = YSet(x,G).addFunction(AffFunction(3*eye(2),[-1;1]), 'f');

U = Union(Y);
P = Polyhedron('Ae',[0 1],'be',-1.5);
P.addFunction(AffFunction(4*eye(2),[1;1]), 'f');
U.add(P);

y1=U.feval([1;1]);
assert(isequal(y1, [3; 1]));
y2=U.feval([1;-1]);
assert(isequal(y2, [2; -2]));

end
