function test_polyhedron_isbounded_01_pass
%
% isbounded test
% 
% 

if ~isBounded(Polyhedron)
    error('Given polyhedron object should be bounded.');
end

end
