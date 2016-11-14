function test_polyhedron_cat_03_pass
%
% isbounded test
% 
% 

% no matrix concatenation allowed
P = [Polyhedron(randn(3)), Polyhedron; Polyhedron(randn(2)) Polyhedron; Polyhedron(randn(4)), Polyhedron(randn(2),randn(2,1))];

if size(P,1)~=6
    error('Wrong concatenation.');
elseif size(P,2)~=1
    error('Wrong concatenation.');
end


end
