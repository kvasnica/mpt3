function test_yset_contains_01_pass
%
% simple 1D test containment
%


x = sdpvar(1);

F = set( norm(x) <= 1);

S = YSet(x,F);

if S.contains(2)
    error('The point must be outside of the set.');
end
if ~S.contains(1)
    error('The point must be inside of the set.');
end


end
