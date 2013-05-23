function test_polyhedron_fplot_11_pass
%
% affine set in 2D
%

% P is just a point in 2D
P = Polyhedron('Ae',[-1 -0.4;0 3.1],'be',[-0.1;0.5],'lb',[-2;-3],'ub',[2;3]);

P.addFunction(Function(@(x)x), 'a');

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
