function test_opt_35_pass
%
% MPMIQP
%

A = [1 0 10;
    -1 0 10;
    0 1 10;
    0 -1 10;
    1 0 -10;
    -1 0 -10;
    0 1 -10;
    0 -1 -10;
    0 0 0;
    0 0 0;
    0 0 0;
    0 0 0];
pB = [1 0;
    -1 0;
    0 1;
    0 -1;
    0 0;
    0 0;
    0 0;
    0 0;
    1 0;
    -1 0;
    0 1;
    0 -1];
b = [10; 10; 10; 10; 0; 0; 0; 0; 10; 10; 10; 10];

H=diag([1 1 0]);
f= [0 0 -25];
c = 100;

problem=Opt('H',H,'f',f,'c',c,'A',A,'b',b,'pB',pB,'vartype','CCB');


[worked, msg] = run_in_caller('res = problem.solve; ');
assert(~worked);
asserterrmsg(msg,'mpt_call_plcp: PLCP solver does not solve MIQP problems.');

end
