function test_polyhedron_separate_08_pass
%
% vector
%

% not consistent bounds
P = Polyhedron('lb',[2;4],'ub',[3;4]);

h = P.separate([5;5]);


if isempty(h)
    error('P is not empty, thus h is not.');
end

end