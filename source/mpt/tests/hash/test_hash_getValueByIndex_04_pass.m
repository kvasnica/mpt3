function test_hash_getValueByIndex_04_pass
%
% extract struct data for random 1000 items

h = HashTable;
N=2000;
I = zeros(N,35);
for i=1:N
    I(i,:) = randi(N/2,[1, 35]);
    if h.put(I(i,:),struct('name','anonymous','ref',i));
        error('problem with adding');
    end
end

% remove half of them
for i=1:N/2
    if h.removeByKey(I(2*i-1,:));
        error('problem with removing');
    end
end

if h.elem~=N/2
    error('half of the items should be removed');
end

% remaining data should be even
for i=1:N/2
    index = h.getIndex(I(2*i,:));
    D = h.getValueByIndex(index);
    if D.ref~=i*2
        error('wrong data extraction');
    end
end

end