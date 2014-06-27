function test_plcp_27_pass
% avoid throwing error when trying to scale matrix with zero column

load data_test_plcp_27.mat

worked=run_in_caller('mpt_mplp(Matrices)');

if ~worked
    error('The script should result in empty polytope.');
end


end
