function test_yset_extreme_09_pass
%
% 3D test, x must be symmetric matrix array
%

P = sdpvar(2,2);

A = [-1 2;-3 -4];
F = [P>=eye(2), A'*P+P*A <= -eye(2)];

S1 = YSet(P(:),F);

S2 = YSet(P(:),P>=0);

S = [S1,S2];

% unbounded in positive direction
z = [4; 1; 1; 2];
s1 = S.extreme(z);

for i=1:2
    if ~isinf(s1(i).supp)
        error('Unbounded set in this direction.');
    end    
end

% negative direction
s2 = S.extreme(-z);
if norm(s2(1).x-[1;0;0;1])>1e-4
    error('Here must be unit matrix because AP+PA<-eye(2).');
end

if norm(s2(2).x-[0;0;0;0])>1e-4
    error('Here must be all zeros because P>0 .');
end


end
