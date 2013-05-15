function test_hash_put_02_fail
%
% testing add method, 
% not a proper index set
%
    h = HashTable;
    h.put([1 0 pi]',struct('data',1));

end