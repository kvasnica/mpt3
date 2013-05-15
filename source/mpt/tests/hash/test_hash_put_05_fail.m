function test_hash_put_05_fail
%
% tests hash table for putting rational number
%

h = HashTable;

h.put(pi,struct('val',1));
