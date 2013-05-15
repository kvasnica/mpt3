function U = merge(obj, FuncName)
%MERGE merges polyhedra together 
%
%  merge(U)
%  U.merge
%
% ---------------------------------------------------------------------------
% DESCRIPTION
% ---------------------------------------------------------------------------
% Uses greedy merging to join regions.
%
% ---------------------------------------------------------------------------
% INPUT
% ---------------------------------------------------------------------------
% U  - PolyUnion object
%
% ---------------------------------------------------------------------------
% OUTPUT                                                                                                    
% ---------------------------------------------------------------------------
% U               - merged PolyUnion
%
% see also MPT_GREEDYMERGING, MPT_OPTMERGE
%
% GREEDY MERGING
% Comments:     The algorithm tries to merge as many of the given polyhedra as 
%               possible using a greedy approach. The algorithm cycles through 
%               the regions and checks if any two regions form a convex union.
%               If so, the algorithm combines them in one region, and continues
%               checking the remaining regions.
%               To improve the solution, multiple merging loops are enabled
%               by default.
%               To reduce the problem of getting stuck in local minima, several 
%               trials can be used until the solution is not improved.
%
% Author:       Tobias Geyer
%                                                                       
% History:      date        subject                                       
%               2004.01.16  initial version based on mb_reducePWA by Mato Baotic
%               2004.05.06  debugged, comments added
%
% Copyright is with the following author(s):
% 
% 2012 Revised by Martin Herceg, Automatic Control Laboratory, ETH Zurich
%
% (C) 2007 Michal Kvasnica, Slovak University of Technology in Bratislava
%          michal.kvasnica@stuba.sk
% (C) 2005 Frank J. Christophersen, Automatic Control Laboratory, ETH Zurich,
%          fjc@control.ee.ethz.ch
% (C) 2005 Tobias Geyer, Automatic Control Laboratory, ETH Zurich,
%          geyer@control.ee.ethz.ch
% (C) 2004 Michal Kvasnica, Automatic Control Laboratory, ETH Zurich,
%          kvasnica@control.ee.ethz.ch
%
% ---------------------------------------------------------------------------
% Legal note:
%          This program is free software; you can redistribute it and/or
%          modify it under the terms of the GNU General Public
%          License as published by the Free Software Foundation; either
%          version 2.1 of the License, or (at your option) any later version.
%
%          This program is distributed in the hope that it will be useful,
%          but WITHOUT ANY WARRANTY; without even the implied warranty of
%          MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%          General Public License for more details.
% 
%          You should have received a copy of the GNU General Public
%          License along with this library; if not, write to the 
%          Free Software Foundation, Inc., 
%          59 Temple Place, Suite 330, 
%          Boston, MA  02111-1307  USA
%
% ---------------------------------------------------------------------------

global MPTOPTIONS
if isempty(MPTOPTIONS)
    MPTOPTIONS = mptopt;
end

if nargin<2
	FuncName = [];
end

Options.trials = MPTOPTIONS.modules.geometry.unions.polyunion.merge.trials;

% deal with arrays
if numel(obj)>1
    parfor i=1:numel(obj)
		if nargout==0
			obj(i).merge;
		else
			U(i) = obj(i).merge;
		end
    end
    return;
end

if nargout==0
	% no outputs = in-place merging
	U = obj;
else
	% output requested = do not modify the source object
	U = obj.copy;
end

% if there is 0 or 1 set contained, return
if U.Num<=1
    return
end

funs = U.listFunctions;
if isempty(FuncName) && ~isempty(funs)
	% If functions are attached, the only sane behavior is to expect that
	% we want to merge regions in which certain function has indentical
	% expressions.
	%
	% If you want to merge regions while disregarding functions, you can
	% achieve this as follows:
	%
	% N = merge(removeAllFunctions(copy(U)));
	
	error('Function name must be specified.');

elseif ~isempty(FuncName)
	% We are going to merge against a specified function.
	
	Rmerged = [];
	
	% Get list of regions in which the function has the same expression
	[uF, uMap] = U.Set.uniqueFunctions(FuncName);
	if MPTOPTIONS.verbose >= 0
		fprintf('%d regions with %d unique functions.\n', U.Num, length(uF));
	end
	for i = 1:length(uF)
		% For each subset of "identical" regions, create a new union and
		% merge it
		regions = find(uMap==i);
		R = U.Set(regions);
		if MPTOPTIONS.verbose >= 0
			nbefore = length(R);
			fprintf('Function #%d: %d -> ', i, nbefore);
		end
		if length(R)>1
			% Make a copy of the regions, since we are going to remove
			% functions
			Ui = PolyUnion(Polyhedron(R));

			% To prevent PolyUnion/reduce from determining overlapping
			% status, we copy the information already provided to us.
			Ui.Internal.Overlaps = U.Internal.Overlaps;
			
			% Remove all functions, since the pure merge() code introduces
			% new regions, but does not automatically attach functions to
			% them.
			Ui.removeAllFunctions;
			Ui.merge;
			R = Ui.Set;
			% Reattach functions
			for j = 1:numel(R)
				% Note that all functions but "FuncName" are meaningless
				% after merging.
				R(j).copyFunctionsFrom(U.Set(regions(1)));
				% Replace the main function
				R(j).addFunction(uF(i), FuncName);
			end
		end
		Rmerged = [Rmerged R];
		if MPTOPTIONS.verbose >= 0
			nafter = length(R);
			if nafter < nbefore
				fprintf('%d (reduction by %d)\n', nafter, nbefore-nafter);
			else
				fprintf('%d\n', nafter);
			end
		end
	end
	if MPTOPTIONS.verbose >= 0
		fprintf('Reduction by %.0f%% from %d to %d regions.\n', ...
			(U.Num-length(Rmerged))/U.Num*100, U.Num, length(Rmerged));
	end
	U.Set = Rmerged;
	return
end

% try to reduce the union first
U.reduce;

% regions must be in H-rep (because of set-difference involved in testing of convexity)
% parfor i=1:U.Num
%     U.Set(i).minHRep();
% end

% compute list of neighbours
Ri.BC = sub_buildBClist(U.Set);
% store polyhedra inside Ri
Ri.Pn = U.Set;
% put the total number of polyhedra inside Ri
Ri.nR = U.Num;

% initialize the current best solution
Ri_best.nR = inf;
Ri_min = inf; Ri_max = 0;

% loop of trials
trial = 1;
while trial <= Options.trials
    if MPTOPTIONS.verbose>=2,
        fprintf('Trial %i/%i:\n', trial, Options.trials); 
    elseif MPTOPTIONS.verbose>=1,
        fprintf('Trial %i/%i: %i\n', trial, Options.trials, Ri.nR);
    end
    Ri_mer = sub_merge(Ri);
    if MPTOPTIONS.verbose>=1,
        fprintf(' --> %i', Ri_mer.nR); 
    end
    
    % update minimum and maximum
    Ri_min = min(Ri_min, Ri_mer.nR);
    Ri_max = max(Ri_max, Ri_mer.nR);
    if Ri_mer.nR < Ri_best.nR
        Ri_best = Ri_mer;
        trial = trial + 1;
        if MPTOPTIONS.verbose>=1,
            fprintf(' (new minimum)\n'); 
        end
    else
        trial = trial + 1;
        if MPTOPTIONS.verbose>=1,
            fprintf('\n'); 
        end
    end;
    if Ri_min<=1,
        break
    end
end;

U.Set = Ri_best.Pn;

if MPTOPTIONS.verbose>=1,
    fprintf('  ==> min: %i  max: %i\n', Ri_min, Ri_max');
end



end

%-----------------------------------------------------------------------
function Ri = sub_merge(Ri)

global MPTOPTIONS

% start the trial with the permutation K
iterateAgain = 1;
iter = 0;
while iterateAgain
        
    iterateAgain = 0;
    iter = iter+1;
    if MPTOPTIONS.verbose>=1, 
        fprintf('  iteration %i: merging %i --> ', iter, Ri.nR); 
    end;

    % indicators whether region k has been (1) included in some union or not (0)
    issorted=zeros(Ri.nR,1);
    newRi.nR=0;
    newRi.Pn = [];
    
    % find a random permutation of the indices (of polyhedra)
    K = randperm(Ri.nR);

    old2new = K;
    for k = K
        
        Pc = Ri.Pn(k);
        BCc=setdiff(Ri.BC{k},0);
        changed=0;
        if issorted(k)
            continue;
        end
        firstloop=1;
        while firstloop || changed
            firstloop=0;
            changed=0;
            BCc_old=BCc;
            BCc_old=BCc_old(randperm(length(BCc_old))); % permute BBc_old
            for ind_l=1:length(BCc_old), %1:Ri.nR
                ind2=BCc_old(ind_l);

                if(ind2==k || issorted(ind2))
                    continue;
                end
                
                PU = PolyUnion([Pc, Ri.Pn(ind2)]);
                how = PU.isConvex;
                %[Pu,how] = union([Pc Ri.Pn(ind2)],Options);
                if how
                    Pc = PU.Internal.convexHull;
                    BCc=union(BCc, setdiff(Ri.BC{ind2},0));
                    if MPTOPTIONS.verbose>=2,
                        disp(['regions ' num2str([k ind2]) ' are joined']);
                    end;
                    issorted(ind2)=1;
                    old2new(ind2)=newRi.nR+1;
                    changed=1;
                    iterateAgain = 1;
                end
            end
        end
        newRi.nR=newRi.nR+1;
        old2new(k)=newRi.nR;
        newRi.Pn = [newRi.Pn Pc];
        newRi.BC{newRi.nR}=BCc;
        issorted(k)=1;
    end
    for i=1:newRi.nR
        newRi.BC{i}=unique(old2new(newRi.BC{i}));
    end

    if MPTOPTIONS.verbose>=1,
        percent = (Ri.nR-newRi.nR)/Ri.nR * 100;
        fprintf('%i (%2.1f percent)\n', newRi.nR, percent);
    end;

    Ri = newRi;
    clear newRi;

end;


end

%-----------------------------------------------------------------------
function BC = sub_buildBClist(Pn)
% Inputs:  array of polyhedra in the same dimension
%
% Outputs: BC: list of neighbours

global MPTOPTIONS
nR = length(Pn);

if MPTOPTIONS.verbose>=1
    fprintf('Computing list of neighbors...\n');
end

% M(i, j)=1 means that Pn(i) and Pn(j) are adjacent
M = zeros(nR);
for i = 1:nR-1
	for j = i+1:nR
		if ~M(i,j) && ~M(j,i)
			if Pn(i).isAdjacent(Pn(j));
				M(i,j)=1;
				M(j,i)=1;
			end
		end
	end
end

BC = cell(1,nR);
for i = 1:nR
	BC{i} = find(M(i, :));
end

end
