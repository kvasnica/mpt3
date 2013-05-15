function filter = filter_penalty(varargin)
% Penalizes the signal in the cost function

% set up the filter
filter = FilterSetup;
filter.addField('value', []);

% TODO: combination of validators is not working. why?
%filter.addField('value', [], (@(x) isa(x, 'Penalty')) || @isnumeric);

% the filter impacts the following calls:
filter.callback('objective') = @on_objective;
filter.callback('set') = @on_set;

end

%------------------------------------------------
function out = on_objective(obj, varargin)
% called when constructing the cost function

% remember that state variables have length N+1, but we only
% penalize the first N components. the terminal penalty can be
% easily added by obj.with('terminalPenalty')
if obj.isKind('x')
	M = obj.N-1;
else
	M = obj.N;
end

if obj.hasFilter('reference')
	reference = obj.reference;
	if size(reference, 2)~=M
		reference = [reference repmat(reference(:, end), 1, M-size(reference, 2))];
	end
end

out = 0;
if isa(obj.penalty, 'Penalty')
	for k = 1:M
		if obj.hasFilter('reference')
			value = obj.var(:, k) - reference(:, k);
		else
			value = obj.var(:, k);
		end
		out = out + obj.penalty.evaluate(value);
	end
end

end

%------------------------------------------------
function obj = on_set(obj, P)
% called when the penalty is to be changed

% empty penalty means no penalization
if isa(P, 'double') && isempty(P) 
	obj.penalty = P;
	return
end

% validate the penalty
error(obj.validatePenalty(P));

obj.penalty = P;

end
