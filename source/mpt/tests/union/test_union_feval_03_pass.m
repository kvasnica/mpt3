function test_union_feval_03_pass
%
% overlaps, two PWA functions over cirle+polyhedron
%

x = sdpvar(2,1);
A = [1 -0.2; 0.4 -1];
F = set(norm(A*x-[1;1])<=2) + set( [1 -2]*x<=0.4 );
G = set(-1.5<=x <=1.5);

Y(1) = YSet(x,F);
Y(1).addFunction(AffFunction(2*eye(2),[1;-1]),'a');
Y(1).addFunction(AffFunction(2*eye(2),[1;-1]),'b');
Y(2) = YSet(x,G);
Y(2).addFunction(AffFunction(3*eye(2),[-1;1]),'a');
Y(2).addFunction(AffFunction(3*eye(2),[-1;1]),'b');

U = Union(Y);
P = Polyhedron('Ae',[-1 1],'be',-1.5);
P.addFunction(AffFunction(4*eye(2),[1;1]), 'a');
P.addFunction(AffFunction(randn(2)), 'b');
U.add(P);

y1=U.feval([1;1]);
if ~iscell(y1)
    error('Here must be two values present.');
end
if ~iscell(y1{1}) || ~iscell(y1{2})
    error('The output is cell within a cell for two overlaps and two functions.');
end
if numel(y1{1})~=2 || numel(y1{2})~=2
    error('We are evaluating two functions over two overlapping polyhedra.');
end

y2=U.feval([3;1.5],'a');
if ~isnumeric(y2)
    error('Here must one value present because we are evaluating only one function.');
end

y4 = U.feval([0;0],'a');
if ~iscell(y4)
    error('The result must be a cell because two sets overlap here.');
end


end
