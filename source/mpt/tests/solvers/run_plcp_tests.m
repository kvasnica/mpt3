function run_plcp_tests
%
% header to be inserted

global MPTOPTIONS

if isempty(MPTOPTIONS)
    MPTOPTIONS = mptopt;
end

% add other parametric solvers later and compare them
%name = MPTOPTIONS.solvers_list.parametric
name = {'PLCP'};

tol = 1e-5;
ct = zeros(1,numel(name));

% find directory
d=which('run_plcp_tests');
id = strfind(d, filesep);
d = d(1:id(end));

% execute testing files in this directory
disp('-------------------------------------------------------------------')
for i=1:numel(name)
    solvername = name{i};
    disp(['Testing ', upper(solvername),' solver:']);

    p = dir([d,'test_plcp_*']);
    for j=1:numel(p)
        try
            t = cputime;
            eval([strtok(p(j).name,'.'),';']);
            tf = cputime-t;
            disp([p(j).name,'........................ ok    cputime = ', sprintf('%.6f',tf),'s']);
            ct(i) = ct(i) + tf; 
        catch ME
           disp([p(j).name,'........................ error']);            
        end
    end
       
    disp('  ');
end

% finding the fastest solver
[mct, imin] = sort(ct);

disp(['The fastest solver ',upper(name{imin(1)}),' needed ',sprintf('%.6f',mct(1)),'s to solve all tests.']);
for i=2:numel(name)
   disp([upper(name{imin(i)}),' needed ', sprintf('%.6f',mct(i)),'s.']);
end
disp('-------------------------------------------------------------------')
