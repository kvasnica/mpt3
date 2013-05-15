function test_polyhedron_interiorPoint_01_pass
%
% empty polyhedron
%

P = Polyhedron;

res = P.interiorPoint;

if ~isempty(res.x)
    error('Empty polyhedron does not have interior point.');
end



end