function test_polyhedron_fplot_03_pass
%
% polyhedron - two functions with labels
%

P = ExamplePoly.randHrep;
while ~P.isBounded
    P = ExamplePoly.randHrep;
end
L = AffFunction(rand(2),randn(2,1));
Q = QuadFunction(rand(2),randn(1,2),1);
P.addFunction(L,'friction');
P.addFunction(Q,'traction');

h1=P.fplot('friction',1);
if isempty(h1)
    error('Here must be a handle.');
end
h2=P.fplot('friction',2);
if isempty(h2)
    error('Here must be a handle.');
end

h3 = P.fplot('traction');
if isempty(h3)
    error('Here must be handle.');
end

close

end