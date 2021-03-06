function test_codegen_st_06_pass
%
% 2D - double integrator example, checking strings as directory/function
% names
% 

Double_Integrator;

model=mpt_import(sysStruct,probStruct);

ctrl=MPCController(model,3);

c=ctrl.toExplicit;
c.binaryTree;

% go to tests directory
p=pwd;
d = fileparts(which(mfilename));
cd(d);

% generate code using default name
c.exportToC('_a_b','my dir');

% clean files on exit
onCleanup(@()cleanfiles(p));

% enter the directory and compile the files
cd('my dir');
mex('_a_b_sfunc.c');
cd('..');


% short name of the function
[~,msg] = run_in_caller('c.exportToC(''a'',''my dir'')');
asserterrmsg(msg,'The name of the file must have more than 3 characters');

% wrong name of the function
[~,msg] = run_in_caller('c.exportToC('' my function'',''my dir'')');
asserterrmsg(msg,'The file name must contain only alphanumerical characters including underscore');

% wrong name of the function
[~,msg] = run_in_caller('c.exportToC(''meta@'',''my-dir'')');
asserterrmsg(msg,'The file name must contain only alphanumerical characters including underscore');

% accept any extension
c.exportToC('my_function.cc','dir/my-dir')
cd('dir/my-dir');
mex('my_function_sfunc.c');
cd('../..');

end

function cleanfiles(p)

clear('functions');
rmdir('my dir','s');
rmdir('dir','s');
cd(p);

end