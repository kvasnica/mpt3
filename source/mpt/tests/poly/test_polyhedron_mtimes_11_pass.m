function test_polyhedron_mtimes_11_pass
%
% matrix He-polyhedron
%

P = ExamplePoly.randHrep('d',3,'ne',2);
A = [randn(2,3); 0 0 0];

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
