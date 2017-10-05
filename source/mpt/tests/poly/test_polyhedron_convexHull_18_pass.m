function test_polyhedron_convexHull_18_pass
%
% 
% too many inequalities (200), compare with mpt-2.6
% 

global MPTOPTIONS
if isempty(MPTOPTIONS)
   MPTOPTIONS = mptopt;
end

H = [randn(200,2) 500*rand(200,1)];

P = Polyhedron('H',H);

P.minHRep();

% mpt2.6
R = polytope(H(:,1:2),H(:,end));
Ht = double(R);

% normalize the representation
H1=diag(1./P.H(:,end))*P.H;
H2=diag(1./Ht(:,end))*Ht;

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
    error('Wrong redundancy elimination!');
end

end
