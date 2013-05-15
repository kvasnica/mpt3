function test_hash_put_02_pass
%
% testing add method, over 1000 elements to add
%
    h = HashTable;
    parfor i=1:1692
        h.put(i,struct('data',i));
    end

end