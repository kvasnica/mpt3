function test_polyunion_eq_02_pass
%
% empty arrays
%

U1 = PolyUnion;
U1(1)=[];
U2 = PolyUnion;

ts = (U1 == U2);

if ts
    error('Not equal for empty arrays.');
end

tn = (U2 == U1);
if tn
    error('Not equal for empty arrays.');
end

U2(1) = [];

tsn = (U1 == U2);
if ~tsn
    error('Empty arrays should be equal.');
end


end