function test_convexset_addfunction_02_pass
%
% function name is required
%

P = Polyhedron;
[worked, msg] = run_in_caller('P.addFunction(Function(@(x) x))');
assert(~worked);
assert(~isempty(strfind(msg, 'Not enough input arguments.')));
