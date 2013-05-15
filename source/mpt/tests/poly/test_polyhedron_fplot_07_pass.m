function test_polyhedron_fplot_07_pass
%
% 1D polyhedron, affine function, markings
%

P = Polyhedron('V',[-5;-3; 2;1]);

L = AffFunction([-1;2],[-2;0.5]);
P.addFunction(L,'gain');

% dash-dots, red, size 4
h1=P.fplot('gain',1,'linestyle','-.','color','red','linewidth',4);

if numel(h1)~=1
    error('Here must be handle.');
end

% plot with polyhedron, alpha-transparent, in olive color
h2=P.fplot('gain',1,'polyhedron',true,'alpha',0.5,'color','olive');
if numel(h2)~=2
    error('Here must be 2 handles (polyhedron+function).');
end
hold on
h3=P.fplot('gain',2,'alpha',0.5,'color','blue');
if numel(h3)~=1
    error('Here must be handle.');
end


close;
end