function test_polyhedron_40_pass
%
% Compatible H- and V-representation is provided in Polyhedron/plus method.
% The test should show that there is no compatibility check when
% providing H- and V-representation.
%
% Test data by D. Raimondo.
%

load set_file
P = set1+ [2;2];

% the new constructed polyhedron must have center around [2;2]
xc = P.interiorPoint;


if norm(xc.x-[2;2],Inf)>1e-5
    error('The center must be arount the point [2;2].');
end

end
