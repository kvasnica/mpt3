function test_polyhedron_setdiff_12_pass
%
% set difference that got stuck during solving PLCP
%

load data_setdiff02

% P\Q resulted in a loop in set difference 
R = data.P\data.Q;

% result are two small regions located at the bottom right
for i = 1:numel(R)
	assert(R(i)<=data.P);
	assert(~R(i).intersect(data.Q).isFullDim());
end

if numel(R)~=2
    error('Result must be two regions.');
end

end
