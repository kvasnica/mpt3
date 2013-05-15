function test_convexset_separate_05_pass
%
% array of simple 2D sets
%

x = sdpvar(2,1);
F1 = set(0.1*x'*x <=  1) + set( 2*x(1)-0.5*x(2)<=0.5);
A = [   -0.33008   -0.0086331;
      0.75935     -0.61697];
F2 = set(x <=  1) + set( A*x<=[0.5;0.1]);
Y1 = YSet(x,F1);
Y2 = YSet(x,F2);
Y = [Y1; Y2];

v = 10*randn(2,1);

s = Y.separate(v);

d = distance(Y,v);

x1 = (v+d{1}.y)/2;
x2 = (v+d{2}.y)/2;

P1 = Polyhedron('He',s{1});
P2 = Polyhedron('He',s{2});

if ~P1.contains(x1)
    error('P1 must contain the point x1.');
end
if ~P2.contains(x2)
    error('P2 must contain the point x2.');
end


end
