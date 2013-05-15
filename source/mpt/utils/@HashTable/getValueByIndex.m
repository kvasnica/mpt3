function d = getValueByIndex(obj, index)
%
%  Retrieves stored data for the element by index. 
%  
 
 
validate_indexset(index);

if numel(index)>1
    error('Indes must be scalar.');
end

n = obj.Table.size;
if index>n
    error('Index is greater than the number of elements in the table.');
end

a = obj.Table.entrySet.toArray;

% order is the same as elements were added to the table
c = a(index).getValue;

if isempty(c)
    d = c;
else
    % return back as structure
    d = cell2struct(cell(c(2)),cell(c(1)));
end

end

