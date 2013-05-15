function test_hash_put_06_pass
%
% add one, add the same again
%

h = HashTable;
h.put(1,struct('mydata','abc'));
if ~h.put(1,struct('mydata','def'))
    error('cannot add the same item again');
end

    

end