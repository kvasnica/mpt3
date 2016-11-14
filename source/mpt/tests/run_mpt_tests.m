% RUN_MPT_TESTS - a script for executing all tests in MPT toolbox

% initialize and add paths
mpt_init

% test solvers
run_lp_tests
run_qp_tests
run_milp_tests

% test parametric solver
run_plcp_tests

% test MPC data
test_qp_MPC

% other tests to be added here...
run_polyhedron_tests
run_opt_tests
run_function_tests
run_convexset_tests
run_yset_tests
run_union_tests
run_polyunion_tests

% benchmarking PLCP against MPLP
run_mplp_tests 
% benchmarking PLCP against MPQP
run_mpqp_tests 

% user interface & compatibility
run_all_mpt_tests('ui', 'compatibility');

