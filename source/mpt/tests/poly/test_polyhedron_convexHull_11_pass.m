function test_polyhedron_convexHull_11_pass
%
% 
% random V representation to convex hull
% 

global MPTOPTIONS
if isempty(MPTOPTIONS)
   MPTOPTIONS = mptopt;
end

H= randn(15,3);

% construct polyhedron
P1 =  Polyhedron('H',H);

while P1.isEmptySet
    H= randn(15,3);
    
    % construct polyhedron
    P1 =  Polyhedron('H',H);    
end


% compute V&R representation
P1.computeVRep();

% construct equivalent polyhedron
P2 = Polyhedron('R',P1.R,'V',P1.V);  

% compute irredundant representation
P1.minHRep();

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
        if norm(H1(i,:)-H2(j,:)) < MPTOPTIONS.rel_tol
            v(i) = true;
            break;
        end
    end
end


if ~all(v)
    error('Wrong computation V&R-rep -> H-rep!');
end

end
