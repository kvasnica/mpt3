function test_polyhedron_isneighbor_11_pass
%
%  full-dim and full-dim that share a common hyperplane, but are not
%  neighbors
%
 
P = Polyhedron('H',[  2.396196989874281   1.000000000000000   2.982430072506135
  -1.000000000000000  -1.582411278288845                   0
  -1.000000000000000   2.049356315589773   3.879795333447698]);

% first hyperplane is common
Q = Polyhedron('H',[2.396196989874281   1.000000000000000  -2.982430072506135
  -1.455299923984253  -1.000000000000000   2.627083536318854
  -1.000000000000000   1.670098447906721   3.474636449467853]);


if P.isNeighbor(Q) || Q.isNeighbor(P)
    error('Regions are not neighbors, see the plot.')
end

Q.computeVRep();
% shifting Q along the common facet such that there is a small overlap 
x =[P.H(3,1:end-1);null(P.H(3,1:end-1))']\[P.H(3,end);null(P.H(3,1:end-1))'*[-1.68;1.08]];

Qn = Polyhedron('V',[Q.V;x']);

if P.isNeighbor(Qn) || Qn.isNeighbor(P)
    error('Regions are not neighbors. See the plot.');
end


end
