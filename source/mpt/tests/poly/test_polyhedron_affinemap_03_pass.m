function test_polyhedron_affinemap_03_pass
%
% simple 2D polyhedron, one equality
%

H = [0.1789   -1.1763    4.8132
    1.0251   -0.6498    2.2458
    1.1897    0.3015    4.6703
    0.5952    1.1159    2.6358
    0.0709    0.6233    3.4779
   -1.5760    0.5748    0.4231
   -0.2304   -0.3883    1.4891
   -1.8114    0.5960    4.4995
    1.3029   -0.1456    4.3425
   -0.3473   -0.5092    0.8969];
P = Polyhedron('H',H,'He',[-0.4 1 0]);

% projection
A = randn(1,2);
Q = P.affineMap(A);

% test the map via gridding
x = P.grid(30);

y1 = zeros(size(x,1),1);
for i=1:size(x,1)
    y1(i,:) = transpose(A*x(i,:)');
    if ~Q.contains(y1(i,:))
        error('Point outside of the affine map.');
    end
end

% rotation
T = randn(2);
R = P.affineMap(T);
y2 = zeros(size(x));
for i=1:size(x,1)
    y2(i,:) = transpose(T*x(i,:)');
    if ~R.contains(y2(i,:)')
        error('Point outside of the affine map.');
    end
end


% lifting
U = randn(3,2);
L = P.affineMap(U);
y3 = zeros(size(x,1),3);
for i=1:size(x,1)
    y3(i,:) = transpose(U*x(i,:)');
    if ~L.contains(y3(i,:)')
        error('Point outside of the affine map.');
    end
end



end
