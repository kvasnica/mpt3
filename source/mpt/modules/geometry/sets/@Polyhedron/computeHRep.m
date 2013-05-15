function obj = computeHRep(obj)
% V-to-H conversion with possibly redundant H-rep output

global MPTOPTIONS

% deal with arrays
if numel(obj)>1
	if nargout==0
		obj.forEach(@computeHRep);
	else
		obj = obj.forEach(@computeHRep);
	end
	return
end

if obj.hasHRep
	% nothing to do
	return
elseif ~obj.hasVRep
	% empty set
	obj.hasHRep = true;
	return
end

% compute Hrep
try
	% Do facet enumeration with CDD
	s = cddmex('hull', ...
		struct('V', obj.V_int, 'R', obj.R_int));
catch
	% if CDD fails, retry with matlab version
	[s.V,s.R,s.A,s.B] = mpt_nlrs('hull', obj);
	s.lin = [];
end
Hall  = [s.A s.B];
H = Hall; H(s.lin, :) = [];
He = Hall(s.lin, :);
H(matNorm(H(:, 1:end-1)) < MPTOPTIONS.zero_tol, :) = [];
He(matNorm(He(:, 1:end-1)) < MPTOPTIONS.zero_tol, :) = [];
obj.H_int = H;
obj.He_int = He;
obj.hasHRep = true;

% unset obj.optMat since the H-representation might have changed
obj.optMat = [];

end
