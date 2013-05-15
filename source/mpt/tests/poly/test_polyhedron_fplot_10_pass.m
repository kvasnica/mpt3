function test_polyhedron_fplot_10_pass
%
% 2D polyhedron array, two affine functions with names
%

P(1) = ExamplePoly.randZono;
P(2) = ExamplePoly.randZono+[5;6];

Q(1) = AffFunction(randn(1,2),5);
Q(2) = AffFunction(randn(1,2),-5);
P.addFunction(Q(1), 'hel');
P.addFunction(Q(2), 'pab');


h1=P.fplot('hel',1,'polyhedron',true,'wire',true,'alpha',0.4);
if numel(h1)~=4
    error('Wrong number of handles.');
end

P.fplot('pab',1,'wire',true,'LineWidth',2);

h=get(gca,'Children');
if numel(h)~=2
    error('Wrong number of handles.');
end


close
end
