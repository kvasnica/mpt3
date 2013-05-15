function ts = put(obj, key, value)
%
%  Insert data into HashTable object. 
%   
 
% transpose key to make it a row vector
if size(key,1)>size(key,2)
    key = transpose(key);
end

if isnumeric(key)
    % asset numeric (integer array)
    validate_indexset(key);
    % if the key is a proper index set, make string out of it
    key = num2str(key);
elseif islogical(key)
    key = num2str(key);
elseif ~ischar(key)
    error('Key must be either a string or an integer (array).');
end

if ~isstruct(value)
    error('Value must be a structure.');
end
f = fieldnames(value); % names
c = struct2cell(value); % data

% add element to the table
% (after all the if-then rules above, "key" is a string)
if isempty(obj.Table.put(key,{f,c}))
    ts = false;
else
    ts = true;
end

end
