function test_polyhedron_affinemap_09_pass
%
% H,V-polyhedron, different methods
%

DIM = 3;

P(1) = Polyhedron(rand(5,DIM));
P(2) = Polyhedron('A',randn(8,DIM),'b',40*rand(8,1),'Ae',randn(1,DIM),'be',0);

% projection
A = randn(4,DIM);

Q1 = P.affineMap(A,'vrep');
Q2 = P.affineMap(A,'fourier');
Q3 = P.affineMap(A,'mplp');
Q4 = P.affineMap(A,'ifourier');

% make irrendundant
Q1.minHRep();
Q2.minHRep();
Q3.minHRep();
Q4.minHRep();

for i=1:2
    if ~(Q1(i)==Q2(i))
        error('Polyhedra Q1 and Q2 are not equal.');
    end    
    if ~(Q2(i)==Q3(i))
        error('Polyhedra Q2 and Q3 are not equal.');
    end
    if ~(Q1(i)==Q3(i))
        error('Polyhedra Q1 and Q3 are not equal.');
    end
    if ~(Q1(i)==Q4(i))
        error('Polyhedra Q1 and Q4 are not equal.');
    end
        
end


end
