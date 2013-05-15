function out = min(PUs, func, coefficient)
% Minimum of PolyUnions 'inPUs' using function 'func'
%
% This function is basically MPT3 implementation of mpt_removeOverlaps.%
%
% If coefficient=-1, this function picks the maximum instead of the minimum

% Note: This is a slow, but compact implementation.

global MPTOPTIONS
if isempty(MPTOPTIONS)
	MPTOPTIONS = mptopt;
end

if numel(PUs)<2
	% TODO: support single polyunion with overlapping regions
	if PUs.isOverlapping
		error('Single polyunion with overlapping regions not yet supported.');
	else
		out = PUs;
	end
	return
end

if nargin < 2 || isempty(func)
	% if no function is specified, take the first one
	if length(PUs(1).listFunctions)>1
		error('Please specify which function to use for comparison.');
	else
		fnames = PUs(1).listFunctions;
		func = fnames{1};
	end
end

if ~PUs(1).hasFunction(func)
	error('Couldn''t find function "%s".', func);
end

% make sure all other polyunions define the function
for i = 2:length(PUs)
	if ~PUs(i).hasFunction(func)
		error('Polyunion #%d must define function "%s".', i, func);
	end
end


if nargin<3
	% coefficient=1 means we are looking for the maximum
	% coefficient=-1 will search for the maximum
	coefficient = 1;
end

% TODO: make sure all regions are in H-representation
%code goes here

% make sure that the comparing function is PWA
if ~isa(PUs(1).Set(1).getFunction(func), 'AffFunction')
	% TODO: extend this check to all regions of all polyunions
	error('Only PWA functions can be used for comparison.');
end

nR = 0;
Pfinal = []; % list of regions

for ipart = 1:numel(PUs)

	% list of regions in which the function is better than in the
	% 'ipart/ireg' region
	better_regions = [];

	fprintf('Union %d (out of %d)...\n', ipart, numel(PUs));

	for ireg = 1:numel(PUs(ipart).Set)

		%fprintf('Union %d (out of %d), region %d (out of %d)...\n', ...
		%	ipart, numel(PUs), ireg, numel(PUs(ipart).Set));
		
		for jpart = setdiff(1:numel(PUs), ipart)
		
			for jreg = 1:numel(PUs(jpart).Set)
				
				% do the regions intersect?
				Q = PUs(ipart).Set(ireg).intersect(PUs(jpart).Set(jreg));
				if Q.isFullDim
					% compare function in the intersection
					
					ifun = PUs(ipart).Set(ireg).getFunction(func);
					jfun = PUs(jpart).Set(jreg).getFunction(func);
					Fj = jfun.F;
					gj = jfun.g;
					Fi = ifun.F;
					gi = ifun.g;
					
					% allow to compute maximum by setting coeffcient=-1
					Fdiff = coefficient*(Fj-Fi);
					gdiff = coefficient*(gj-gi);

					include_Q = false;
					if norm(Fdiff)+norm(gdiff) <= MPTOPTIONS.abs_tol
						% function is identical in both regions
						if ipart < jpart
							% this makes sure that we remove only one such
							% region 
							include_Q = true;
						end
						
					else
						% functions are different, find which part of
						% region 'ireg' has the smaller function values
						
						% TODO: correcly compare piecewise constant
						% functions (probably requires lifting)
						if norm(Fj)<=MPTOPTIONS.zero_tol && ...
								norm(Fi)<=MPTOPTIONS.zero_tol
							% lift by one dimension to deal with constant
							% cost
							infbox = Polyhedron('lb', 0, ...
								'ub', MPTOPTIONS.infbound);
							Ireg = PUs(ipart).Set(ireg)*infbox;
							Jreg = PUs(jpart).Set(jreg)*infbox;
							Qreg = Ireg.intersect(Jreg);
							if ~Qreg.isFullDim
								error('Regions should intersect.');
							end
							Q = Polyhedron('H', [Qreg.H; Fdiff gdiff 0], 'He', Qreg.He);
							if Q.isFullDim
								Q = Q.projection(1:Q.Dim-1).minHRep();
								include_Q = true;
							end
						else
							Q = Polyhedron('H', [Q.H; Fdiff -gdiff], 'He', Q.He);
							if Q.isFullDim
								% the dominating subregion is fully
								% dimensional, include it
								include_Q = true;
							end
						end
						
					end
					
					if include_Q
						better_regions = [better_regions Q];
					end

				end % non-empty intersection
				
			end % jreg
			
		end % jpart
		
		if numel(better_regions) > 0
			% get all subregions of 'ireg' where the function is minimal
			
			Ri = PUs(ipart).Set(ireg) \ better_regions;
			
			if ~Ri.isFullDim
				% If the set difference is empty, the other regions with lover
				% function values are covering 'ireg'. 
				continue
				
			else
				% Otherwise we add all subregions of Ri

				% TODO: Polyhedron/mldivide should keep the
				% functions

				% make a copy before removing functions, otherwise
				% PUs(ipart).Set(ireg) could be affected
				Ri = Polyhedron(Ri);
				Ri.removeAllFunctions();
				for mm = 1:numel(Ri)
					if Ri(mm).isFullDim
						% we keep this region
						nR = nR+1;
						% copy all function from PUs(ipart).Set(ireg)
						Ri(mm).copyFunctionsFrom(PUs(ipart).Set(ireg));
					end
				end
				Pfinal = [Pfinal Ri];
			end

		else
			nR = nR+1;
			Pfinal = [Pfinal PUs(ipart).Set(ireg)];
		end
		
	end % ireg

end % ipart

if isa(Pfinal, 'double') && isempty(Pfinal)
	out = PolyUnion;
else
	out = PolyUnion('Set', Pfinal', 'overlaps', false);
end
