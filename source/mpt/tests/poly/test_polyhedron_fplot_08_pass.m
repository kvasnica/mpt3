function test_polyhedron_fplot_08_pass
%
% 2D polyhedron, affine function, markings
%

P = Polyhedron('V',[-5 -3; 2 1; 5 4]);

L = AffFunction([-1 0.6;2 -3],[-2;0.5]);
P.addFunction(L,'risk');

% dash, magenta, size 3
h1=P.fplot('risk',1,'linestyle','--','color','magenta','linewidth',3);

if numel(h1)~=1
    error('Here must be handle.');
end

% plot with polyhedron, alpha-transparent, in olive color, wired
h2=P.fplot('risk',2,'polyhedron',true,'alpha',0.3,'color','olive','wire',true);
if numel(h2)~=2
    error('Here must be 2 handles (polyhedron+function).');
end


close;
end