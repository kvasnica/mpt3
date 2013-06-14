classdef BinTreePolyUnion < PolyUnion
	% Class representing memory-optimized binary search trees

	properties (SetAccess=protected)
		Tree
	end
	
	methods
		
		function obj = BinTreePolyUnion(in)
			% Constructs a memory-optimized binary search tree
			%
			% Syntax:
			%   T = BinTreePolyUnion(P)
			%
			% Inputs:
			%   P: single PolyUnion object (all sets fully dimensional)
			% Outputs:
			%   T: BinTreePolyUnion object
			%
			% The linear representation of the binary search tree is
			% available in "T.Tree" as a matrix with the following format:
			%   T.Tree(i, :) = [hp, index_left, index_right)
			%     hp: hyperplane to test
			%     index_left: next row to visit if hp*[x; -1]<=0
			%     index_right: next row to visit if hp*[x; -1]>0
			% A negative index represents a leaf node, in which case its
			% absolute value denotes index of the region which contains the
			% query point "x".
			%
			% Additional information about the tree (depth, number of
			% nodes, structure-based representation of the tree, etc.) is
			% available in "T.Internal.BinaryTree".
			%
			% Point location in binary trees is performed by
			%   [isin, inwhich] = T.contains(x)
			%
			% Note that the tree discards "outer" boundaries of regions.
			% Hence T.contains(x) always returns true even if the point
			% lies outside of the convex hull.
			%
			% Note that the tree is constructed in a recursive fashion.
			% Since Matlab imposes an upper limit on the number of
			% recursive calls, in rare circumstances an error can be
			% trigger. In that case simply increase the recursion limit and
			% re-run the tree construction.
			
			if nargin==0
				% empty constructor (used in copying)
				return
			end
			
			%% validation
			error(nargchk(1, 1, nargin));
			if ~isa(in, 'PolyUnion') || numel(in)~=1
				error('Input must be a single PolyUnion object.');
			elseif in.Num<1
				error('The input must be a non-empty PolyUnion.');
			end
			% all sets must be fully dimensional
			if ~all([in.Set.isFullDim()])
				error('All sets must be fully dimensional.');
			end

			%% set data
			% all sets must be in minimal H-representation
			in.Set.minHRep();
			% always operate on a copy of the input polyunion
			obj.Set = in.Set.copy();
			% normalize (work with the copy)
			obj.Set.normalize();
			% set internal properties
			obj.Internal = in.Internal;
			obj.Data = in.Data;
			obj.Dim = in.Dim;
			
			%% compute the tree
			obj.constructTree();
			
			% TODO: we should explicitly disallow adding new sets to the
			% polyunion, since doing so would require re-construction of
			% the tree. Same applies to any other method which modifies the
			% underlying set.
			
			% TODO: optionally include boundaries of the convex hull
			
		end
		
		function [isin, inwhich] = contains(obj, x)
			% Point location using binary search trees

			%% validation and error checks
			error(nargchk(2, 2, nargin));
			% use obj.forEach(@(u) u.contains(x)) to evaluate arrays
			error(obj.rejectArray());
			isin = false;
			inwhich = [];
			if numel(obj)==0 || ( numel(obj)==1 && obj.Num==0 )
				% empty object
				return
			end
			error(validate_vector(x, obj.Dim, 'point'));
			
			%% search
			idx = 1;
			while true
				hpx = obj.Tree(idx, 1:obj.Dim+1)*[x; -1];
				if hpx<=0
					idx = obj.Tree(idx, end-1);
				else
					idx = obj.Tree(idx, end);
				end
				if idx<0
					% reached leaf node
					isin = true;
					inwhich = -idx;
					return
				elseif idx==0
					% infeasible
					return
				end
			end
			
		end
		
		function toC(obj, function_name, file_name)
			% Exports the binary tree to a C-code
			%
			%   tree.toC('function', 'output.c')
			
			global MPTOPTIONS
			
			error(nargchk(3, 3, nargin));
			error(obj.rejectArray());

			% is the request function present?
			if ~obj.hasFunction(function_name)
				error('No such function "%s" in the object.', function_name);
			end
			% we only support affine functions for now
			if ~isa(obj.Set(1).Functions(function_name), 'AffFunction')
				error('Only affine functions are supported in this version.');
			end
			
			fun = obj.Set(1).Functions(function_name);
			out = sprintf('/* Generated on %s by MPT %s */', ...
				datestr(now), MPTOPTIONS.version);

			% read code from our template
			template_file = which('BinTreePolyUnion/mpt_searchTree.c');
			if isempty(template_file),
				error('Cannot find file "BinTreePolyUnion/mpt_searchTree.c". Check your path setup.');
			end
			template = fileread(template_file);
			
			% data of the search tree
			ST = obj.Tree'; ST = ST(:);
			out = char(out, sprintf('#define MPT_RANGE %d', fun.R));
			out = char(out, sprintf('#define MPT_DOMAIN %d', fun.D));
			out = char(out, 'static float MPT_ST[] = {');
			temp = '';
			for i = 1:length(ST),
				temp = [temp sprintf('%e,\t', ST(i))];
				if mod(i, 5)==0 || i==length(ST),
					out = char(out, temp);
					temp = '';
				end
			end
			out = char(out, '};');
			
			% data of the function
			
			% linear term
			out = char(out, 'static float MPT_F[] = {');
			for i = 1:obj.Num
				F = obj.Set(i).Functions(function_name).F;
				for j = 1:fun.R
					f = F(j, :);
					temp = '';
					for k = 1:length(f),
						temp = [temp sprintf('%e,\t', f(k))];
					end
					out = char(out, temp);
				end
			end
			out = char(out, '};');
			
			% constant term
			out = char(out, 'static float MPT_G[] = {');
			for i = 1:obj.Num,
				g = obj.Set(i).Functions(function_name).g;
				for j = 1:fun.R,
					f = g(j, :);
					temp = '';
					for k = 1:length(f),
						temp = [temp sprintf('%e,\t', f(k))];
					end
					out = char(out, temp);
				end
			end
			out = char(out, '};');

			% convert into a single string, add line breaks
			out_nl = [];
			for i = 1:size(out, 1),
				out_nl = [out_nl sprintf('%s\n', deblank(out(i, :)))];
			end
			
			% inject data into the template
			template = strrep(template, '/* placeholder, do not edit or remove!!! */', out_nl);

			% write to a file
			outfid = fopen(file_name, 'w');
			if outfid < 0,
				error('Cannot open file "%s" for writing!', file_name);
			end
			fprintf(outfid, '%s', template);
			fclose(outfid);
			fprintf('Output written to "%s".\n', file_name);
		end
		
		function display(obj)
			% Display method for BinTreePolyUnion objects
			
			% call super-class'es display() method first
			obj.display@PolyUnion();
			fprintf('Memory-optimized binary tree, depth: %d, no. of nodes: %d\n', ...
				obj.Internal.BinaryTree.depth, ...
				obj.Internal.BinaryTree.n_nodes);
		end
		
	end
	
	methods (Access=private)

		function constructTree(obj)
			% Constructs the binary search tree
			
			global MPTOPTIONS
			r_coef = MPTOPTIONS.modules.geometry.unions.BinTreePolyUnion.round_places;
			start_time = clock;
			
			% Find all unique half-spaces (remember the sets are already in
			% minimal, normalized H-representation)
			%
			% TODO: if the union is convex, we can discard outer boundaries
			% as they will never be optimal separating hyperplanes. Just do
			% not forget to add them back afterward.
			H = cat(1, obj.Set.H);
			
			% find unique "a" from a'*x<=0 and a'*x>=0
			H = round(H*10^r_coef)/10^r_coef;
			nH_orig = size(H, 1);
			H = unique(H, 'rows');
			[i, j] = ismember(H, -H, 'rows');
			idx1 = find(i==0);
			idx2 = j(j > (1:length(j))');
			H = H(unique([idx1; idx2]), :);
			nH = size(H, 1);
			fprintf('Found %d unique hyperplanes (out of %d)\n', nH, nH_orig);
			
			% Determine position of each region w.r.t. each half-space
			fprintf('Determining position of %d regions w.r.t. unique hyperplanes...\n', ...
				obj.Num);
			Neg = false(nH, obj.Num);
			Pos = false(nH, obj.Num);
			tic
			for i = 1:nH
				if toc>MPTOPTIONS.report_period
					fprintf('Progress: %d/%d\n', i, nH);
					tic
				end
				[Neg(i, :), Pos(i, :)] = obj.getPosition(H(i, :));
			end
			obj.Internal.BinaryTree.runtime.H = etime(clock, start_time);
			fprintf('...done in %.1f seconds.\n', ...
				obj.Internal.BinaryTree.runtime.H);
			
			% Discard half-spaces which are satisfied by all regions
			keep = find(sum(Pos, 2)>=1);
			fprintf('Discarding %d outer boundaries.\n', nH-length(keep));
			H = H(keep, :);
			Neg = Neg(keep, :);
			Pos = Pos(keep, :);
			fprintf('Considering %d candidates for separating hyperplanes.\n', size(H, 1));
			
			% Store the data in the object
			obj.Internal.BinaryTree.H = H;
			obj.Internal.BinaryTree.Neg = Neg;
			obj.Internal.BinaryTree.Pos = Pos;
			obj.Internal.BinaryTree.n_nodes = 0;
			obj.Internal.BinaryTree.depth = 1;
			% number of open nodes (only for progress reports)
			obj.Internal.BinaryTree.n_open = 0;
			
			% linear representation of the tree
			info = obj.emptyNode();
			obj.Internal.BinaryTree.Linear = info([]);
			
			% construct the tree
			fprintf('Constructing the tree...\n');
			tic
			start_time = clock;
			root = obj.emptyNode();
			root.hp = zeros(1, obj.Dim+1);
			root.depth = 0;
			root.parent = 0;
			root.index = 0;
			obj.Internal.BinaryTree.Tree = obj.createNode(root, 1:obj.Num);
			obj.Internal.BinaryTree.runtime.tree = etime(clock, start_time);
			fprintf('...done in %.1f seconds.\n', ...
				obj.Internal.BinaryTree.runtime.tree);

			if isempty(H)
				% trivial case: no candidates
				obj.Tree = [zeros(1, obj.Dim+1), 1, 1];
			else
				% put the tree into a matrix
				obj.Tree = zeros(length(obj.Internal.BinaryTree.Linear), ...
					obj.Dim+1+2);
				for i = 1:length(obj.Internal.BinaryTree.Linear)
					idx = obj.Internal.BinaryTree.Linear(i).index;
					obj.Tree(idx, :) = [ obj.Internal.BinaryTree.Linear(i).hp, ...
						obj.Internal.BinaryTree.Linear(i).left, ...
						obj.Internal.BinaryTree.Linear(i).right ];
				end
			end
			
			fprintf('Depth: %d, no. of nodes: %d\n', ...
				obj.Internal.BinaryTree.depth, ...
				obj.Internal.BinaryTree.n_nodes);
		end

		function [negative, positive] = getPosition(obj, hp)
			% Determines location of regions w.r.t. hyperplane hp*[x; -1]=0:
			%  negative(i)=1 if the i-th region has full-dimensional
			%                intersection with {x | hp*[x; -1] <= 0}
			%  positive(i)=1 if the i-th region has full-dimensional
			%                intersection with {x | hp*[x; -1] >= 0}
			
			% TODO: exploit nested half-spaces, i.e., if { x | a*x<=b }
			% \subset { x | c*x<=d }, then any region on the negative side
			% of "a, b" will also be on the negative side of "c, d".
			negative = false(1, obj.Num);
			positive = false(1, obj.Num);
			for i = 1:obj.Num
				if fast_isFullDim([obj.Set(i).H; hp])
					% intersection with {x | hp*[x; -1]<=0}
					negative(i) = true;
				end
				if fast_isFullDim([obj.Set(i).H; -hp])
					% intersection with {x | hp*[x; -1]>=0}
					positive(i) = true;
				end
			end
			
		end
		
		function new = createNode(obj, node, Idx)
			% Creates a node of the binary search tree
			
			global MPTOPTIONS
			
			if isempty(Idx)
				% no more regions, terminate this branch
				new = [];
				return
			end

			obj.Internal.BinaryTree.n_open = obj.Internal.BinaryTree.n_open+1;
			
			% report from time to time
			if toc>MPTOPTIONS.report_period
				tic
				fprintf('Progress: depth: %d, no. of nodes: %d, open: %d\n', ...
					obj.Internal.BinaryTree.depth, ...
					obj.Internal.BinaryTree.n_nodes, ...
					obj.Internal.BinaryTree.n_open);
			end
			
			% Select the best hyperplane, i.e., the one which minimizes the
			% maximal number of splitted regions
			D = Inf(size(obj.Internal.BinaryTree.Neg, 1), 1);
			for i = setdiff(1:size(D, 1), abs(node.hps))
				% regions on the negative side of each hyperplane
				NegIdx = intersect(find(obj.Internal.BinaryTree.Neg(i, :)), Idx);
				PosIdx = intersect(find(obj.Internal.BinaryTree.Pos(i, :)), Idx);
				% fitness of the i-th hyperplane
				D(i) = max(numel(NegIdx), numel(PosIdx));
			end
			% which hyperplane is the best cut?
			[~, BestIdx] = min(D(:, 1));

			% Find which regions are on the left and on the right of the best
			% hyperplane
			NegIdx = intersect(find(obj.Internal.BinaryTree.Neg(BestIdx, :)), Idx);
			PosIdx = intersect(find(obj.Internal.BinaryTree.Pos(BestIdx, :)), Idx);
			if MPTOPTIONS.verbose>0
				fprintf('\n Idx: %s\n', mat2str(Idx));
				fprintf('-Idx: %s\n', mat2str(NegIdx));
				fprintf('+Idx: %s\n', mat2str(PosIdx));
			end

			% create a new node
			new = obj.emptyNode();
			new.hp = obj.Internal.BinaryTree.H(BestIdx, :);
			new.hps = node.hps;
			new.parent = node.index;
			new.depth = node.depth+1;
			new.index = obj.Internal.BinaryTree.n_nodes+1;

			% update tree status
			obj.Internal.BinaryTree.n_nodes = obj.Internal.BinaryTree.n_nodes+1;
			obj.Internal.BinaryTree.depth = max(obj.Internal.BinaryTree.depth, new.depth);

			% which regions are on the negative side of the hyperplane?
			if numel(NegIdx)==1
				% single region = leaf node
				new.left = NegIdx;
			elseif numel(NegIdx)>1
				% multiple regions = split this node
				new_neg = new;
				new_neg.hps = [new_neg.hps; -BestIdx];
				new.left = obj.createNode(new_neg, NegIdx);
			else
				% empty on the left
				new.left = 0;
			end
			
			% which regions are on the positive side of the hyperplane?
			if numel(PosIdx)==1
				% single region = leaf node
				new.right = PosIdx;
			elseif numel(PosIdx)>1
				% multiple regions = split this node
				new_pos = new;
				new_pos.hps = [new_pos.hps; BestIdx];
				new.right = obj.createNode(new_pos, PosIdx);
			else
				% empty on the right
				new.right = 0;
			end
			
			% update the linear structure of the tree
			linear = obj.emptyNode();
			linear.index = new.index;
			linear.hp = new.hp;
			linear.hps = new.hps;
			linear.depth = new.depth;
			linear.parent = new.parent;
			if isstruct(new.left)
				linear.left = new.left.index;
			else
				linear.left = -new.left;
			end
			if isstruct(new.right)
				linear.right = new.right.index;
			else
				linear.right = -new.right;
			end
			obj.Internal.BinaryTree.Linear(end+1) = linear;
			obj.Internal.BinaryTree.n_open = obj.Internal.BinaryTree.n_open-1;
			
		end
	end
	
	methods (Static, Hidden)
		
		function N = emptyNode()
			% Creates an empty node structure
			
			N = struct('hp', [], 'hps', [], ...
				'depth', 0, 'parent', 0, 'index', 0, ...
				'left', [], 'right', []);
		end
	end
	
end

