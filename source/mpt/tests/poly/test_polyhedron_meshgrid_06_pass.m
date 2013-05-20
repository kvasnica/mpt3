function test_polyhedron_meshgrid_06_pass
%
% racy 2D case

H = [0.145316894996979 0.989385162628001 2.38975849892281;0.707106781186547 0.707106781186548 4.24264068711928;0.447213595499958 0.894427190999916 3.35410196624968;-1 0 5;-0.235639319129506 -0.971840579148753 -1.78883164925536;-0.169666401728447 -0.985501553588081 -2.12777267187747];
P = Polyhedron('H', H);


% observe missing points:
close all
P.plot(); axis equal; a=axis;

[x, y] = P.meshGrid(5);
figure; surf(x, y, 0*x); view(2); axis(a);

[x, y] = P.meshGrid(10);
figure; surf(x, y, 0*x); view(2); axis(a);

% but the output of meshgrid should give the original polytope:
[x, y] = P.meshGrid(5);
V = [];
for i = 1:size(x, 1)
	for j = 1:size(x, 2)
		if ~isnan(x(i, j))
			V = [V; x(i, j), y(i, j)];
		end
	end
end
assert(Polyhedron(V)==P);
