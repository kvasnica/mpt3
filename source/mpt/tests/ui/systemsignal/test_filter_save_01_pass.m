function test_filter_save_01_pass
% transient filters must not be save, hence no warning should be given on
% load

% always delete the temporary mat file upon exit
cleanup = onCleanup(@() system('rm test_save.mat'));

s = SystemSignal(1);
s.setKind('u');

% no "initial value" filter by default
assert(~s.hasFilter('previous'));

s.with('previous');
assert(s.hasFilter('previous'));
save test_save s

% the filter should not be there after loading
clear s
load test_save
assert(~s.hasFilter('previous'));

% the deltaPenalty filter automatically adds the "initial" filter
s.with('deltaPenalty');
assert(s.hasFilter('previous'));

% but loading should not complain about adding "initial" twice
save test_save s
clear s
load test_save
% and the "initial" filter must be there since "deltaPenalty" was loaded
assert(s.hasFilter('previous'));

end
