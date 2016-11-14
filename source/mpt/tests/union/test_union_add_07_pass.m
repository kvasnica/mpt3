function test_union_add_07_pass
%
% add polyhedron with different function
%

x = sdpvar(2,1);
A = [1 -0.2; 0.4 -1];
F = [ norm(A*x-[1;1])<=2 ;  [1 -2]*x<=0.4 ];
G = [ [1 -2]*x>=0.4 ; -1.5 <= x <=1.5 ];

Y(1) = YSet(x,F).addFunction(AffFunction(2*eye(2),[1;-1]),'alpha'); 
Y(2) = YSet(x,G).addFunction(AffFunction(3*eye(2),[-1;1]),'alpha'); 
U = Union(Y);

P = Polyhedron('Ae',[0 1],'be',-1.5);
P.addFunction(AffFunction(4*eye(2),[1;1]),'beta');
[worked, msg] = run_in_caller('U.add(P); ');
assert(~worked);
asserterrmsg(msg,'The set 1 to be added holds different function names than the union.');

end