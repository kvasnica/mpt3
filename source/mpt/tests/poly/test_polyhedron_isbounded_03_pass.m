function test_polyhedron_isbounded_03_pass
%
% isbounded test
% 
% 

% -5<=x<=1
P = Polyhedron([1;-1],[1;5]);

if ~isBounded(P)
    error('Given polyhedron object should be bounded.');
end

end
