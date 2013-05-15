function test_polyhedron_distance_06_pass
%
% 2P-S polytopes
%

P(1) = Polyhedron('H',[
      0.055388      -1.0081       6.3537
       1.2538      0.94428      0.47346
        -2.52       -2.424        4.823
      0.58486     -0.22383      0.40215]);
P(2) = Polyhedron([
      0.41537      0.43866
        0.305      0.49831
      0.87437      0.21396
     0.015009      0.64349
      0.76795      0.32004
      0.97084       0.9601
      0.99008      0.72663
      0.78886      0.41195]) + [0;3];
   
S = Polyhedron('lb',[-1;-1],'ub',[1;1]) + [-3;3];

d=P.distance(S);

% P1 & S intersect -> distance = 0
if norm(d{1}.dist)>1e-4
    error('Wrong distance.');
end

% P2 does not intersect, the distance must be greater than 2
if d{2}.dist<2
    error('Wrong distance.');
end

end