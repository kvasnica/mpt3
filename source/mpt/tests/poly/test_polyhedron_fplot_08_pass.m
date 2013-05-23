function test_polyhedron_fplot_08_pass
%
% 2D polyhedron, affine function, markings
%

P = Polyhedron('V',[-5 -3; 2 1; 5 4]);

L = AffFunction([-1 0.6;2 -3],[-2;0.5]);
P.addFunction(L,'risk');

% dash, magenta, size 3
h1=P.fplot('risk','linestyle','--','color','magenta','linewidth',3);
assert(numel(h1)==1);

% we must get two handles (one for the set, one for the function)
h2=P.fplot('risk',2,'show_set',true,'alpha',0.3,'color','olive','wire',true);
assert(numel(h2)==2);


close;
end
