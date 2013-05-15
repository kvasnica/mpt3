function test_union_add_02_fail
%
% add polyhedron with different function name
%

x = sdpvar(2,1);
A = [1 -0.2; 0.4 -1];
F = set(norm(A*x-[1;1])<2) + set( [1 -2]*x<0.4 );
G = set([1 -2]*x>0.4) + set(-1.5<x <1.5);

Y(1) = YSet(x,F).addFunction(AffFunction(2*eye(2),[1;-1]));
Y(2) = YSet(x,G).addFunction(AffFunction(3*eye(2),[-1;1]));

U = Union(Y);
P = Polyhedron('Ae',[0 1],'be',-1.5,'Func',AffFunction(4*eye(2),[1;1]),'FuncName','a');
U.add(P);

end