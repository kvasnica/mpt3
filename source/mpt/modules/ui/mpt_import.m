function out = mpt_import(varargin)
%
% imports sysStruct/probStruct/mptctrl/polytope objects from MPT 2.6
%

if nargin==1 && isstruct(varargin{1})
	% import from sysStruct
	out = importSysStruct(varargin{1});

elseif nargin==2 && isstruct(varargin{1}) && isstruct(varargin{2})
    % import sysStruct
    
	sysStruct = varargin{1};
	probStruct = varargin{2};
	
	[sysStruct, probStruct] = mpt_verifySysProb(sysStruct, probStruct);
	out = importSysStruct(sysStruct);
	
	if isfield(probStruct, 'tracking') && probStruct.tracking > 0
		error('Tracking problems not yet supported.');
	end
	if iscell(probStruct.Q) || iscell(probStruct.R)
		error('Time varying penalty matrices not yet supported.');
	end
	if isfield(probStruct, 'Qd')
		error('probStruct.Qd cannot be imported automatically.');
	end
	if isfield(probStruct, 'Qz')
		error('probStruct.Qz cannot be imported automatically.');
	end
	if isfield(probStruct, 'dref')
		error('probStruct.dref cannot be imported automatically.');
	end
	if isfield(probStruct, 'zref')
		error('probStruct.zref cannot be imported automatically.');
	end
	
	% add penalties
	out.u.penalty = Penalty(probStruct.R, probStruct.norm);
	if isfield(probStruct, 'Qy')
		out.y.penalty = Penalty(probStruct.Qy, probStruct.norm);
	else
		out.x.penalty = Penalty(probStruct.Q, probStruct.norm);
	end
	
	% custom settings
	if ~iscell(sysStruct.A) && isfield(probStruct, 'Tconstraint') && ...
			probStruct.Tconstraint==1 && probStruct.norm==2
		% add LQR terminal set/penalty for LTI systems with 2-norm cost
		fprintf('Computing LQR terminal set and penalty:\n');
		S = out.LQRSet();
		P = out.LQRPenalty();
		out.x.with('terminalPenalty');
		out.x.terminalPenalty = P;
		out.x.with('terminalSet');
		out.x.terminalSet = S;
	elseif ~isfield(probStruct, 'Qy') && probStruct.Tconstraint==1
		% add terminal state penalty to be consistent with MPT2
		out.x.with('terminalPenalty');
		out.x.terminalPenalty = Penalty(probStruct.Q, probStruct.norm);
	end

	if isfield(probStruct, 'Nc')
		out.u.with('controlHorizon');
		out.u.block.from = probStruct.Nc;
		out.u.block.to = obj.N;
	end
	if isfield(probStruct, 'P_N')
		if ~out.x.hasFilter('terminalPenalty')
			out.x.with('terminalPenalty');
		end
		out.x.terminalPenalty = Penalty(probStruct.P_N, probStruct.norm);
	end
	if isfield(probStruct, 'Tset') && isfulldim(probStruct.Tset)
		out.x.with('terminalSet');
		out.x.terminalSet = Polyhedron('H', double(probStruct.Tset));
	end
	if isfield(probStruct, 'xref')
		out.x.with('reference');
		out.x.reference = probStruct.xref;
	end
	if isfield(probStruct, 'uref')
		out.u.with('reference');
		out.u.reference = probStruct.uref;
	end
	if isfield(probStruct, 'yref')
		out.y.with('reference');
		out.y.reference = probStruct.yref;
	end
	
	% soft state constraints
	if isfield(probStruct, 'Sx') && isfield(probStruct, 'sxmax')
		out.x.with('softMax');
		out.x.with('softMin');
		out.x.softMax.penalty = Penalty(probStruct.Sx, probStruct.norm);
		out.x.softMin.penalty = Penalty(probStruct.Sx, probStruct.norm);
		out.x.softMax.maximalViolation = probStruct.sxmax;
		out.x.softMin.maximalViolation = probStruct.sxmax;
	elseif isfield(probStruct, 'Sx')
		out.x.with('softMax');
		out.x.with('softMin');
		out.x.softMax.penalty = Penalty(probStruct.Sx, probStruct.norm);
		out.x.softMin.penalty = Penalty(probStruct.Sx, probStruct.norm);
	elseif isfield(probStruct, 'sxmax')
		out.x.with('softMax');
		out.x.with('softMin');
		out.x.softMax.maximalViolation = probStruct.sxmax;
		out.x.softMin.maximalViolation = probStruct.sxmax;
	end
	
	% soft input constraints
	if isfield(probStruct, 'Su') && isfield(probStruct, 'sumax')
		out.u.with('softMax');
		out.u.with('softMin');
		out.u.softMax.penalty = Penalty(probStruct.Su, probStruct.norm);
		out.u.softMin.penalty = Penalty(probStruct.Su, probStruct.norm);
		out.u.softMax.maximalViolation = probStruct.sumax;
		out.u.softMin.maximalViolation = probStruct.sumax;
	elseif isfield(probStruct, 'Su')
		out.u.with('softMax');
		out.u.with('softMin');
		out.u.softMax.penalty = Penalty(probStruct.Su, probStruct.norm);
		out.u.softMin.penalty = Penalty(probStruct.Su, probStruct.norm);
	elseif isfield(probStruct, 'sumax')
		out.u.with('softMax');
		out.u.with('softMin');
		out.u.softMax.maximalViolation = probStruct.sumax;
		out.u.softMin.maximalViolation = probStruct.sumax;
	end
	
	% soft output constraints
	if isfield(probStruct, 'Sy') && isfield(probStruct, 'symax')
		out.y.with('softMax');
		out.y.with('softMin');
		out.y.softMax.penalty = Penalty(probStruct.Sy, probStruct.norm);
		out.y.softMin.penalty = Penalty(probStruct.Sy, probStruct.norm);
		out.y.softMax.maximalViolation = probStruct.symax;
		out.y.softMin.maximalViolation = probStruct.symax;
	elseif isfield(probStruct, 'Sy')
		out.y.with('softMax');
		out.y.with('softMin');
		out.y.softMax.penalty = Penalty(probStruct.Sy, probStruct.norm);
		out.y.softMin.penalty = Penalty(probStruct.Sy, probStruct.norm);
	elseif isfield(probStruct, 'symax')
		out.y.with('softMax');
		out.y.with('softMin');
		out.y.softMax.maximalViolation = probStruct.symax;
		out.y.softMin.maximalViolation = probStruct.symax;
	end
	
	if probStruct.subopt_lev==1
		obj.N = 1;
		fprintf('Use MinTimeController for minimum-time controllers.\n');
	elseif probStruct.subopt_lev==2
		error('M-step control strategy not yet supported.');
	end
	
    
elseif nargin==1 && isa(varargin{1}, 'mptctrl')
    % import mptctrl objects
    
	ctrl = varargin{1};
	sys = mpt_import(ctrl.details.origSysStruct, ctrl.details.origProbStruct);
	
	if isequal(ctrl.type, 'explicit')
		cs = struct(ctrl);
		cs.convex = true;
		data.system = sys;
		data.N = ctrl.probStruct.N;
		data.optimizer = mpt_mpsol2pu(cs);
		out = EMPCController(data);
	else
		out = MPCController(sys, ctrl.probStruct.N);
	end
	
elseif nargin==1 && isa(varargin{1}, 'polytope')
	% import polytope objects
	
	[H, K] = pelemfun(@double, varargin{1});
	out = [];
	for i = 1:length(H)
		out = [out, Polyhedron('A', H{i}, 'b', K{i})];
	end
	
else
	error('Unrecognized case.');
	
end
    
end

function out = importSysStruct(sysStruct)

sysStruct = mpt_verifySysStruct(sysStruct);

% first reject cases which we do not support yet
if isfield(sysStruct, 'noise') && isfulldim(sysStruct.noise)
	error('Systems with additive noise not yet supported.');
end
if isfield(sysStruct, 'Aunc')
	error('Systems with parametric uncertainties not yet supported.');
end
if isfield(sysStruct, 'dumax') && any(~isinf(sysStruct.dumax))
	error('Delta u constraints not yet supported.');
end
if isfield(sysStruct, 'dumin') && any(~isinf(sysStruct.dumin))
	error('Delta u constraints not yet supported.');
end

% import dynamics
if isfield(sysStruct, 'data') && isfield(sysStruct.data, 'MLD')
	% MLD system
	out = MLDSystem(sysStruct.data.MLD);
elseif iscell(sysStruct.A)
	% PWA system
	out = PWASystem(sysStruct);
else
	% LTI system
	out = LTISystem(sysStruct);
end

if isfield(sysStruct, 'Pbnd')
	out.x.with('initialSet');
	out.x.initialSet = toPolyhedron(sysStruct.Pbnd);
end

end
