function q = projection(P, dims, method, solver)
% <matDoc>
% <funcName>Projection</funcName>
% <shortDesc>
% Compute the projection of this polyhedron.</shortDesc>
% <longDesc/>
%
% <syntax>
% <desc>Compute the projection of this polyhedron.
%
% Q = proj(P) = {x | exists y, (x,y) in P}
%
% </desc>
% <input name='dims'>Dimensions to project the polyhedron onto</input>
% <input name='method'>Method used to compute projection of Hrep
% . fourier : Use fourier elimination. Good if projecting off a
% .           small number of dimensions. Projection will be
% .           highly redundant (use q.minHRep() to get
% .           irredundant form).
% . mplp    : Use mplp algorithm to compute projection. Good if
% .           the projection is not very degenerate (dimensions
% .           of projected facets are equal to the faces that
% .           they were projected from)
% . vrep    : Compute vertex representation and then project
% </input>
% <output name='q'>Projection of this polyhedron onto dims</output>
% </syntax>
%
% </matDoc>


global MPTOPTIONS
if isempty(MPTOPTIONS)
	MPTOPTIONS = mptopt;
end

% Choose fourier elimination if we're projecting off less than this number
% of dimensions
DELTA_DIMS_CHOOSE_FOURIER = 3;

if nargin < 3, method = ''; solver = ''; end
if nargin < 4, solver = ''; end

% deal with arrays
no = numel(P);
if no>1
	q(size(P)) = Polyhedron;
	parfor i=1:no
		q(i) = P(i).projection(dims, method, solver);
	end
	return;
end

% check dimensions
for i=1:numel(dims)
	validate_dimension(dims(i));
end
% no dimensions or no projection, copy the polyhedron
if isempty(dims) || isequal(dims, 1:P.Dim)
	q = Polyhedron(P);
	return;
end
if any(dims>P.Dim)
	mpt_kblink(2); % provide the ID of the corresponding KB article
	error('Cannot compute projection on higher dimension than %i.', P.Dim);
end

if P.isEmptySet,
	q = Polyhedron.emptySet(length(dims));
	return;
elseif P.isFullSpace()
	q = Polyhedron.fullSpace(length(dims));
	return
end

% Compute projection of the polyhedron

if P.hasVRep
	% Easy way - V-rep
	q = Polyhedron('V', P.V(:,dims), 'R', P.R(:,dims));
else
	
	% Hard way - inequality rep
	if nargin < 3 || isempty(method) % No method specified
		% choose based on properties of P
		if P.Dim <= 4
			% this call can be problematic due to computations of vertices in CDD,
			%method = 'vrep';
			method = 'fourier';
		elseif P.Dim - length(dims) <= DELTA_DIMS_CHOOSE_FOURIER
			method = 'fourier';
		else
			method = 'mplp';
		end
		
	end
	
	%%
	if size(P.He,1) > 0
		% Use the affineMap function, which will convert into a projection of a
		% full-dimensional polyhedron and call back to here
		T = zeros(length(dims),P.Dim);
		for i=1:length(dims)
			T(i,dims(i)) = 1;
		end
		q = P.affineMap(T, method);
	else
		% shift polyhedron to origin for better numerics
		xc = P.chebyCenter;
		if xc.exitflag == MPTOPTIONS.OK
			Pn = P - xc.x;
		else
			Pn = Polyhedron(P);
		end
		
		% We can now safely assume that He is empty
		switch lower(method)
			
			case 'vrep'
				% Enumerate vertices and project
				Pn.minVRep();
				q = projection(Pn, dims);
				q.minHRep(); % return H-rep, because the entry was in H
				
			case 'fourier'
				Pn.minHRep(); % Redundancy elimination
				Hn = fourier(Pn.H,dims);
				if isempty(Hn)
					% polyhedron is full R^P.dim
					q = Polyhedron('H',zeros(1,numel(dims)+1));
				else
					q = Polyhedron(Hn(:, 1:end-1), Hn(:, end));
				end
				
				
			case 'mplp'
				% On Polyhedral Projection and Parametric Programming
				%  by C.N. Jones, E.C. Kerrigan and J.M. Maciejowski
				%  J Optim Theory Appl (2008) 138: 207?220
				%  DOI 10.1007/s10957-008-9384-4
				
				% Shift P to contain the origin
				%         ip = P.interiorPoint;
				%         if ~ip.isStrict, error('Polyhedron should have a non-empty interior at this point in the code'); end
				if any(Pn.b < -MPTOPTIONS.abs_tol)
					error('HAVE NOT IMPLEMENTED PROJECTION FOR POLYHEDRON THAT DO NOT CONTAIN THE ORIGIN YET');
				end
				
				D = Pn.A; C = D(:,dims); D(:,dims) = [];
				d = size(C,2); k = size(D,2); n = size(C,1);
				
				% Setup parametric problem whose cost is the projection
				%dat = Opt;
				%dat.A  = [D -P.b];
				%dat.b  = zeros(n,1);
				%dat.pB = -C;
				%dat.f  = [zeros(k,1);1];
				%dat.Ath = [eye(d);-eye(d)];
				%dat.bth = ones(2*d,1);
				if isempty(solver)
					dat = Opt('A',[D -Pn.b],'b', zeros(n,1), 'pB',-C,'f',[zeros(k,1);1], 'Ath',[eye(d); -eye(d)], 'bth', ones(2*d,1));
				else
					% in case MPQP solver is provided, solve MPLP instead
					if strcmpi(solver,'MPQP')
						dat = Opt('A',[D -Pn.b],'b', zeros(n,1), 'pB',-C,'f',[zeros(k,1);1], 'Ath',[eye(d); -eye(d)], 'bth', ones(2*d,1),'solver', 'MPLP');
					else
						dat = Opt('A',[D -Pn.b],'b', zeros(n,1), 'pB',-C,'f',[zeros(k,1);1], 'Ath',[eye(d); -eye(d)], 'bth', ones(2*d,1),'solver', solver);
					end
				end
				
				sol = dat.solve;
				
				% The normals of the facets is the cost function
				A = zeros(sol.xopt.Num,sol.xopt.Set(1).Dim);
				for i=1:sol.xopt.Num
					objfun = sol.xopt.Set(i).getFunction('obj');
					A(i,:) = objfun.F;
				end
				q = Polyhedron(A,ones(size(A,1),1));
				
			otherwise
				error('Supported methods are "vrep", "fourier", and "mplp".');
		end
		
		% shift back to original coordinates
		if xc.exitflag == MPTOPTIONS.OK
			q = q+xc.x(dims);
		end
		
	end
end

end
