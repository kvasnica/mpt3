function test_plcp_18_pass
%
% bug submitted by H. Peyrl, 08/10/2012 03:30:48 PM
%
%%
% I have another issue with MPT3 used via Yalmip and the new Opt class you told me about in your last email. The following example yields 'infeasible' 
%
% x = sdpvar(2,1); x0 = sdpvar(2,1) 
%
% obj = (x-x0)'*(x-x0) 
% constr = lmi(x(1) <= x(2))
% opt = Opt(constr, obj, x0, x) 

%MH: The solution is unbounded and the intial region found by PLCP was
% unbounded - therefore PLCP reported this problem as infeasible. The problem was in
% adjusting the boundaries for detection of unbouned polyhedra in
% Polyhedron/isBounded. 

global MPTOPTIONS

x = sdpvar(2,1); x0 = sdpvar(2,1);

obj = (x-x0)'*(x-x0);
constr = lmi(x(1) <= x(2)); 
opt = Opt(constr, obj, x0, x);


problem = opt.solve;

if problem.xopt.Num~=2
    error('Here must be two regions.');
end
if problem.exitflag~=MPTOPTIONS.OK
    error('Problem is feasible, but unbounded. PLCP bounds the solution with artificial bounds.');
end



end