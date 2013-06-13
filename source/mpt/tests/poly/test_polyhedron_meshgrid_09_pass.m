function test_polyhedron_meshgrid_09_pass
%
% wrong grid
%

P=Polyhedron('lb',[0;0;0],'ub',[1;2;3]);

% wrong grid number
[worked, msg] = run_in_caller('[X,Y]=P.meshGrid(11.2); ');
assert(~worked);
asserterrmsg(msg,'Input argument is a not valid dimension.');

end