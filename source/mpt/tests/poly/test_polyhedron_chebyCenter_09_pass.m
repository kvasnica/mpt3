function test_polyhedron_chebyCenter_09_pass
%
% empty polyhedron
%
P = Polyhedron;
xc = P.chebyCenter;

if ~isempty(xc.x)
    error('The solution must be empty.');
end
if xc.r~=-Inf
    error('The radius should be -Inf.');
end

end