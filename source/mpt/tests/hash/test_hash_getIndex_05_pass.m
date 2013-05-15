function test_hash_getIndex_05_pass
%
% tests hash table for strings as keys
%

h = HashTable;

for i=1:1345
    h.put(['file',num2str(i),'.txt'],struct('a',1,'b',2,'ref',i));
end

for i=1:1345
    key = h.getKey(i);
    index = h.getIndex(key);
    if index~=i
        error('index must be the same');
    end
    if isempty(h.getValueByKey(key))
        error('identification by strings failed');
    end
end