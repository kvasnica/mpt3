% clear;

N = 500;

for i=1:N
  A{i} = randn(50,4); b{i} = ones(50,1);
end

% tic
% for i=1:N
%   p(i) = polytope(A{i},b{i});
% end
% toc

tic
for i=1:N
  P(i) = Polyhedron(A{i},b{i});
end
toc

PS = PolySet;
tic
for i=1:N
  PS.add(Polyhedron(A{i},b{i}));
end
toc

PS2 = PolySet;
tic
PS.add(P);
toc
