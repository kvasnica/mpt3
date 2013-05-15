function test_polyhedron_projection_11_pass
%
% must return the same representation on the output
%

P = Polyhedron('A', [1 0 0], 'b', 0);


q = P.projection(1:2);

if ~q.hasHRep
    error('Must return H-rep on the output.');
end

% check H
if size(q.H,1)~=1
    error('The size of H is wrong.');
end
if any(q.H~=[1 0 0])
    error('H-rep is wrong.');
end

% Because CDD computes wrong V-representation, the later piece of code is
% disabled.

% P.computeVRep();
% Q = Polyhedron('V', P.V,'R',P.R);
% 
% qn = Q.projection(1:2);
% 
% qn.minHRep();
% 
% if size(qn.H,1)>1
%     error('The output here must be [1 0 0].')
% end
% % check H
% if any(qn.H~=[1 0 0])
%     error('H-rep is wrong.');
% end


end
