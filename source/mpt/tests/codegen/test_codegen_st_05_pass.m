function test_codegen_st_05_pass
% code generation of a binary search tree for a hybrid model, using a free
% reference 

% hybrid PWA model with 2 modes
mode1 = LTISystem('A', [ 0.4 0.69; -0.69 0.4], 'B', [0;1], 'C', [1, 0]);
mode1.setDomain('x', Polyhedron('A', [1 0], 'b', 0) );
mode2 = LTISystem('A', [ 0.4 -0.69; 0.69 0.4], 'B', [0;1], 'C', [1, 0]);
mode2.setDomain('x', Polyhedron('A', [-1 0], 'b', 0) );
model = PWASystem([mode1, mode2]);

% input and output constraints
model.u.min = -3;
model.u.max = 3;
model.y.min = -10;
model.y.max = 10;

% The objective is to track the time varying output while satisfying the
% constraints. To incorporate a time varying signal one needs to active the
% appropriate reference filter and mark it as "free"  
model.y.with('reference');
model.y.reference = 'free';

% objective function is to penalize ||y-ref||_1 + ||u||_1
model.y.penalty = OneNormFunction( 3 );
model.u.penalty = OneNormFunction( 0.5 );

% online controller with the horizon 3
ctrl = MPCController(model, 3);

% explicit controller
ectrl = ctrl.toExplicit();

% remove overlaps
ectrl.optimizer = ectrl.optimizer.min('obj');

% construct the binary tree
ectrl.binaryTree;

% export explicit controller to C
dir_name = 'rtw_explicitMPCtracking';
ectrl.exportToC('EMPCcontroller',dir_name);

% compile the files in the directory
p = pwd;
cd(dir_name);

% compile the S-function
mex('EMPCcontroller_sfunc.c');

assignin('caller','N',ctrl.N);
assignin('caller','model',model);
assignin('caller','x0',[0;0]);
sim('test_codegen_sim_05')

% go back to original directory
cd(p);

% delete the created directory
onCleanup(@()clear('functions'));
onCleanup(@()rmdir(dir_name,'s'));

% compare the results
for i=1:size(x,1)
    if norm(u(i)-ectrl.evaluate(x(i,1:2)','y.reference',x(i,3)),Inf)>1e-4
        error('The results do not match! Problem with exported C-code.');
    end
end


end