function status = fast_isFullDim(H)
% returns true if {x | H*[x; -1]<=0} is fully dimensional

global MPTOPTIONS

A = H(:, 1:end-1);
[m, n] = size(A);
S.A  = [A sqrt(sum(A.*A,2)); zeros(2, n) [-1;1]];
S.b = [H(:, end); 0; 1]; % artificial upper bound on the chebychev radius
S.f = [zeros(n, 1); -1];
S.Ae = []; S.be = [];
S.lb = []; S.ub = []; 
S.quicklp = true;
ret = mpt_solve(S);

status = (ret.exitflag == MPTOPTIONS.OK) && (-2*ret.obj>MPTOPTIONS.region_tol);

end
