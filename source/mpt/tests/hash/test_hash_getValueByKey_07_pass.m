function test_hash_getValueByKey_07_pass
%
% tests hash table for strings as keys
%

h = HashTable;

for i=1:10
    h.put(['file',num2str(i),'.txt'],struct('a',1,'b',2,'ref',i));
end

for i=1:10   
    if isempty(h.getValueByKey(['file',num2str(i),'.txt']))
        error('identification by strings failed');
    end
end