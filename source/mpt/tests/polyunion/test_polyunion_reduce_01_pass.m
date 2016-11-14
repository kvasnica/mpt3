function test_polyunion_reduce_01_pass
%
% empy-polyunion -empty 
%

U = PolyUnion;
U.reduce;

if U.Num~=0
    erro('Must be empty.');
end

end