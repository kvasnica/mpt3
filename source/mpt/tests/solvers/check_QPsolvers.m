% if the tests for solvers are called without arguments, this script
% ensures that all installed solvers are called and an error message is
% rethrown with a list of failed solvers

global MPTOPTIONS
if nargin==0    
    s = '';
    for i=1:numel(MPTOPTIONS.solvers_list.QP)
        [worked, msg] = run_in_caller(sprintf('%s(MPTOPTIONS.solvers_list.QP{i},1e-4);',fname));
        if ~worked
            s = [s,' ',MPTOPTIONS.solvers_list.QP{i}];
        end
    end
    if ~isempty(s)
       error('Solvers "%s" failed to give correct result.\n',s); 
    end
    break
end
