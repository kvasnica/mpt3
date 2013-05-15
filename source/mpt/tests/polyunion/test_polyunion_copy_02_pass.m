function test_polyunion_copy_02_pass
%
% copy one set including function
%

P = ExamplePoly.randHrep;
P.addFunction(Function(@(x)x), 'a');
U = PolyUnion(P);
Un = U.copy;

if isempty(Un.Set)
    error('Here must be one polyhedron.');
end
if isempty(Un.Set(1).Func)
    error('The function handle must be present here.');
end

end
