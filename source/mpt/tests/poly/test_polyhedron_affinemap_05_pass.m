function test_polyhedron_affinemap_05_pass
%
% simple 2D polyhedron, H-rep, unbounded
%

H = [0.4504    0.8838    4.9739
    0.2610    0.3689    1.5028
    0.3852    0.2475    3.5539
    0.4034    0.1049    2.4950
    0.2582    0.4038    3.1278
    0.2567    0.4170    3.5269
    0.0136    0.8659    4.1856
    0.5799    0.7424    2.2011
    0.2372    0.8618    2.4646
    0.9874    0.5881    4.3377];
P = Polyhedron('H',H);

% projection
A = [ -0.7244   -0.7984];
Q = P.affineMap(A);

% test the map via gridding of bounded subset
Pn = Polyhedron('H',P.H,'lb',[-10;-10],'ub',[10;10]);
x = Pn.grid(30);

y1 = zeros(size(x,1),1);
for i=1:size(x,1)
    y1(i,:) = transpose(A*x(i,:)');
    if ~Q.contains(y1(i,:))
        error('Point outside of the affine map.');
    end
end

% rotation
T =[1.7965    1.2662
    2.1864    1.2313];
R = P.affineMap(T);
y2 = zeros(size(x));
for i=1:size(x,1)
    y2(i,:) = transpose(T*x(i,:)');
    if ~R.contains(y2(i,:)')
        error('Point outside of the affine map.');
    end
end


% lifting
U = [2.1687    0.1603
    0.1346   -1.4966
   -2.7222   -1.4358];
L = P.affineMap(U);
y3 = zeros(size(x,1),3);
for i=1:size(x,1)
    y3(i,:) = transpose(U*x(i,:)');
    if ~L.contains(y3(i,:)')
        error('Point outside of the affine map.');
    end
end



end
