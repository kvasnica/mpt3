function [isin, inwhich, closest] = isInside(Pn, x0, Options)
%
% Containment test for H-polyhedron (automatically replaced by
% isInside.mex if it exists).
%

global MPTOPTIONS

if nargin<3
	Options = [];
end
if ~isfield(Options, 'fastbreak')
	Options.fastbreak = false;
end
if ~isfield(Options, 'abs_tol')
	Options.abs_tol = MPTOPTIONS.abs_tol;
end

inwhich = [];
closest = [];
for i = 1:length(Pn)
	if ~Pn(i).hasHRep
		% H-rep is required
		Pn(i).computeHRep();
	end
	if any(Pn(i).H_int*[x0; -1] > Options.abs_tol)
		% not in the inequality Hrep
	elseif ~isempty(Pn(i).He_int) && ...
			any(abs(Pn(i).He_int*[x0; -1]) > Options.abs_tol)
		% not in the equality Hrep
	else
		inwhich = [inwhich i];
		if Options.fastbreak
			isin = true;
			return
		end
	end
end

isin = ~isempty(inwhich);
if ~isin && nargout==3
	closest = closestRegion(Pn, x0);
end

end
