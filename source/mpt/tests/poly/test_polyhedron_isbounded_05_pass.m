function test_polyhedron_isbounded_05_pass
%
% isbounded test
% 
% 

% few inequalities in 5d
P = Polyhedron([1 0 0 0 0; 0 -1 0 0 0],[0.5; 2]);

if isBounded(P)
    error('Given polyhedron object should be unbounded.');
end

end
