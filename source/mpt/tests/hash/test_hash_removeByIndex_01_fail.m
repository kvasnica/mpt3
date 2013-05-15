function test_hash_removeByIndex_01_fail
%
% index out of scope
%

h = HashTable;

h.removeByIndex(123456);
