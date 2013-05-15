function test_polyhedron_fplot_05_pass
%
% H-V array of polyhedra, linear function
%

P(1) = Polyhedron('lb',[-4;-1],'ub',[5;0]);
P(2) = Polyhedron('V',randn(5,2))+[5;3];

L = AffFunction(5*eye(2));
P.addFunction(L,'gain');

h1=P.fplot;

if isempty(h1)
    error('Here must be handle.');
end
if numel(h1)~=2
    error('Here must be 2 handles.');
end


close;
end