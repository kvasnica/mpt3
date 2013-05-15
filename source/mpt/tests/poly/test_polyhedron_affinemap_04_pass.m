function test_polyhedron_affinemap_04_pass
%
% simple 2D polyhedron, V-rep
%

V = [-0.5632    0.8143
   -1.7555    0.3249
   -0.5288    1.8295
   -0.3085    1.1481
   -0.7776    0.2699
   -0.5533   -1.2722
   -0.9546   -1.6123
   -0.4638    0.2900
   -0.3481   -0.9813
    0.6163   -1.3337];
P = Polyhedron('V',V);

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
    if ~R.contains(y2(i,:))
        error('Point outside of the affine map.');
    end
end


% lifting
U = randn(3,2);
L = P.affineMap(U);
y3 = zeros(size(x,1),3);
for i=1:size(x,1)
    y3(i,:) = transpose(U*x(i,:)');
    if ~L.contains(y3(i,:))
        error('Point outside of the affine map.');
    end
end



end