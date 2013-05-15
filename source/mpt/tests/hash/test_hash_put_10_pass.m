function test_hash_put_10_pass
%
% add logical index sets
%

h = HashTable;

h.put(logical([1;2;3]),struct('a',1));
h.put(logical([1 0 0 1]),struct('a',2));

if any(h.getKey(1)~=[1 1 1])
    error('Must accept also logicals!');
end

if any(h.getKey(2)~=[1 0 0 1])
    error('Must accept also logicals!');
end
