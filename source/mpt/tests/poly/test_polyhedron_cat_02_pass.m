function test_polyhedron_cat_02_pass
%
% isempty test
% 
% 

% no matrix concatenation allowed
P = [Polyhedron(randn(5)); [Polyhedron(1), Polyhedron]; Polyhedron(randn(2)),[]; Polyhedron];

if size(P,1)~=5
    error('Wrong concatenation.');
elseif size(P,2)~=1
    error('Wrong concatenation.');
end


end

