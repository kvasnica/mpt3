function test_polyhedron_shoot_09_pass
%
% low-dim and unbounded 
%
global MPTOPTIONS
 
P = Polyhedron('lb',[0;0;0],'he',[1 -1 0.5 0]);
Q = Polyhedron(P);
Q.computeVRep();

% the max is inf in the ray
r = P.shoot(mean(Q.R));

% if r.exitflag~=MPTOPTIONS.UNBOUNDED
%     error('Must be unbounded handle here.');
% end
if ~isinf(r.alpha)
    error('Wrong alpha.');
end

% found a point inside P which is not far from origin
T = intersect(Q,Polyhedron('lb',[0;0;0],'ub',[2;2;2]));
xc = T.interiorPoint;

% shoot the opposite direction we should get a point that lies on the
% boundary
rn = P.shoot(-mean(Q.R),xc.x);

if rn.exitflag~=MPTOPTIONS.OK
    error('Must be ok handle here.');
end

if ~P.contains(rn.x)
    error('This point must lie inside the set.');
end





end
