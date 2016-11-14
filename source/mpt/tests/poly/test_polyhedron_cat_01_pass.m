function test_polyhedron_cat_01_pass
%
% isFullDim test
% 
% 

% no matrix concatenation
P = [Polyhedron(randn(5)) Polyhedron; Polyhedron(randn(2)) Polyhedron];

if size(P,1)~=4
    error('wrong concatenation');
elseif size(P,2)~=1
    error('wrong concatenation');
end

