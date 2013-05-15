function test_polyhedron_contains_10_pass
%
% 2V-He
%

P(1) = Polyhedron([145 134; 80 456; -180 345; -567 -810]);
P(2) = Polyhedron([809 1345; -1245 8014; 971 -245; 256 -145; -1345 -1414]);

S = Polyhedron('He',[-0.3 0.1 0.2],'lb',[-5;-4],'ub',[1;3]);

% P1 is contained in P2
if ~P(2).contains(P(1))
    error('P1 must contain P2.')
end

% S is contained in both
if any(~P.contains(S))
    error('Both P must contain S.')
end

end