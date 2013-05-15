function test_hash_put_03_fail
%
% testing add method, no index set
%
    h = HashTable;
    h.put([],struct('data',1));

end