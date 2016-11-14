function test_polyhedron_fplot_16_pass
%
% adding function handles should work

% function handles can be added even without converting them to Function
% object manually
P = Polyhedron('lb', 2*pi*[-1; -1], 'ub', 2*pi*[1; 1]);
P.addFunction(@(x) sin(x(1))+cos(x(2)), 'sin');
P.fplot();
close all

% first input to addFunction must not be a string
[worked, msg] = run_in_caller('P.addFunction(''sin2'', @(x) sin(x));');
assert(~worked);
assert(~isempty(strfind(msg, 'First input must be a function object.')));
