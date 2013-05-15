function filter = filter_reference(obj)
% Allows the signal to track a certain reference profile

% set up the filter
filter = FilterSetup;
filter.addField('value', zeros(obj.n, 1), @isnumeric);

% the filter impacts the following calls:
filter.callback('set') = @on_set;

end

%------------------------------------------------
function obj = on_set(obj, value)
% called when the reference is to be changed

if size(value, 1) ~= obj.n
	error('The refence must have %d rows.', obj.n);
end
obj.reference = value;

end
