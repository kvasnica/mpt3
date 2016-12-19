function test_polyhedron_isbounded_02_pass
%
% isbounded test
% 
% 

% x<=1
P = Polyhedron(1,1);

if isBounded(P)
    error('Given polyhedron object should be unbounded.');
end

end
