function I = getIndex(obj, key)
%
%  Retrieves index for element characterized with given key. 
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

list = java.util.ArrayList(obj.Table.keySet);
I = list.indexOf(key);
if I<0
	% key not found
	I = [];
else
	% java indexes from 0
	I = I+1;
end

end
