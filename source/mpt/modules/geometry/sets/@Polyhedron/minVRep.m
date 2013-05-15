function obj = minVRep(obj)
% Computes minimal V-representation

% deal with arrays
if numel(obj)>1
	obj.forEach(@minVRep);
	return
end

if ~obj.hasVRep
	% automatically convert to Vrep if necessary
	obj.computeVRep();
end
if obj.irredundantVRep
	% nothing to do here
	return
end

if isempty(obj.V_int) && isempty(obj.R_int)
	% still not Vrep available, probably an empty set
	return
end

try
    s = cddmex('reduce_v', struct('V', obj.V_int, 'R', obj.R_int));
catch
    % retry with stripping to 4 decimal numbers
    V = unique(1e-4*floor(obj.V*1e4),'rows');
    s = cddmex('reduce_v', struct('V', V, 'R', obj.R_int));
end

obj.V_int = s.V;
obj.R_int = s.R;
obj.irredundantVRep = true;
% unset obj.optMat since the H-representation might have changed
obj.optMat = [];

% Lift the polyhedron to a cone
%R = [obj.R zeros(size(obj.R,1),1);obj.V ones(size(obj.V,1),1)];

% Detect if the affine hull is not Rn

%%% TODO : Do redundancy elimination via LP sequence

end
