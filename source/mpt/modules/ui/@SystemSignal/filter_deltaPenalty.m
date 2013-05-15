function filter = filter_deltaPenalty(varargin)
% Filter's skeleton

% set up the filter
filter = FilterSetup;
filter.addField('value', [], @(x) isa(x, 'Penalty'));

% the filter impacts the following calls:
filter.callback('objective') = @on_objective;

end

%------------------------------------------------
function out = on_objective(obj, varargin)

if isempty(obj.previous_value)
    vars_to_diff = obj.var(:, 1:obj.N);
else
    vars_to_diff = [obj.previous_value obj.var(:, 1:obj.N)];
end
diffed_vars = diff(vars_to_diff', 1, 1)';

out = 0;
for k = 1:size(diffed_vars, 2)
    out = out + obj.deltaPenalty.evaluate(diffed_vars(:, k));
end

end
