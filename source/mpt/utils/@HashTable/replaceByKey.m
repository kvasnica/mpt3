function ts=replaceByKey(obj,key,value)
%
%  Replace the value of an element with a new value based on keys. 
%  

% transpose key to make it a row vector
if size(key,1)>size(key,2)
    key = transpose(key);
end

if islogical(key)
    key = num2str(key);
end

if isnumeric(key)
    % asset numeric (integer array)
    validate_indexset(key);
    % if the key is a proper index set, make string out of it
    key = num2str(key);
end
if ~ischar(key)
    error('Key must be either a string or an integer (array).');
end

if obj.Table.containsKey(key)
    ts=~obj.put(key,value);
else
    ts = true;
end
