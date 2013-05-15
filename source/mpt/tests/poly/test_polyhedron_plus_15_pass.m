function test_polyhedron_plus_15_pass
%
% unbounded + unbounded
%

P = Polyhedron('lb',[0;0;0]);
S = Polyhedron('He',[0.85315,-1.89,-0.31564,-1.8958],'lb',[10;6;8]);

R = P+S;

if R.isBounded
    error('R is unbounded.');
end
if ~R.contains(S)
    error('S is contained in R.');
end


end