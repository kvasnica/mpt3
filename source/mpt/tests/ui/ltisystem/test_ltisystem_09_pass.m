function test_ltisystem_09_pass
% tests that we reject affine terms in certain functions

L{1} = LTISystem('A', 1, 'B', 1, 'C', 1, 'D', 0, 'f', 1);
L{2} = LTISystem('A', 1, 'B', 1, 'C', 1, 'D', 0, 'g', 1);
L{3} = LTISystem('A', 1, 'B', 1, 'C', 1, 'D', 0, 'f', 1, 'g', 1);

for i = 1:length(L)
	[worked, msg] = run_in_caller('L{i}.toSS');
	assert(~worked);
	assert(~isempty(findstr(msg, 'System has affine terms, cannot convert to SS.')));
end

for i = 1:length(L)
	[worked, msg] = run_in_caller('L{i}.LQRGain');
	assert(~worked);
	assert(~isempty(findstr(msg, 'This function does not support affine systems.')));
end

for i = 1:length(L)
	[worked, msg] = run_in_caller('L{i}.LQRPenalty');
	assert(~worked);
	assert(~isempty(findstr(msg, 'This function does not support affine systems.')));
end

for i = 1:length(L)
	[worked, msg] = run_in_caller('L{i}.LQRSet');
	assert(~worked);
	assert(~isempty(findstr(msg, 'This function does not support affine systems.')));
end

end
