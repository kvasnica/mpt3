function test_polyhedron_shoot_06_pass
%
% [H,V]-boxes
%
global MPTOPTIONS
 
P(1) = Polyhedron('lb',[-1;-2;-3],'ub',[1;2;3]);
P(2) = Polyhedron('V',...
    [-10   -20    30
    10   -20    30
    10    20    30
   -10    20    30
    10    20   -30
   -10    20   -30
    10   -20   -30
   -10   -20   -30]);

% the max is 3,30
r = P.shoot([0 0 1]);

for i=1:2
    if r{i}.exitflag~=MPTOPTIONS.OK
        error('Must be ok handle here.');
    end
    if norm(r{1}.alpha-3)>1e-4
        error('Wrong alpha.');
    end
    if norm(r{2}.alpha-30)>1e-4
        error('Wrong alpha.');
    end    
end


end