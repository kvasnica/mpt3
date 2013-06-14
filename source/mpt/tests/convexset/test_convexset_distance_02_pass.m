function test_convexset_distance_02_pass
%
% distance from 2 sets

global MPTOPTIONS
if isempty(MPTOPTIONS)
    MPTOPTIONS=mptopt;
end

x = sdpvar(2,1);
S1 = YSet(x, [norm(x)<=1; randn(2)*x<=0.5*ones(2,1)], sdpsettings('solver','sedumi','verbose',0));

a = 5*rand(size(x,1),1);
S2 = YSet(x, norm(x-a)<=1, sdpsettings('solver','sedumi','verbose',0));

S=[S1,S2];

d = S.distance([5;-8]);
assert(isstruct(d));
assert(numel(d)==numel(S));

% reference distance
dr1 = norm([5;-8])-1;
dr2 = norm([5;-8]-a)-1;

% d{1} must be greater than dr1
if d(1).dist<dr1-MPTOPTIONS.abs_tol
    error('There should be distance greater than %f.',dr1);
end

if abs(d(2).dist-dr2)>MPTOPTIONS.abs_tol
    error('There should be distance %f.',dr2);
end

end
