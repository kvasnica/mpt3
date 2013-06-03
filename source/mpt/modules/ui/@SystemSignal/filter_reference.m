function filter = filter_reference(obj)
% Allows the signal to track a certain reference profile

% set up the filter
filter = FilterSetup;
filter.addField('value', zeros(obj.n, 1));

% the filter impacts the following calls:
filter.callback('set') = @on_set;
filter.callback('getInitVariables') = @on_getInitVariables;
filter.callback('getVariables') = @on_variables;
filter.callback('instantiate') = @on_instantiate;
filter.callback('uninstantiate') = @on_uninstantiate;
filter.callback('constraints') = @on_constraints;

end

%------------------------------------------------
function out = on_getInitVariables(obj, varargin)
% called when variables used to initialize the optimization problem are
% requested

if obj.internal_properties.reference.free
	out.name = obj.name;
	out.filter = 'reference';
	out.var = obj.internal_properties.reference.var;
else
	out = [];
end

end

%------------------------------------------------
function out = on_variables(obj, varargin)
% called when filter's variables are requested

if obj.internal_properties.reference.free
	out = obj.internal_properties.reference.var;
else
	out = [];
end

end

%------------------------------------------------
function out = on_constraints(obj, varargin)
% called when constructing constraints

out = [];
if obj.internal_properties.reference.free
	% bound symbolic references using signal's min/max values
	%
	% do not include +/-Inf bounds
	v = obj.internal_properties.reference.var;
	for i = 1:length(v)
		if ~isinf(obj.min(i))
			out = out + [ obj.min(i) <= v(i) ];
		end
		if ~isinf(obj.max(i))
			out = out + [ v(i) <= obj.max(i) ];
		end
	end
end

end

%------------------------------------------------
function out = on_instantiate(obj, varargin)
% called after the object was instantiated

if obj.internal_properties.reference.free
	obj.internal_properties.reference.var = sdpvar(obj.n, 1);
end
out = [];

end

%------------------------------------------------
function out = on_uninstantiate(obj, varargin)
% called when the YALMIP representation of variables is removed

obj.internal_properties.reference.var = [];
out = [];

end

%------------------------------------------------
function obj = on_set(obj, value)
% called when the reference is to be changed


if isa(value, 'double')
	if ~isempty(value) && (size(value, 1) ~= obj.n)
		error('The refence must have %d rows.', obj.n);
	end
	obj.internal_properties.reference.free = false;
	
elseif isa(value, 'char')
	value = lower(value);
	if ~isequal(value, 'free')
		error('The value of reference must be ''free''.');
	end
	obj.internal_properties.reference.free = true;
	
else
	error('Value of "reference" must be either a double or a string.');
end

obj.reference = value;

end
