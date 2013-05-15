function [ret,opt] = solve(opt)
%
% Solve the problem
%

global MPTOPTIONS

if isempty(MPTOPTIONS)
    MPTOPTIONS = mptopt;
end

% deal with arrays
ret=cell(size(opt));
if numel(opt)>1
    parfor i=1:numel(opt)
        ret{i} = opt(i).solve;
    end
    return
end

% Determine problem type
if opt.isParametric
    % for parametric solvers use "mpt_solvemp" which depends
    % on OPT and POLYHEDRON classes
    ret = mpt_solvemp(opt);
else
    % non-parametric solvers can be called directly,
    ret = mpt_solve(opt);
end

end
