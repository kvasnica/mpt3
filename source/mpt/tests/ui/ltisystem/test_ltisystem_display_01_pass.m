function test_ltisystem_display_01_pass
% tests AbstractSystem/display

L = LTISystem;
msg = strtrim(evalc('L'));
assert(isequal(msg, 'Empty LTISystem'));

L = LTISystem;
msg = strtrim(evalc('[L L]'));
assert(isequal(msg, 'Array of 2 LTISystems'));

L = LTISystem('A', 1);
msg = strtrim(evalc('L'));
assert(isequal(msg, 'LTISystem with 1 state, 0 inputs, 0 outputs'));

L = LTISystem('A', 1, 'B', 1);
msg = strtrim(evalc('L'));
assert(isequal(msg, 'LTISystem with 1 state, 1 input, 0 outputs'));

L = LTISystem('A', 1, 'B', [1 1]);
msg = strtrim(evalc('L'));
assert(isequal(msg, 'LTISystem with 1 state, 2 inputs, 0 outputs'));

L = LTISystem('A', 1, 'B', [1 1], 'C', 1);
msg = strtrim(evalc('L'));
assert(isequal(msg, 'LTISystem with 1 state, 2 inputs, 1 output'));

L = LTISystem('A', 1, 'B', [1 1], 'C', [1; 1; 1]);
msg = strtrim(evalc('L'));
assert(isequal(msg, 'LTISystem with 1 state, 2 inputs, 3 outputs'));

L = LTISystem('A', [1 1; 0 1], 'B', [1; 0.5], 'C', randn(4, 2));
msg = strtrim(evalc('L'));
assert(isequal(msg, 'LTISystem with 2 states, 1 input, 4 outputs'));

end
