function plotPlanes(P,scl)

clf; hold on;

P.minHRep();
P.minVRep();

H = P.H;
for i=1:size(H,1)
  Polyhedron('lb',-ones(P.Dim,1)*scl,'ub',ones(P.Dim,1)*scl,'He',H(i,:)).plot('alpha',0.1,'color','b');
end

pplot(P.V,'bo');
