function test_polyhedron_fplot_01_pass
%
% polyhedron - one function
%

P = ExamplePoly.randHrep;
while ~P.isBounded
    P = ExamplePoly.randHrep;
end

L = AffFunction(rand(2),randn(2,1));
P.addFunction(L, 'a');

h1=P.fplot;
if isempty(h1)
    error('Here must be handle.');
end

h2 = P.fplot('a',1);
if isempty(h2)
    error('Here must be handle.');
end

h3 = P.fplot('a',2);
if isempty(h3)
    error('Here must be handle.');
end

close

end
