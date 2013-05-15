function H = convexHull(U)
%
% computes convex hull for union of polyhedra in the same dimension
%

global MPTOPTIONS
if isempty(MPTOPTIONS)
    MPTOPTIONS = mptopt;
end

% deal with arrays
if numel(U)>1
    H(size(U)) = Polyhedron;
    parfor i=1:numel(U)
        H(i) = U(i).convexHull;
    end
    return;
end

% if there is 0 or 1 set contained, return
if U.Num==0
    H = Polyhedron;
    return
elseif U.Num==1
    H = Polyhedron(U.Set);
    return
end


if ~isfield(U.Internal,'convexHull') || isempty(U.Internal.convexHull)
    % compute the convex hull
	Vn=[];
	Rn=[];
	for i=1:U.Num
		if ~U.Set(i).hasVRep
			% if object is in H-rep, convert it to V
			U.Set(i).computeVRep();
		end
		Vn = [Vn; U.Set(i).V];
		Rn = [Rn; U.Set(i).R];
	end
	
	% construct one polyhedron
	H = Polyhedron('V',Vn,'R',Rn);
	
	% irredundant Vrep
	H.minVRep();
	
	% irredundant Hrep
	H.minHRep();
    
    % store internally
    U.Internal.convexHull = H;
else    
    H = U.Internal.convexHull;
end


end
