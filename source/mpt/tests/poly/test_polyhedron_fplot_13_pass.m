function test_polyhedron_fplot_13_pass
%
% affine set in 1D, linear func
%

% P is just a point in 2D
P = Polyhedron('Ae',1,'be',2,'lb',-2,'ub',3);

P.addFunction(AffFunction(5), 'a');

% the test is just function plot
P.fplot;

h=get(gca,'Children');
if numel(h)~=1
    error('Wrong plot.');
end

P.fplot('a','show_set',true);
hn = get(gca,'Children');
if numel(hn)~=2
    error('Wrong plot.');
end

close

end
