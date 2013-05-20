function test_polyhedron_mtimes_09_pass
%
% matrix V-polyhedron
%

P = ExamplePoly.randVrep;
A = randn(2);

R = A*P;

x = P.grid(10);

y = x;
for i=1:size(x,1)
   y(i,:) =  transpose(A*x(i,:)');    
end

if any(~R.contains(y'))
    error('All these points must belong to R.');
end



end
