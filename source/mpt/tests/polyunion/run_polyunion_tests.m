function run_polyunion_tests
%
% run test for poluunion class
%

flag = false;

% find directory
d=which('run_polyunion_tests');
id = strfind(d, filesep);
d = d(1:id(end));

% execute testing files in this directory
disp('-------------------------------------------------------------------')
p = dir([d,'test_polyunion*pass.m']);
disp(' ');
disp('Pass tests:');
disp(' ');
for j=1:numel(p)
    try
        eval(strtok(p(j).name,'.'));
        disp([p(j).name,repmat('.',1,50-length(p(j).name)),' ok']);
    catch
        flag = true;
        disp([p(j).name,repmat('.',1,50-length(p(j).name)),' error']);
    end
end
p = dir([d,'test_polyunion*fail.m']);
disp(' ');  
disp('Fail tests:');
disp(' ');
for j=1:numel(p)
    try
        eval(strtok(p(j).name,'.'));
        disp([p(j).name,repmat('.',1,50-length(p(j).name)),' error']);
        flag = true;
    catch
        disp([p(j).name,repmat('.',1,50-length(p(j).name)),' ok']);
    end
end
disp('  ');
disp('-------------------------------------------------------------------')
if flag
   warning('PolyUnion tests failed.'); 
end
