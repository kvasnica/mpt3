function test_convexset_outerapprox_05_pass
%
% V-polyhedron, one equality constraint
%


H = [    -0.24332      0.80754       -1.052       1.0453
      0.17328     -0.51063      0.36211       1.8991
      -0.5217      -0.8299      -0.2751       2.3055
        1.432      0.53299     -0.16044       2.8391];
P = Polyhedron('H',H,'He',[1 -0.5 0 0.6]);

B = P.outerApprox;

lb = [-0.80929
      -2.8186
      -2.3166];
ub = [1.9077
       2.6154
       8.0198];
   
if norm(B.Internal.lb-lb,Inf)>1e-4
    error('Wrong lower bounds.');
end

if norm(B.Internal.ub-ub,Inf)>1e-4
    error('Wrong upper bounds.');
end

end