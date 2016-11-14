function [sys,x0,str,ts] = modelsim_sfunc(t,x,u,flag,model,X0)
%
% s-function for simulation of a LTI/PWA/MLD model of MPT3 format
%

switch flag,
    
    %%%%%%%%%%%%%%%%%%
    % Initialization %
    %%%%%%%%%%%%%%%%%%
    case 0,
        [sys,x0,str,ts] = mdlInitializeSizes(model,X0);
        
        %%%%%%%%%%
        % Update %
        %%%%%%%%%%
    case 2,
        sys = mdlUpdate(t,x,u,model); 
        
        %%%%%%%%%%
        % Output %
        %%%%%%%%%%
    case 3,
        sys = mdlOutputs(t,x,u,model);
        
        %%%%%%%%%%%%%
        % Terminate %
        %%%%%%%%%%%%%
    case 9,
        sys = []; % do nothing
        
        %%%%%%%%%%%%%%%%%%%%
        % Unexpected flags %
        %%%%%%%%%%%%%%%%%%%%
    otherwise
        error(['unhandled flag = ',num2str(flag)]);
end

end

function [sys,x0,str,ts] = mdlInitializeSizes(model,X0)

sizes = simsizes;
sizes.NumContStates  = 0;
sizes.NumDiscStates  = model.nx+model.ny;
sizes.NumOutputs     = model.nx+model.ny;
sizes.NumInputs      = model.nu;
sizes.DirFeedthrough = 0;
sizes.NumSampleTimes = 1;

sys = simsizes(sizes);

if isempty(X0),
    X0 = zeros(model.nx,1);
end

% initialize model
model.initialize(X0);
x0 = [X0; zeros(model.ny,1)];
str = [];
ts  = [model.Ts 0]; 
end

% end mdlInitializeSizes
function sys = mdlUpdate(t,x,u,model)
    sys = zeros(model.nx+model.ny,1);   
    [xn,y] = model.update(u);
    sys(1:model.nx) = xn;
    sys(model.nx+1:end) = y;
end

function sys = mdlOutputs(t,x,u,model)
    sys = x;
end
