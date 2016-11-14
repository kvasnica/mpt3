function test_convexset_affinehull_03_pass
%
% empty affine hull
%

x = sdpvar(2,1);
S = YSet(x, norm(x)<=10,  sdpsettings('solver','sedumi','verbose',0)) ;

if ~isempty(S.affineHull)
    error('Should be empty.');
end

end
