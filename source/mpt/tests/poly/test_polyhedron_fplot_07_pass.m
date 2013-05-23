function test_polyhedron_fplot_07_pass
%
% 1D polyhedron, affine function, markings
%

P = Polyhedron('V',[-5;-3; 2;1]);

L = AffFunction([-1;2],[-2;0.5]);
P.addFunction(L,'gain');

% dash-dots, red, size 4
h1=P.fplot('gain','linestyle','-.','color','red','linewidth',4);
assert(numel(h1)==1);

% here we must get 2 handles (polyhedron + function)
h2=P.fplot('gain','show_set',true,'alpha',0.5,'color','olive');
assert(numel(h2)==2);

hold on
h3=P.fplot('gain','position',2,'alpha',0.5,'color','blue');
assert(numel(h3)==1);

end
