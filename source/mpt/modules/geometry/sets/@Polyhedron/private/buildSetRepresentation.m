function optMat = buildSetRepresentation(obj)
%
% Compute matrices representing the set for the purposes of
% optimization
%

% Choose H-rep or V-rep
hRep = obj.hasHRep; vRep = obj.hasVRep;

% % we have a problem here with empty polyhedra, e.g. 
% % Polyhedron(zeros(0, 2), [])
%
% if size(obj.H_int,1) > 0 || size(obj.He_int,1) > 0
%     hRep = true;
% end
% if size(obj.V_int,1) > 0 || size(obj.R_int,1) > 0
%     vRep = true;
% end
if hRep && vRep
    if size(obj.H_int,1) > size(obj.V_int,1)+size(obj.R_int,1)
        hRep = false; % vRep is simpler
    else
        vRep = false; % hRep is simpler
    end
end


if hRep
    % Set containment:
    %   H(:,1:end-1)  * x <= H(:,end)
    %   He(:,1:end-1) * x == He(:,end)
    %   -inf <= x <= inf
    optMat.type = 'H';
    if ~isempty(obj.H_int)
        optMat.A  = obj.H_int(:,1:end-1);
        optMat.b  = obj.H_int(:,end);
    else
        optMat.A  = zeros(0,obj.Dim);
        optMat.b  = zeros(0,1);
    end
    if ~isempty(obj.He_int)
        optMat.Ae = obj.He_int(:,1:end-1);
        optMat.be = obj.He_int(:,end);
    else
        optMat.Ae = zeros(0,obj.Dim);
        optMat.be = zeros(0,1);
    end
    optMat.lb = -inf*ones(obj.Dim,1);
    optMat.ub =  inf*ones(obj.Dim,1);

elseif vRep
    % Set containment:
    %  [-I  V' R']   [  x]   [ 0]
    %  [ 0' 1' 0'] * [lam] = [ 1]
    %  [Ae  0  0 ]   [gam]   [be]
    %
    %  lam >= 0, gam >= 0
    %
    optMat.type = 'V';
    nV = size(obj.V_int,1); nR = size(obj.R_int,1);
    optMat.A  = zeros(0,obj.Dim+nV+nR);
    optMat.b  = zeros(0,1);
    if ~isempty(obj.He_int)
        optMat.Ae = [-eye(obj.Dim) obj.V_int' obj.R_int';...
            zeros(1,obj.Dim) ones(1,nV) zeros(1,nR);...
            obj.He_int(:,1:end-1) zeros(size(obj.He_int,1),nV+nR)];
        optMat.be = [zeros(obj.Dim,1);1;obj.He_int(:,end)];
    else
        optMat.Ae = [-eye(obj.Dim) obj.V_int' obj.R_int';...
            zeros(1,obj.Dim) ones(1,nV) zeros(1,nR)];
        optMat.be = [zeros(obj.Dim,1);1];
    end
    optMat.lb = [-inf*ones(obj.Dim,1);zeros(nV+nR,1)];
    optMat.ub = [ inf*ones(obj.Dim,1);ones(nV,1);inf*ones(nR,1)];

end

end
