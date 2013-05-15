function test_hash_put_09_pass
%
% tests hash table to add column vector
%

h = HashTable;

h.put([1;2;3],struct('a',1));

if any(h.getKey(1)~=[1 2 3])
    error('Must accept also vectors!');
end
