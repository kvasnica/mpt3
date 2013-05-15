function test_polyhedron_fplot_02_pass
%
% polyhedron - two functions
%

P = ExamplePoly.randHrep;
L = AffFunction(rand(2),randn(2,1));
Q = QuadFunction(rand(2),randn(1,2),1);
P.addFunction(L, 'a');
P.addFunction(Q, 'b');

h1=P.fplot({'a', 'b'});
if numel(h1)~=2
    error('Here must be 2 handles.');
end

h2 = P.fplot('a');
if isempty(h2)
    error('Here must be handle.');
end

h3 = P.fplot('a',2);
if isempty(h3)
    error('Here must be handle.');
end

h3 = P.fplot('b');
if isempty(h3)
    error('Here must be handle.');
end

close

end
