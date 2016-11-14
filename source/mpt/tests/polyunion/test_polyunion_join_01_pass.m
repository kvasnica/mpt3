function test_polyunion_join_01_pass
%
% polyunion + empty polyunion
%

for i=1:4
    P(i) = ExamplePoly.randHrep;
end

U(1) = PolyUnion('Set',P,'FullDim',true);
U(2) = PolyUnion;


Un = U.join;

if Un.Num~=4
    error('Four sets must be present here.')
end

if ~Un.Internal.FullDim
    errror('Must be full-dimensional here.');
end

end
