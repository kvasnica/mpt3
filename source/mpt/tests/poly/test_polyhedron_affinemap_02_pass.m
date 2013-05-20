function test_polyhedron_affinemap_02_pass
%
% simple 2D polyhedron
%

H=[ -0.2759    1.3876    1.0551
   -0.6624    0.4189    1.5908
   -0.5402    0.0820    1.7934
    0.2471   -1.2349    0.3150
   -0.4322    0.2821    0.5965
   -1.5355    0.2603    3.0817
   -0.6808   -1.6389    0.2550
    0.0004    0.4315    3.3799
    0.8611   -0.6789    3.7848
    0.1967    1.0213    2.4444
   -1.1424    0.9738    2.9685
    0.3474   -0.4185    0.1616
   -0.0274    0.0327    1.5004
    1.0183    0.3335    1.8844];
P = Polyhedron('H',H);

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
    if ~R.contains(y2(i,:)') % point must be a column vector
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
