function test_polyunion_06_pass
%
% polyhedra, pass any data do Data
%

P(1) = ExamplePoly.randHrep;
P(2) = ExamplePoly.randZono;
U = PolyUnion('Set',P,'Data',struct('a',1,'b',2));

if U.Num~=2
    error('Must have 2 elements.');
end
if isempty(U.Data)
   error('Must not be empty.');
end

end