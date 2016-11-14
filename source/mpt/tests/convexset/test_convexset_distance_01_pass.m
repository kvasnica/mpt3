function test_convexset_distance_01_pass
%
% distance from a circle

x = sdpvar(2,1);
S = YSet(x, norm(x-[5;4])<=1, sdpsettings('solver','sedumi','verbose',0));

d = S.distance([4;3]);

% reference distance
dr = norm([4;3]-[5;4],2)-1;


if abs(d.dist-dr)>1e-6
    error('There should be distance %f.',dr);
end

end
