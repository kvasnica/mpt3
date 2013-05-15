function test_convexset_distance_01_pass
%
% distance from a circle

global MPTOPTIONS

if isempty(MPTOPTIONS)
    MPTOPTIONS = mptopt;
end

x = sdpvar(2,1);
S = YSet(x, set(norm(x-[5;4])<=1), sdpsettings('solver','sedumi','verbose',0));

d = S.distance([4;3]);

% reference distance
dr = norm([4;3]-[5;4],2)-1;


if abs(d.dist-dr)>MPTOPTIONS.abs_tol
    error('There should be distance %f.',dr);
end

end
