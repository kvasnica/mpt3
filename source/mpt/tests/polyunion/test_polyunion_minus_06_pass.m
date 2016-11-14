function test_polyunion_minus_06_pass
%
% convex, bounded, non-overlapping union - low-dim polyhedron
%

P = 10*ExamplePoly.randVrep;

T = P.triangulate;


U = PolyUnion('Set',T,'Convex',true,'Bounded',true,'FullDim',true,'Overlaps',false);

W = Polyhedron('lb',[-1;0],'ub',[1;0]);

H=P-W;
Un = U-W;

for i=Un.Num
   if ~H.contains(Un.Set(i))
       error('This set must be contained inside H');
   end
end


end