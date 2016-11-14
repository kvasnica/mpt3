function test_polyunion_min_10_pass
% the output should not have overlaps
%

% all functions must be scalar-valued, see e7b230152242

% polyunion 1
V1 = [-1.7820    0.3957
    0.4419    0.6045
    1.0343    2.8523
   -0.0208   -1.0447
   -1.3607   -1.3944
   -0.6782   -2.0298];
V2 = [-0.9981   -1.8427
   -1.7229    0.0359
    2.5125    2.5916
   -1.1554    1.5497
    0.9190   -1.1936];
P(1) = Polyhedron(V1);
P(1).addFunction(AffFunction([1 0],1),'a');
P(2) = Polyhedron(V2);
P(2).addFunction(AffFunction(-2*[1 0],-1),'a');

% polyunion 2
V3 = [-0.6434   -0.5520
   -0.2542   -1.3354
    1.4528   -0.0155
    0.5056   -1.9508
   -0.8946    0.6901];
V4 = [ -0.4356    1.6444
    0.3869    1.1044
   -0.5726   -1.8167
    1.5000   -1.8399];
Q(1) = Polyhedron(V3);
Q(2) = Polyhedron(V4);
Q.addFunction(AffFunction(2*[1 0],-1),'a');
Q(1).addFunction(AffFunction([1 0],1),'a');
Q(1).addFunction(AffFunction(-2*[1 0],-1),'a');

% array of polyunions
U(1) = PolyUnion(P);
U(2) = PolyUnion(Q);

T=U.min;
assert(T.Num==22);

Unew = PolyUnion(T.Set);

% new polyunion should not have overlaps as indicated in T
assert(Unew.isOverlapping==0)


end
