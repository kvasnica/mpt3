function  test_polyhedron_project_05_pass
%
% low-dim polyhedron array + matrix
%

P(1) = 10*Polyhedron('V',randn(8,4),'R',randn(2,4));
P(2) = 10*ExamplePoly.randHrep('d',4,'ne',2)+[10;-10;0;5];
d = P.project(randn(8,4));

for i=1:2
    dist = [d{i}.dist];
    if any(isempty(dist))
        error('Wrong result.');
    end
end

end