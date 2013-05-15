function test_hash_getIndex_06_pass
%
% tests hash table for logical keys
%

h = HashTable;

h.put(logical([0,1,2,0]),struct('a',1));
h.put(logical([1;1;2;0]),struct('a',2));

if h.getIndex([false true true false])~=1
    error('Must accept also logicals!');
end

if h.getIndex([true true true false])~=2
    error('Must accept also logicals!');
end
