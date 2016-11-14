function test_polyhedron_interiorPoint_08_pass
%
% low-dim set
%

P = ExamplePoly.randHrep('d',5,'ne',2);

res = P.interiorPoint;

if res.isStrict
    error('The point cannot lie in strict interior because we have equality constraints.');
end

end