function test_polyhedron_setdiff_18_pass
%
% low-dimensional polyhedra
%

P = ExamplePoly.randHrep('d',3,'ne',1);
Q = 0.5*P;

res = P\Q;

if any(res.contains(Q))
    error('No overlap here!');
end
if any(res.isFullDim)
    error('All polyhedra are low-dimensional here.');
end

end