function test_polyhedron_contains_05_pass
%
% V-H in 4D 
%

% P must contain origin, otherwise the scaling does not hold
P1 = ExamplePoly.randVrep('d',4);
while ~P1.contains([0;0;0;0])
    P1 = ExamplePoly.randVrep('d',4);
end

R1 = P1*0.9999;
R1.computeVRep();

S1 = Polyhedron('H',R1.H);
  
if ~P1.contains(S1)
    error('P must contain S.');
end


P2 = 10*ExamplePoly.randVrep('d',4);
while ~P2.contains([0;0;0;0])
    P2 = 10*ExamplePoly.randVrep('d',4);
end

R2 = P2*0.9999;
R2.computeHRep();

S2 = Polyhedron('H',R2.H);
  
if ~P2.contains(S2)
    error('P must contain S.');
end

P3 = 100*ExamplePoly.randVrep('d',4);
while ~P3.contains([0;0;0;0])
    P3 = 100*ExamplePoly.randVrep('d',4);
end

R3 = P3*0.9999;
R3.computeHRep();

S3 = Polyhedron('H',R3.H);
  
if ~P3.contains(S3)
    error('P must contain S.');
end

P4 = 1000*ExamplePoly.randVrep('d',4);
while ~P4.contains([0;0;0;0])
    P4 = 1000*ExamplePoly.randVrep('d',4);
end


R4 = P4*0.9999;
R4.computeHRep();

S4 = Polyhedron('H',R4.H);
  
if ~P4.contains(S4)
    error('P must contain S.');
end


end
