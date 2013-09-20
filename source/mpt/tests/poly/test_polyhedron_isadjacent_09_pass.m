function test_polyhedron_isadjacent_09_pass
%
% low-dimensional polyhedron with double-sided inequalities
%

V1 = [-1 0 0;
      0 1 0;
      0 0 1;
      0 -1 0;
      0 0 -1];

V2 = [0 0 0;
      0 1 0;
      0 0 1;
      0 -1 0;
      0 0 -1];
  
P = Polyhedron(V1);
Q = Polyhedron(V2);

% re-create the polyhedron Q with double-sided inequality
H = [Q.H;
     Q.He;
     -Q.He];
R = Polyhedron('H',H);

[ts, iP, iR] = P.isAdjacent(R);

if ~ts
    error('The polyhedra are adjacent.');
end
if numel(iR)<1
    error('The second polyhedron should return two indices because it contains double-sided inequalities.');
end


end