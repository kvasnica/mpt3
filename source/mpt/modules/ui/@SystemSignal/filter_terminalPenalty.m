function filter = filter_terminalPenalty(obj)
% Penalty on the terminal state

% terminal penalty can only be added on state variables
if ~obj.isKind('x')
	error('Filter "terminalPenalty" can only be added to state variables.');
end

% set up the filter
filter = FilterSetup;
filter.addField('value', [], @(x) isa(x, 'Penalty'));

% the filter impacts the following calls:
filter.callback('objective') = @on_objective;
filter.callback('set') = @on_set;

end

%------------------------------------------------
function out = on_objective(obj, varargin)
% called when constructing the objective function

if obj.hasFilter('reference')
	value = obj.var(:, end) - obj.reference(:, end);
else
	value = obj.var(:, end);
end

out = obj.terminalPenalty.evaluate(value);

end

%------------------------------------------------
function obj = on_set(obj, P)
% called when the penalty is to be changed

% empty penalty means no penalization
if isa(P, 'double') && isempty(P) 
	obj.terminalPenalty = P;
	return
end

% validate the penalty
error(obj.validatePenalty(P));

obj.terminalPenalty = P;

end
