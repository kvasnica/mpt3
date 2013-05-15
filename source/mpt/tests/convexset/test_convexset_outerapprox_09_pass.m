function test_convexset_outerapprox_09_pass
%
% V-polyhedron, H-polyhedron, low-dim and unbounded in the array with
% different dimensions
%


P(1) = Polyhedron(randn(6));
P(2) = Polyhedron('A',randn(9,4),'b',2*rand(9,1));
P(3) = Polyhedron('A',randn(18,15),'b',2*randn(18,1),'He',randn(4,16));
P(4) = Polyhedron('A',randn(35,21),'b',rand(35,1));

tp = P.isBounded;

B = P.outerApprox;

% some polyhedra can be full R^n, we make sure this case does not come out
while any(B.isEmptySet)
    P(1) = Polyhedron(randn(6));
    P(2) = Polyhedron('A',randn(9,4),'b',2*rand(9,1));
    P(3) = Polyhedron('A',randn(18,15),'b',2*randn(18,1),'He',randn(4,16));
    P(4) = Polyhedron('A',randn(35,21),'b',rand(35,1));

    tp = P.isBounded;
    
    B = P.outerApprox;   
end

tb = B.isBounded;

if any(tb~=tp)
    error('Bounded and unbounded must remain the same');
end
  

end