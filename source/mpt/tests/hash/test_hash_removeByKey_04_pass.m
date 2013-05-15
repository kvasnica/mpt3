function test_hash_removeByKey_04_pass
%
% tests hash table for strings as keys
%

h = HashTable;

for i=1:2000
    h.put(['file',num2str(i),'.txt'],struct('a',1,'b',2,'ref',i));
end

for i=1:1000
    key = h.getKey(i);
    if h.removeByKey(key);
        error('removing by key failed');
    end
end

if h.elem~=1000
    error('1000 elements must remain');
end