function test_polyhedron_distance_07_pass
%
% lowdim, unbounded  polyhedron - lowdim
%

P(1) = Polyhedron('V',[0 0 0;
                       5 5 5;
                       5 -5 5;
                       5 5 -5;
                       5 -5 -5],...
                  'R',[1 0 0],...
                  'He',[0 -3 5 1]);

S = Polyhedron('lb',[-2;-2;-2],'ub',[-1;-1;-1],'He',[-3 2 0.5 0]);

d=P.distance(S);

if norm(d.dist-1.6079)>1e-4
    error('Wrong distance.');
end


end
