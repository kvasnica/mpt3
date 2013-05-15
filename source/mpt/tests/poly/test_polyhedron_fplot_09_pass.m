function test_polyhedron_fplot_09_pass
%
% 2D polyhedron, vectorized quadratic function
%

P = ExamplePoly.randZono;

Q = QuadFunction(randn(2,2,2),randn(2),[5;0]);
P.addFunction(Q, 'q');


P.fplot('q',1);
hold on
P.fplot('q',2);

h=get(gca,'Children');

if numel(h)~=2
    error('Wrong number of handles.');
end

close
end
