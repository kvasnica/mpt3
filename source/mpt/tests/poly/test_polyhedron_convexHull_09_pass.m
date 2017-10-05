function test_polyhedron_convexHull_09_pass
%
% 
% R representation to convex hull
% 

global MPTOPTIONS
if isempty(MPTOPTIONS)
    mptopt;
end

R = [0 0 0 -4;
    0 3 0 0;
    1 0 -1 0];
V = [1 1 0 1];

P = Polyhedron('R',R,'V',V);

P.minHRep();

HHe=[-1     0     0     0    -1;
     0    -1     0     0    -1;
     0     0     0     1     1;
      -1     0    -1     0    -1];

if norm([P.H;P.He]-HHe,1)>MPTOPTIONS.abs_tol
    error('Wrong computation R-rep -> H-rep!');
end

end
