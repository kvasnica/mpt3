function test_yset_project_05_pass
%
% 3D test containment
%

x1 = sdpvar(1,1);x2 = sdpvar(1,1);x3 = sdpvar(1,1);
F = [4*x1-4*x2+4*x3-20+2*x2-2*x3+9+2*x3-13+24>=0,
     4-(x1+x2+x3)>=0,
     6-(3*x2+x3)>=0,
     2-x1>=0,
     3-x3>=0,
     x1>=0,
     x2>=0,
     x3>=0];
 
S = YSet([x1;x2;x3],F)  ;

s = S.project([0,0,4]);

% the closest point is [0,0,3]
if norm(s.x-[0;0;3],Inf)>1e-4
    error('Wrong point.');
end
if s.dist>1
    error('The distance should be one.');
end


end
