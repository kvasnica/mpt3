function test_polyhunion_reduce_07_pass
%
% unbounded +(affine set) contained inside
%

P(1) = Polyhedron('v',[
          1.2372      0.95156      0.66255
      -1.0088      -0.4019      0.15105
      0.92657      -1.8312      0.58699
       1.2248      0.30123     -0.58112
     -0.49751       1.5774      0.19107
       -1.485      0.87868      0.82978
      -0.4477      -1.7039      0.18064
      -2.0269     -0.50508     0.066671
       -1.026      -1.2055      -1.6354
      -1.0517     -0.93079       2.0966],...
      'r',[1.1675     -0.12939     -0.16169
      -0.7447      -1.4554     -0.66829]);

% just a point [5;-5;-4] that is contained inside P(1)
P(2) = Polyhedron('Ae',[    1.521      -0.6962      0.58694
    -0.038439    0.0075245     -0.25121
    1.2274     -0.78289      0.48014],'be',[8.7383; 0.77501; 8.1312]);
    

% P(2) and P(3) are contained inside P(1)
U = PolyUnion('set',P);
U.reduce;
if U.Num~=1
    error('Must be one element.');
end

end