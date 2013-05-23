function test_empcstcontroller_evaluate_03_pass
% test export to search tree
% NN8 example
%

A=[-0.2 0.1 1;-0.05 0 0;0 0 -1];
B=[0 1; 0 0.7;1 0];
C=[1 0 0; 0 1 0];
D = zeros(2);

% continuous system
csys = ss(A,B,C,D);

% discrete system with low sampling time
dsys = c2d(csys,0.1);

% extract data for MPT
sysStruct.A = dsys.A;
sysStruct.B = dsys.B;
sysStruct.C = dsys.C;
sysStruct.D = dsys.D;
sysStruct.Ts = 0.1;
sysStruct.xmin = [-1;-1;-1];
sysStruct.xmax = [1;1;1];
sysStruct.umin = 3*[-1;-1];
sysStruct.umax = 3*[1;1];

% formulate problem
probStruct.norm = Inf;
probStruct.N = 2;
probStruct.subopt_lev = 0;
probStruct.Q = eye(3);
probStruct.R = 0.5*eye(2);

% get matrices
model =mpt_import(sysStruct,probStruct);

% solve parametric problem
ectrl = EMPCController(model, 2);

% export to search tree
cst = ectrl.toSearchTree;

% evaluate using both methods and compare
X = grid(ectrl.optimizer.Internal.convexHull,10);

for i=1:size(X,1)
    f1 = ectrl.evaluate(X(i,:)');
    f2 = cst.evaluate(X(i,:)');
    if any(isnan(f2))
        error('Wrong region detection.');
    end
    
    if norm(f1-f2,Inf)>1e-5
        error('The evaluation does not hold.');
    end
    
end


end
