function test_hash_put_01_pass
%
% testing add method 
%
    h = HashTable;
    h.put([1 2 3],struct('data',1));

end