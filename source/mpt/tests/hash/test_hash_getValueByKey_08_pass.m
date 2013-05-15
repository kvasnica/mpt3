function test_hash_getValueByKey_08_pass
%
% tests hash table for logicals
%

h = HashTable;

h.put(logical([1 0 0 1 0 1]),struct('a',1));
h.put(logical([1 0 0 1 1 1]),struct('a',2));
h.put(logical([1 0 1 1 1 1]),struct('a',3));


if h.getValueByKey([true false false true false true]).a~=1
    error('identification by logical key failed');
end
if h.getValueByKey([true false false true true true]).a~=2
    error('identification by logical key failed');
end
if h.getValueByKey([true false true true true true]).a~=3
    error('identification by logical key failed');
end