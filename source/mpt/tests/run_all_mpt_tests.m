function run_all_mpt_tests(varargin)
% Runs tests in subdirectories.
%
% NOTE: only tests matching "test_*.m" are considered.
%
% To run all tests
%   run_all_mpt_tests
%
% To run only tests in selected directories and below:
%   run_all_mpt_tests ui polyhedron
%
% To run tests in "ui" (and below), but not in "ltisystem":
%   run_all_mpt_tests ui -ltisystem
%
% To run only tests whose names begin with "test_polyhedron_eq":
%   run_all_mpt_tests test_polyhedron_eq
%
% To run all polyunion tests sans those starting with "test_polyunion_m"
%   run_all_mpt_tests polyunion -test_polyunion_m
%
% To run tests in "ui", but not those in "empccontroller" and not those
% starting with "test_ltisystem_r" and "test_pwasystem_up"
%   run_all_mpt_tests ui -empccontroller -test_ltisystem_r -test_pwasystem_up
%
% To re-run tests which failed in the previous run:
%   run_all_mpt_tests --rerunfailed
%
% To display only failed tests:
%   run_all_mpt_tests --onlyerrors
%
% To skip running the files, only display:
%   run_all_mpt_tests --dryrun
%
% Note that each test is execute by evalc(), therefore you won't see any
% test output being printed to the screen.

persistent test_files

cwd = pwd;
cleanup = onCleanup(@()cd(cwd));

maindir = fileparts(which(mfilename));

% determine options
options = struct('onlyerrors', false, ...
	'rerunfailed', false, ...
	'dryrun', false);
name_filters = {};
dir_filters = {};
for i = 1:length(varargin)
	if ischar(varargin{i}) 
		if ~(varargin{i}(1)=='-' || varargin{i}(1)=='+')
			% treat all uprefixed filters as plus-filters
			varargin{i} = ['+' varargin{i}];
		end
		if isequal(varargin{i}(1:2), '--')
			options.(varargin{i}(3:end)) = true;
		elseif length(varargin{i})>length('test_')+1 && ...
				isequal(varargin{i}(2:6), 'test_')
			name_filters{end+1} = varargin{i};
		else
			dir_filters{end+1} = varargin{i};
		end
	end
end

if ~options.rerunfailed
	% determine list of tests to run
	test_files = get_test_files(maindir, dir_filters, name_filters);
end

% execute individual tests
start_time = clock;
with_error = false(1, length(test_files));
with_warning = false(1, length(test_files));
previous_dir = '';
runtime = 0;
first = true;
dir_runtime = 0;
dir_mode = false;
for i = 1:length(test_files)
	this_dir = fileparts(test_files{i});
	
	% show a delimiter for each test directory
	if ~options.rerunfailed && ~isequal(this_dir, previous_dir)
		% display runtime of the previous directory
		if ~first,
			fprintf('\n--- Completed in %.1f secs ---\n', dir_runtime);
		end
		dir_runtime = 0;
		first = false;
		dir_mode = true;

		previous_dir = this_dir;
		shortdirname = this_dir(length(maindir)+2:end);
		%fprintf('\n%s\n', repmat('-', 1, 60));
		fprintf('\n=== Tests for %s ===\n\n', shortdirname);
	end
	[status, et] = run_test(test_files{i}, options);
	runtime = runtime + et;
	dir_runtime = dir_runtime + et;
	switch status
		case 'error',
			with_error(i) = true;
		case 'warning',
			with_warning(i) = true;
	end
end
if dir_mode
	if ~first,
		fprintf('\n--- Completed in %.1f secs ---\n', dir_runtime);
	end
end

% display results
n_error = length(find(with_error));
n_warning = length(find(with_warning));
if n_error>0 && ~options.rerunfailed
	failed = test_files(with_error);
	fprintf('\n%s\n', repmat('=', 1, 60));
	fprintf('Failed tests:\n\n');
	for i = 1:length(failed)
		[~, testname] = fileparts(failed{i});
		if usejava('desktop')
			fprintf('%s (<a href="matlab:opentoline(''%s'', 1, 0)">edit</a>)\n', ...
				testname, [failed{i} '.m']);
		else
			fprintf('%s\n', testname);
		end
	end
	fprintf('%s\n', repmat('=', 1, 60));
end

fprintf('\n');
fprintf('   Total: %d\n', length(test_files));
fprintf('  Failed: %d', n_error);
if n_error>0 && usejava('desktop')
	% show a link to re-run all failed tests (only when running a
	% java-enabled matlab)
	fprintf(' (<a href="matlab: eval(''run_all_mpt_tests --rerunfailed'')">re-run all failed</a>)');
end
fprintf('\n');
fprintf('Warnings: %d\n', n_warning);
fprintf(' Runtime: %.1f seconds\n\n', runtime);

% store the list of failed tests for re-run
test_files = test_files(with_error);

end

%--------------------------------
function subdirs = dirlist(name, subdirs)
% recursive list of directories

if nargin < 2
	subdirs = {};
end
d = dir(name);
for i = 1:length(d)
	if isequal(d(i).name, '.') || isequal(d(i).name, '..')
		continue
	elseif d(i).isdir
		fulldir = [name filesep d(i).name];
		subdirs{end+1} = fulldir;
		subdirs = dirlist(fulldir, subdirs);
	end
end

end

%-------------------------------
function [outcome, runtime] = run_test(testfile, options)
% executes a single test
%

outcome = 'ok';
runtime = 0;
cwd = pwd;
[testpath, testname] = fileparts(testfile);
cd(testpath);
if options.onlyerrors
	%fprintf('.');
else
	fprintf('%s%s ', testname, repmat('.',1,50-length(testname)));
end

if options.dryrun
	fprintf('pass\n');
	return
end

% sedumi disables all warnings, make sure we enable them for
% each test
warning('on');
t = clock;
try
	out = evalc(testname);
	runtime = etime(clock, t);
	if ~options.onlyerrors
		if ~isempty(findstr(out, 'Warning: '))
			outcome = 'warning';
		else
			outcome = 'ok';
		end
		fprintf('%s (%.1f)\n', outcome, runtime);
	end

catch
	runtime = etime(clock, t);
	flag = true;
	L = lasterror;
	% display a link pointing directly to the problematic line
	if options.onlyerrors
		fprintf('%s%s ', testname, repmat('.',1,50-length(testname)));
	end
	if usejava('desktop')
		fprintf('<a href="matlab:opentoline(''%s'', %d, 0)">error</a> (%.1f)\n', ...
			L.stack(1).file, L.stack(1).line, runtime);
	else
		fprintf('error (%.1f) !!!!!!\n', runtime);
	end
	outcome = 'error';
end
close all
drawnow
cd(cwd);

end

%-------------------------------
function list = filter_list(list, filters, mode)

if isempty(filters)
	return
end

plus_filters = find(cellfun(@(x) x(1)=='+', filters));
minus_filters = find(cellfun(@(x) x(1)=='-', filters));

% get rid of the +/- prefix
for i = 1:length(filters)
	if mode=='d'
		% directory mode, surround the filter by slashes to avoid
		% ambifuity
		filters{i} = [filesep filters{i}(2:end) filesep];
	else
		filters{i} = filters{i}(2:end);
	end
end


% only keep "+" entries
if numel(plus_filters)>0
	keep = false(1, length(list));
	for i = plus_filters
		idx = find(~cellfun(@isempty, strfind(list, filters{i})));
		% empty entries mean no match
		keep(idx) = true;
	end
	list = list(keep);
end

% now kick out "-" entries
for i = minus_filters
	keep = true(1, length(list));
	idx = find(~cellfun(@isempty, strfind(list, filters{i})));
	keep(idx) = false;
	list = list(keep);
end

end

%-------------------------------
function test_files = get_test_files(maindir, dir_filters, name_filters)

% determine recursive list of subdirectories
dirs = dirlist(maindir);

% add trailing slashes to all dir names such that we can easily apply
% filters
for i = 1:length(dirs)
	dirs{i} = [dirs{i} filesep];
end

% filter the list of directories (use the 'd' mode)
dirs = filter_list(dirs, dir_filters, 'd');

% find all test files
test_files = {};
for i = 1:length(dirs)
	shortdirname = dirs{i}(length(maindir)+2:end-1);
	cd(dirs{i});
	p = dir([dirs{i} 'test_*.m']);
	for j = 1:length(p)
		[~, testname] = fileparts(p(j).name);
		% do not consider fail tests
		if isempty(strfind(testname, '_fail'))
			test_files{end+1} = [dirs{i} testname];
		end
	end
end

% filter the list of tests (use the 't' mode)
test_files = filter_list(test_files, name_filters, 't');

end
