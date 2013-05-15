function run_qp_tests
%
%  RUN_QP_TESTS:   run tests for QP 
%  =================================
%     
%    
%    
%    run_qp_tests
%    
%  
%  DESCRIPTION
%  -----------
%    
%    Run tests in the "test" directory for different QP solvers.
%    
%  
%  AUTHOR
%  ------
%    
%    
%   
%   
%   (c) 2010  Martin Herceg, Automatic Control Laboratory, ETH Zurich,
%   herceg@control.ee.ethz.ch
%    
%    
%  
%  LEGAL NOTE
%  ----------
%     This program is free software; you can redistribute it and/or modify it under the terms of the
%  GNU General Public License as published by the Free Software Foundation; either version 2.1 of the
%  License, or (at your option) any later version.
%    This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without
%  even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
%  General Public License for more details.
%    You should have received a copy of the GNU General Public License along with this library; if not,
%  write to the  Free Software Foundation, Inc.,  59 Temple Place, Suite 330,  Boston, MA 02111-1307
%  USA 	

global MPTOPTIONS

if isempty(MPTOPTIONS)
    MPTOPTIONS = mptopt;
end

% list of solvers to test
%name= {'quadprog', 'CLP', 'qpOASES', 'NAG', 'CPLEX', 'Sedumi','qpas','qpip'};
name = MPTOPTIONS.solvers_list.QP;
% tolerance for mbg_assert_equal
tol = 1e-4;
% initializing computational times
ct = zeros(1,numel(name));

% find directory
d=which('run_qp_tests');
id = strfind(d, filesep);
d = d(1:id(end));

% execute testing files in this directory
disp('-------------------------------------------------------------------')
for i=1:numel(name)
    solvername = name{i};
    disp(['Testing ', upper(solvername),' solver:']);
    
    p = dir([d,'test_qp_solvers*']);
    for j=1:numel(p)
        try
            t = cputime;
            eval([strtok(p(j).name,'.'),'(''',name{i},''',',num2str(tol),');']);
            tf = cputime-t;
            disp([p(j).name,'........................ ok    cputime = ', sprintf('%.6f',tf),'s']);
            ct(i) = ct(i) + tf; 
        catch
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
