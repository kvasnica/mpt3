function [u, feasible, openloop, details] = evaluate(obj,x0)
%
% evaluates binary search tree
%
% inputs: obj - explicit MPC controller with search tree data
%         x0 - initial condition
%

% make sure the prediction horizon was provided
error(obj.assert_controllerparams_defined);

if isempty(obj.nu)
    error('The object doest not have "nu" property about the dimension of inputs.');
end

% check the input
x0 = x0(:);
if numel(x0) ~= obj.nx
    error('The point must be a %dx1 vector.', obj.nx);
end


% extract tree from the object
searchTree = obj.STdata.tree;

% use search tree for fast region identification
% contributed by Arne Linder
[lenST colST]=size(searchTree);
node=1; niter = 0;
while node>0  % node<0 means node is now number of control law
    niter = niter + 1;
    H=searchTree(node,1:colST-3);
    K=searchTree(node,colST-2);
    if H*x0-K<0
        node=searchTree(node,colST);  % x0 on plus-side of the hyperplane
    else
        node=searchTree(node,colST-1);  % x0 on minus-side of the hyperplane
    end
end

node = -round(node);

U = obj.feedback.Set(node).feval(x0,'primal');
cost = obj.cost.Set(node).feval(x0,'obj');
details.region = node;
feasible = ~isempty(U);

if ~feasible
    U = NaN(obj.nu*obj.N,1);
end

% take only the first step
u = U(1:obj.nu);

if nargout>=3
    openloop.cost = cost;
    openloop.U = reshape(U, [obj.nu obj.N]);
    openloop.X = NaN(obj.nx, obj.N+1);
    openloop.Y = NaN(obj.model.ny, obj.N);
end

if nargout>=5
    %====================================================================
    % compute number of operations needed to find the optimal control law
    
    % H*x0, where H is a row vector needs "nx" multiplications
    details.nops.multiplications = niter*length(x0);
    
    % H*x0   requires "nx" summations
    % H*x0-K requires 1 additional summation (adding -K)
    details.nops.summations = niter*(length(x0) + 1);
    
    % comparing (H*x0 - K)<0 needs 1 comparison, since H is a row vector
    details.nops.comparisons = niter;
    
    % F*x0 + G
    details.nops.multiplications = details.nops.multiplications + obj.nu*length(x0);
    details.nops.summations = details.nops.summations + obj.nu + obj.nu*length(x0);
end

end
