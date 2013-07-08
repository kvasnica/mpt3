function vol = volume(P)
%
% Compute the volume of this polyhedron.<p>
% 
% Volume is infinite if the polyhedron is unbounded and zero if it's not full-dimensional.
% 
% @return volume
%
  
% deal with arrays
no = numel(P);
if no>1
    vol = zeros(size(P));
    parfor i=1:no
        vol(i) = P(i).volume;
    end
    return;
end

% check boundedness
if ~P.isBounded
    vol = inf;
    return
end

% check emptyness and full-dimensionality
if P.isEmptySet || ~P.isFullDim
    vol = 0;
    return;
end

% Use built-in convhulln to compute volume
P.minVRep();
if P.Dim==1
	% issue #71: we need to handle 1D cases manually
	vol = max(P.V) - min(P.V);
else
	[~, vol] = convhulln(P.V);
end

end
