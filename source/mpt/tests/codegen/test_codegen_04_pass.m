function test_codegen_04_pass
%
% 3D - example, reference on states and inputs
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
 model.x.min = [-5;-5;-5];
 model.x.max = [5;5;5];
 model.u.min = -3;
 model.u.max = 3;

model.x.penalty = QuadFunction(eye(3));
model.u.penalty = QuadFunction(1);
model.x.with('reference');
model.u.with('reference');
model.x.reference = [ -0.24; 0.43; 0.19];
model.u.reference = 0.5;
 
ctrl=MPCController(model,3);

c=ctrl.toExplicit;

% generate code using new name and new directory
p=pwd;
d = fileparts(which(mfilename));
name = 'generated_code_test_04';
cd(d);
c.exportToC([],name)

% compile the files in the directory
cd(name);
mex('mpt_getInput_sfunc.c');

% run the simulation
sim('test_codegen_sim_04');

% go back to original directory
cd(p);

% delete the created directory
onCleanup(@()cleanfiles(d,name));

% compare the results
for i=1:size(x,1)
    if norm(u(i)-c.evaluate(x(i,:)','x.reference',model.x.reference,'u.reference',model.u.reference),Inf)>1e-4
        error('The results do not match! Problem with exported C-code.');
    end
end
    


end

function cleanfiles(d,name)


clear('functions');
rmdir([d,filesep,name],'s');

end

