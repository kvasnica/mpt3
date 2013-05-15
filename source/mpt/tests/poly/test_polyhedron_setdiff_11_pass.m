function test_polyhedron_setdiff_11_pass
%
% set difference that got stuck during solving PLCP
%

load data_setdiff01

% P\Q resulted in a loop because of numerical problems with rank1-updates in LCP
% solver when detecting if intersection of P, Q is empty. This can be
% resolved by picking routine 1 or 2 in LCP options settings or by reducing
% the nstepf (refactorization) steps.
R = P\Q;

% since the result can be arbitrarily ordered, we need to test each combination 


if ~(R==P)
    error('R should be equal P and there should be no overlap in P, Q.');
end

end