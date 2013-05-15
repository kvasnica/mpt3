function test_hash_getValueByKey_02_pass
%
% extract struct data for 1000 items

h = HashTable;
N=1000;
for i=1:N
    if h.put(i,struct('name','anonymous','ref',i));
        error('problem with adding');
    end
end

% data are the same as index
for i=1:N
    D = h.getValueByKey(i);
    if D.ref~=i
        error('wrong data extraction');
    end
end

end