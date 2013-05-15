function R = mpt_call_linprog(S)
%
% header file to be inserted from XML source

global MPTOPTIONS
if isempty(MPTOPTIONS) && ~S.test
    MPTOPTIONS = mptopt;
end

if ~strcmpi(S.problem_type,'LP')
    error('mpt_call_linprog: LINPROG solver does not solve %s problems!',S.problem_type);
end

% overwrite default settings
if S.test
    options=optimset(optimset('linprog'),'Display','off');
else
    options=MPTOPTIONS.modules.solvers.linprog;
end

% direct call to linprog
[R.xopt,R.obj,exitflag,OUTPUT,R.lambda]=linprog(S.f,S.A,S.b,S.Ae,S.be,S.lb,S.ub,S.x0,options);

if exitflag>0 
    R.how = 'ok';
    if S.test
        R.exitflag = 1;
    else
        R.exitflag = MPTOPTIONS.OK;
    end
else
    R.how = 'infeasible';
    if S.test
        R.exitflag = 2;
    else
        R.exitflag = MPTOPTIONS.INFEASIBLE;
    end
end

%R.lambda=[lambdav.ineqlin; lambdav.eqlin];

end