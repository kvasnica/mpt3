function test_polyhedron_isadjacent_14_pass
%
%  full-dim and low-dim that are adjacent
%
 
P = Polyhedron('H',[  2.396196989874281   1.000000000000000   2.982430072506135
  -1.000000000000000  -1.582411278288845                   0
  -1.000000000000000   2.049356315589773   3.879795333447698]);

% second facet is common
Q = Polyhedron('H',[1.000000000000000   -2.049356315589801   -3.879795333447730
   2.425218492765055   1.000000000000000  -2.993390560003705
  -1.455299923984409  -1.000000000000000   2.627083536318815]);


if ~P.isAdjacent(Q) || ~Q.isAdjacent(P)
    error('Regions are adjacent. See the plot.');
end


end