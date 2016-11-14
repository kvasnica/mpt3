function test_polyunion_reduce_06_pass
%
% unbounded +(full-dim, low-dim) contained inside
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

P(2) = Polyhedron('lb',[-1;-1;-1],'ub',[1;1;1])+[5;-5;-2.2];
P(3) = [0.5 0 -1;0 1 0;0 0 0]*P(2)-[2;5;5];

% P(2) and P(3) are contained inside P(1)
U = PolyUnion('set',P);
U.reduce;
if U.Num~=1
    error('Must be one element.');
end

end