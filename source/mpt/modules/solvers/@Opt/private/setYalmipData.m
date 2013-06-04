function opt = setYalmipData(opt, con, obj, th, u)
%
%         Set data from a YALMIP object
%
% Convert a yalmip problem min obj s.t. con to the form of a
% parametric optimization problem
%
% th == parametric variables
% u  == optimization variables of interest

global MPTOPTIONS

if isempty(MPTOPTIONS)
    MPTOPTIONS = mptopt;
end


if nargin < 5, error('Opt: Syntax : opt.setYalmipData(con, obj, th, u)'); end


% We use quadprog here in order to get a consistent model structure
[interfacedata,recoverdata,solver,diagnostic,F,Fremoved] = compileinterfacedata(con,[],[],obj,sdpsettings,0,true);
if isempty(interfacedata)
    error('Opt: Could not create yalmip model')
end

% Get the parametric variables
temp = [];
for i = 1:length(th), temp = [temp;getvariables(th(i))]; end
% respect ordering of parametric variables!
[~, interfacedata.parametric_variables] = ismember(temp, recoverdata.used_variables);

% Get the optimization variables
interfacedata.requested_variables = [];
for i = 1:length(u)
    interfacedata.requested_variables = [interfacedata.requested_variables;find(ismember(recoverdata.used_variables,getvariables(u(i))))];
end

% Convert from Yalmip => mpt2.6 => mpt3 format
mat = yalmip2mpt(interfacedata);
mat.lb(mat.lb==Inf) = MPTOPTIONS.infbound;
mat.lb(mat.lb==-Inf) = -MPTOPTIONS.infbound;
mat.ub(mat.ub==Inf) = MPTOPTIONS.infbound;
mat.ub(mat.ub==-Inf) = -MPTOPTIONS.infbound;
opt = opt.setMPT26Data(mat);

%       [model,rmodel,dd,internal] = export(con,obj,sdpsettings('solver','mpt'));
%       vars = find(ismember(internal.used_variables,getvariables(x)));
%       internal.parametric_variables = vars;
%       vars = find(ismember(internal.used_variables,getvariables(u)));
%       internal.requested_variables = vars;


end
