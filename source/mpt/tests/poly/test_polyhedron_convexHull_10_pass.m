function test_polyhedron_convexHull_10_pass
%
% 
% R & V representation to convex hull
% 

global MPTOPTIONS
if isempty(MPTOPTIONS)
   MPTOPTIONS = mptopt;
end

H=[
    -0.44463      -1.0667     -0.23645      0.32706      0.23976     0.079934
     -0.15594      0.93373       2.0237       1.0826     -0.69036     -0.94848
      0.27607      0.35032      -2.2584       1.0061     -0.65155      0.41149
     -0.26116    -0.029006       2.2294     -0.65091       1.1921      0.67698
      0.44342      0.18245      0.33756      0.25706      -1.6118      0.85773
      0.39189      -1.5651       1.0001     -0.94438    -0.024462     -0.69116
      -1.2507    -0.084539      -1.6642      -1.3218      -1.9488      0.44938
     -0.94796       1.6039     -0.59003      0.92483       1.0205      0.10063
     -0.74111     0.098348     -0.27806   4.9849e-05      0.86172      0.82607
     -0.50782     0.041374      0.42272    -0.054919    0.0011621      0.53616
     -0.32058     -0.73417      -1.6702      0.91113    -0.070837      0.89789
     0.012469    -0.030814      0.47163      0.59458      -2.4863     -0.13194
      -3.0292      0.23235      -1.2128       0.3502      0.58117      -0.1472
     -0.45701      0.42639      0.06619       1.2503      -2.1924       1.0078
       1.2424     -0.37281      0.65236      0.92979      -2.3193      -2.1237];


% construct polyhedron
P1 =  Polyhedron('H',H);

% compute irredundant representation (also does H-to-V)
P1.minHRep();
   
% constract equivalent polyhedron
P2 = Polyhedron('R',P1.R,'V',P1.V);  

% compute convex hull
P2.minHRep();

% normalize the representation
H1=diag(1./P1.H(:,end))*P1.H;
H2=diag(1./P2.H(:,end))*P2.H;

% P1 and P2 must be equal
% compare H representation of both
if (size(H1,1) ~= size(H2,1)) || (size(H1,2) ~= size(H2,2))
    error('Wrong sizes.');
end

% rows may be reordered, compare each row individually
v = false(size(H1,1),1);
for i=1:size(H1,1)
    for j=1:size(H2,1)
        if norm(H1(i,:)-H2(j,:)) < MPTOPTIONS.abs_tol
            v(i) = true;
            break;
        end
    end
end


if ~all(v)
    error('Wrong computation V&R-rep -> H-rep!');
end
