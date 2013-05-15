function test_polyhedron_shoot_08_pass
%
% unbounded 
%
global MPTOPTIONS
 
P = Polyhedron('lb',[0;0;0]);

% the max is inf in positive orthant
r = P.shoot(rand(3,1));

% if r.exitflag~=MPTOPTIONS.UNBOUNDED
%     error('Must be unbounded handle here.');
% end
if ~isinf(r.alpha)
    error('Wrong alpha.');
end


% the max is 0 in negative direction
rn = P.shoot(-rand(3,1));

if rn.exitflag~=MPTOPTIONS.OK
    error('Must be ok handle here.');
end
if norm(rn.alpha)>1e-4
    error('Wrong alpha.');
end


end