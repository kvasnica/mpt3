function test_codegen_03_pass
%
% 3D - example, penalty on delta u and nonzero reference on output
% 


 A=[ -0.1768   -0.6291   -1.4286
   -2.1321   -1.2038   -0.0209
    1.1454   -0.2539   -0.5607];
 B=[1; 0; 1];
 C=[0 -1 1];
 D = 0;
 
 % continuous system
 csys = ss(A,B,C,D);

 % discrete system with low sampling time
 dsys = c2d(csys,0.1);

 model = LTISystem('A',dsys.A,'B',dsys.B,'C',dsys.C,'D',dsys.D, 'Ts',dsys.Ts);
 model.y.min = -5;
 model.y.max = 5;
 model.u.min = -3;
 model.u.max = 3;

% add delta u penalty
model.u.with('deltaPenalty');
model.u.deltaPenalty = Penalty(1,2);

% add penalty on y
model.y.penalty=Penalty(1,2);
model.y.with('reference');
model.y.reference = dsys.C*expm(eye(3)-dsys.A)*dsys.B;

ctrl=MPCController(model,4);

c=ctrl.toExplicit;

% generate code using new name and new directory
p=pwd;
d = fileparts(which(mfilename));
name = 'generated_code_test_03';
cd(d);
c.exportToC('codetest03',name)

% compile the files in the directory
cd(name);
mex('mpt_getInput_sfunc.c');

% run the simulation
sim('test_codegen_sim_03');

% go back to original directory
cd(p);

% delete the created directory
rmdir([d,filesep,name],'s');

% compare the results
for i=1:size(x,1)
    if norm(u(i)-c.evaluate(x(i,:)),Inf)>1e-4
        error('The results do not match! Problem with exported C-code.');
    end
end
    


end