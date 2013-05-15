function test_empcstcontroller_evaluate_04_pass
% test export to search tree
% NN15 example
%
A=[0,1,0;-79.285,-0.113,0;28.564,0.041,0];
B=[0,0;0.041,-0.0047;-0.03,-0.0016];
C=[0,0,1;1,0,0];

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

sysStruct.xmin = 2*[-1;-1;-1];
sysStruct.xmax = 2*[1;1;1];
sysStruct.umin = 5*[-1;-1];
sysStruct.umax = 5*[1;1];

% formulate problem
probStruct.norm = 1;
probStruct.N = 2;
probStruct.subopt_lev = 0;
probStruct.Q = eye(3);
probStruct.R = 0.5*eye(2);


% get matrices
model =mpt_import(sysStruct,probStruct);

% solve parametric problem
ectrl = EMPCController(model, 1);

% export to search tree
cst = ectrl.toSearchTree;

% evaluate using both methods and compare
X = grid(ectrl.optimizer.Internal.convexHull,10);

for i=1:size(X,1)
    f1 = ectrl.evaluate(X(i,:));
    f2 = cst.evaluate(X(i,:));
    if any(isnan(f2))
        error('Wrong region detection.');
    end
    
    if norm(f1-f2,Inf)>1e-5
        error('The evaluation does not hold.');
    end
    
end


end
