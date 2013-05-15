function test_polyhedron_separate_05_pass
%
% unbounded, low-dim
%

P = Polyhedron('v',[
     0.35965     0.059723      0.57488
      -1.1539      0.27024      0.68568
      0.13597     -0.18149      0.52757
     -0.80206      -1.5974      -1.1638
      0.77163      0.95942      0.34132
     -0.76237      0.22399      0.43748
      -2.4817     -0.40216        1.247
       1.4056      -0.2492      -1.7003
       1.3551     -0.62835     0.048743
       1.4937       1.3784      0.83905],...
       'R',[-0.1629      -1.0737      -0.2257]);

Q = -P +[5;2;4];

h = P.separate(Q);

if isempty(h)
    error('There must be a separating hyperplane.');    
end

T = Polyhedron('He',h);
d1 = T.distance(P);
d2 = T.distance(Q);

if norm(d1.dist-d2.dist,Inf)>1e-4
    error('The distances should be equal.');
end


end