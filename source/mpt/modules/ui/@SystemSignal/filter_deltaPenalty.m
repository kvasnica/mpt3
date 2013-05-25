function filter = filter_deltaPenalty(varargin)
% Filter's skeleton

% set up the filter
filter = FilterSetup;
filter.addField('value', []);

% the filter impacts the following calls:
filter.callback('objective') = @on_objective;
filter.callback('set') = @on_set;

end

%------------------------------------------------
function out = on_objective(obj, varargin)

out = 0;
if isempty(obj.deltaPenalty)
	return
end

if isempty(obj.previous_value)
	vars_to_diff = obj.var(:, 1:obj.N);
else
	vars_to_diff = [obj.previous_value obj.var(:, 1:obj.N)];
end
diffed_vars = diff(vars_to_diff', 1, 1)';

for k = 1:size(diffed_vars, 2)
	out = out + obj.deltaPenalty.feval(diffed_vars(:, k));
end

end

%------------------------------------------------
function obj = on_set(obj, P)
% called prior to property being set

% validate the penalty (empty penalty means no penalization)
if ~isempty(P)
	error(obj.validatePenalty(P));
end
obj.deltaPenalty = P;

end
