function test_hash_getValueByIndex_03_pass
%
% extract struct data for random 1000 items

h = HashTable;
N=1000;
I = zeros(N,23);
for i=1:N
    I(i,:) = randi(N/2,[1, 23]);
    if h.put(I(i,:),struct('name','anonymous','ref',i));
        error('problem with adding');
    end
end

% data are the same as index
for i=1:N
    D = h.getValueByIndex(i);
    if D.ref~=i
        error('wrong data extraction');
    end
end

end