function d = getValueByKey(obj, key)
%
%  Retrieves stored data for the element determined by given key. 
%   

% transpose key to make it a row vector
if size(key,1)>size(key,2)
    key = transpose(key);
end

if islogical(key)
    key = num2str(key);
elseif isnumeric(key)
    % asset numeric (integer array)
    validate_indexset(key);
    % if the key is a proper index set, make string out of it
    key = num2str(key);
elseif ~ischar(key)
    error('Key must be either a string or an unique integer array.');
end

c = obj.Table.get(key);

if isempty(c)
    d = c;
else
    % return back as structure
    d = cell2struct(cell(c(2)),cell(c(1)));
end

end
