function  ts = removeByIndex(obj, index)
%
%  Remove element from the table based on the index. 
%   
 
key = obj.getKey(index);

if isnumeric(key)
    key = num2str(key);
end

% remove
if isempty(obj.Table.remove(key))
    ts = true;
else
    ts = false;
end

end
