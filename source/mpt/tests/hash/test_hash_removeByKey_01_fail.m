function test_hash_removeByKey_01_fail
%
% wrong key
%

h = HashTable;

h.removeByKey(-123456)
