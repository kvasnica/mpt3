function test_polyhedron_affinemap_07_pass
%
% polyhedron array, rotation
%

H1 = [    0.0040    0.6770    0.0011    6.9769
    0.2678    0.1410    0.9380    5.5933
    0.5413    0.3744    0.7206    7.8710
    0.2556    0.6011    0.5058    1.6115
    0.6500    0.0760    0.9107    1.3672
    0.1782    0.8203    0.2084    5.0227
    0.6934    0.9049    0.4627    7.9429
    0.4850    0.6197    0.4887    1.9743
    0.6224    0.8137    0.2166    5.3826
    0.5403    0.2818    0.5404    7.5859];
H2 = [  -1.5878    0.3502   -2.2976    3.2362
   -0.2985    0.6029    0.8741    0.8659
    0.0363    0.0890    1.0125    0.8582
    0.6714    0.0525   -2.2454    2.4823
    0.3617   -1.1027   -1.6147    0.2938
    2.2251    0.8254   -0.6102    1.9916
    0.4595    1.9299   -0.9518    0.3888
   -0.7500    0.2185   -0.5789    0.6747
    0.8730   -1.5089    0.6208    0.7703
   -0.6498   -0.9053    0.0397    2.7763
   -0.4223   -0.9597   -0.3841    2.5944
   -1.6458   -0.3264   -0.1755    0.9518
    1.3260   -3.2605    0.4232    3.7305
   -0.1650    0.3190   -1.5456    2.0311
   -0.5145   -0.5571   -1.4422    0.4568
    1.2816   -0.5495   -0.7372    3.7510
   -0.4874   -0.8869    0.0321    2.5507
   -0.5998   -0.5434    0.6870    1.7720];
He2 = [ 0.1097   -1.5085    0.8889         0
    0.2675   -0.9538    0.1661    0.1000];
V = [   -4.1333   38.0890    3.8105
    3.9655    2.2763  -21.4497
  -11.7525   15.9570   20.7921
  -14.8702   17.7978    6.8364
   13.6040   -1.1048   20.1072
  -13.0073   -4.2336    0.3662
    5.4841    1.8914    9.3215
   -7.3614    8.9188  -11.7710
  -12.5798   10.8963  -14.3157
    7.1712   19.2691   17.9142
    2.2936  -16.6134    7.4747
    7.3681  -16.4359   -1.2250
  -15.4056    8.8708   19.7616
   -0.7613   13.4343  -11.6484];

% first polyhedron is unbounded, and its projection can be the whole space
P(1) = Polyhedron('H',H1);
P(2) = Polyhedron('H',H2,'He',He2);
P(3) = Polyhedron(V);

% rotation/skew
A = [0.3713    0.1796    0.6862
    0.5232    0.8060    0.9016
    0.7673    0.0749    0.1670];
Q = P.affineMap(A);

if any(Q.isEmptySet)
    error('Any of Q should not be empty.');
end

for i=1:3
    % test the map via gridding of bounded subset
    if ~isBounded(P(i))
        Pn = intersect(P(i),Polyhedron('lb',-10*ones(3,1),'ub',10*ones(3,1)));
    else
        Pn = P(i);
    end
    x = Pn.grid(10);
    
    y = zeros(size(x,1),3);
    for j=1:size(x,1)
        y(j,:) = transpose(A*x(j,:)');
        if ~Q(i).contains(y(j,:))
            error('Point outside of the affine map.');
        end
    end
end



end