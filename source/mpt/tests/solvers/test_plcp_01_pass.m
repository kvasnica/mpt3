function test_plcp_01_pass
%  simple mpQP example from my dissertation thesis

%% input data
% w-M*z = q + Q*th
M = [2 -1 -1 1;
    1 0 0 0;
    1 0 0 0;
    -1 0 0 0];
q = [-2;-0.8;-0.6;2];
Q = [0 0; -1 1; 0.5 -1; 0 0];

% add bounds on theta  0 <= th <= 1
Ath = [eye(2);-eye(2)];
bth = [ones(2,1);zeros(2,1)];

% define problem
problem = Opt('M',M,'q',q,'Q',Q,'Ath',Ath,'bth',bth);
% solve
res = problem.solve;

if res.xopt.Num~=3
    error('Wrong number of regions!');
end

% correct regions
P(1) = Polyhedron('H',[1.0  -1.0  0.2;
       -0.5   1.0   0.4;
        1.0    0    1.0;
       -1.0    0      0;
         0   -1.0     0]);
P(2) = Polyhedron('H',[1.0   -2.0  -0.8;
        1.0    0    1.0;
         0    1.0   1.0;
       -1.0    0     0]);
P(3) = Polyhedron('H',[-2.0   2.0  -0.4;
         1.0    0    1.0;
         0   -1.0     0]);

% compare each region with each
for i=1:3
    v = false(1,3);
    for j=1:3
        v(j) = (res.xopt.Set(i)==P(j));
    end
    % only one region must me active 
    if nnz(v)~=1
        error('Regions of the computed solution do not match.');
    end
end

