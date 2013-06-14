function test_convexset_distance_03_pass
%
% distance from inside a circle

global MPTOPTIONS

if isempty(MPTOPTIONS)
    MPTOPTIONS = mptopt;
end

x = sdpvar(2,1);
S = YSet(x, norm(0.1*x)<=1, sdpsettings('solver','sedumi','verbose',0));

x = [4;3];
d = S.distance(x);

% if the point lies inside the set, the diffence between x,y is zero
% tolerances are reduced because sedumi works above MPTOPTIONS.rel_tol
if norm(d.dist,1)>1e-3
    error('Distance should be zero here.');
end
if norm(d.x-d.y,1)>1e-3
    error('Points should be the same.');
end

end
