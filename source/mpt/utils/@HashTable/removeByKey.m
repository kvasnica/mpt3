function  ts = removeByKey(obj, key)
%
%  Remove element from the table based on the key. 
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
    error('Key must be either a string or an unique integer array.');
end

if isempty(obj.Table.remove(key))
    ts = true;
else
    ts = false;
end

end
