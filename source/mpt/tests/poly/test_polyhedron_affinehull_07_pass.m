function test_polyhedron_affinehull_07_pass
%
% unbounded V-polyhedron
%


V1 = [ 0.54167      0.37837      0.59356      0.82163      0.66023
      0.15087      0.86001      0.49655      0.64491      0.34197
       0.6979      0.85366      0.89977      0.81797      0.28973];

V2 = 2*V1 + [zeros(3,4) ones(3,1)];

R = [0 1 -2 0.3 0.5;
     0 -1 2 -0.3 -0.5];

P = Polyhedron('V',[V1;V2],'R',R);

a =  P.affineHull;

an = a/a(1);

Q = P.minHRep();
bn = Q.He/Q.He(1);

if norm(an-bn,Inf)>1e-4
    error('Affine hulls don''t fit');
end

end
