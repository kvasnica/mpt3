function test_hash_getValueByIndex_01_pass
%
% extract data for 10 items

h = HashTable;

for i=1:10
    if h.put(i,struct('str',num2str(i)));
        error('problem with adding');
    end
end

% data are the same as index
for i=1:10
    d = h.getValueByIndex(i);
    if ~strcmp(d.str,num2str(i))
        error('wrong data extraction');
    end
end

end