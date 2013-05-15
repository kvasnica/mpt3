function run_nag_tests
%
%  RUN_NAG_TESTS:   run tests for NAG solvers 
%  ===========================================
%     
%    
%    
%    run_nag_tests
%    
%  
%  DESCRIPTION
%  -----------
%    
%    Run PASS/FAIL tests for NAG solvers (mexnaglp, mexnagqp) in the "test" directory.
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


flag = false;

% find directory
d=which('run_qp_tests');
id = strfind(d, filesep);
d = d(1:id(end));

% execute testing files in this directory
disp('-------------------------------------------------------------------')
p = dir([d,'test_nag*pass.m']);
disp(' ');
disp('Pass tests:');
disp(' ');
for j=1:numel(p)
    try
        eval(strtok(p(j).name,'.'));
        disp([p(j).name,'........................ ok']);
    catch
        flag = true;
        disp([p(j).name,'........................ error']);
    end
end
p = dir([d,'test_nag*fail.m']);
disp(' ');  
disp('Fail tests:');
disp(' ');
for j=1:numel(p)
    try
        eval(strtok(p(j).name,'.'));
        disp([p(j).name,'........................ error']);
        flag = true;
    catch
        disp([p(j).name,'........................ ok']);
    end
end
disp('  ');
disp('-------------------------------------------------------------------')
if flag
   warning('Nag tests failed.'); 
end
