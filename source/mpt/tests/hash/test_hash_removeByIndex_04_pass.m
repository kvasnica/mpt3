function test_hash_removeByIndex_04_pass
%
% tests hash table for strings as keys
%

h = HashTable;

for i=1:2000
    h.put(['file',num2str(i),'.txt'],struct('a',1,'b',2,'ref',i));
end

for i=2000:-1:1001
    key = h.getKey(i);
    index = h.getIndex(key);
    if h.removeByIndex(index)
        error('removing by index failed');
    end
end

if h.elem~=1000
    error('1000 elements must remain');
end