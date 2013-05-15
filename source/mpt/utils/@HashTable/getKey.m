function key = getKey(obj, index)
%
%  Retrieves key for given element index. 
%  
 
validate_indexset(index);

if numel(index)>1
    error('Index must be a scalar.');
end

n = obj.Table.size;
if index>n
    error('Index is greater than the number of elements in the table.');
end

% extract entries to an array
a = obj.Table.entrySet.toArray;

% get key for given index as a string
str = a(index).getKey;

% if the key was an integer array, convert it back to number ( if it finds
% anything except the numbers and whitespace around them, leave 
% it as char)
s = regexp(str,'[^[ ]*[0-9][ ]*]', 'once');

% cast as number on the output
if isempty(s)
    key = str2num(str);
else
    key = str;
end
end
