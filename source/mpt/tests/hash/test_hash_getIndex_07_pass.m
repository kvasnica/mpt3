function test_hash_getIndex_07_pass
% test hash table without a specified key

h = HashTable;
h.put('b', struct('i', 1));
h.put('a', struct('i', 1));
h.put('cc', struct('i', 1));
assert(h.getIndex('b')==1);
assert(h.getIndex('a')==2);
assert(isempty(h.getIndex('c')));
