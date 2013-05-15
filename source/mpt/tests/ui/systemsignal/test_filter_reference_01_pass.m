function test_filter_reference_01_pass

x = SystemSignal(2);
if ~x.hasFilter('reference')
	x.with('reference');
end

% correct number of rows
r = ones(x.n, 1);
x.reference = r;
assert(isequal(x.reference, r));

% incorrect number of rows
r = ones(x.n+1, 1);
[worked, msg] = run_in_caller('x.reference = r;');
assert(~worked);
assert(~isempty(strfind(msg, 'The refence must have 2 rows.')));

end
