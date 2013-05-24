function aff = affineHull(P)
% Compute the affine hull
%

global MPTOPTIONS
if isempty(MPTOPTIONS)
    MPTOPTIONS = mptopt;
end

% use P.forEach() for arrays
error(P.rejectArray());

%aff = [];

% if P.isEmptySet,
%     return;
% end

if P.hasVRep
    % Lift to a cone and compute affine set
    R = [P.V ones(size(P.V,1),1);P.R zeros(size(P.R,1),1)];
    aff = null(R)'; aff(:,end) = -aff(:,end);
else
    % Assume that the affine hull is more restrictive than He, and re-compute
    
    % Test if He is the affine hull
    if P.interiorPoint.isStrict,
        aff = P.He;
        return;
    end
    
    % Relax all constraints and test one-by-one
    H = P.H; He = P.He;
    while 1
        done = true;
        for i = 1:size(H,1)
            Htmp = H;
            
            % Relax i+1:end constraints to make the polyhedron full-dim
            Htmp(i+1:end,end) = Htmp(i+1:end,end) + 1;
            
            % Test if the result is full-dimensional
            PT = Polyhedron('He', He, 'H', Htmp);
            ip = PT.interiorPoint;
            
            if ip.r < MPTOPTIONS.abs_tol
                % This constraint cannot be tightened => it's part of the affine hull
                He = [He;H(i,:)];
                H(i,:) = [];
                done = false;
                break
            end
        end
        if done, break; end
    end
    
    % Compute a min-rep of the affine hull of this polyhedron
    Q = Polyhedron('H', H, 'He', He);
    aff = Q.He;
end
end
