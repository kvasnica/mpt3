function ts=replaceByIndex(obj,index,value)
%
%  Replace the value of an element with a new value based on indexing. 
%     
 

key = obj.getKey(index);

if isnumeric(key)
    % asset numeric (integer array)
    validate_indexset(key);
    % if the key is a proper index set, make string out of it
    key = num2str(key);
end
if ~ischar(key)
    error('Key must be either a string or an integer (array).');
end

% replace
if obj.Table.containsKey(key)
    ts=~obj.put(key,value);
else
    ts = true;
end

