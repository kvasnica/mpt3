function test_hash_put_01_fail
%
% testing add method, 
% not proper index set
%
    h = HashTable;
    h.put([1 0 0],struct('data',1));

end