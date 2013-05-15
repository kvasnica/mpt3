function test_polyhedron_isadjacent_10_pass
%
%  unbounded and low-dim
%

P = Polyhedron('H',[0.76591      0.95021      0.17105;
                    0.88713      0.37937      0.29302;
                    0.090915      0.82066      0.42907;
                    0.29356      0.77853       0.2176]);

Q = Polyhedron('H',-P.H(1,:),'He',[1 -0.5 0]);


if ~P.isAdjacent(Q)
    error('Regions must be adjacent.')
end

end