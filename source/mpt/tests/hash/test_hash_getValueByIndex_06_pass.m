function test_hash_getValueByIndex_06_pass
%
% add unique integers, remove, extract data and index

h = HashTable;
N=2000;
I = zeros(N,135);
for i=1:N
    u = unique(randi(N/2,[1, 235]));
    I(i,:) = u(1:135);
    if h.put(I(i,:),struct('name','anonymous','ref',i));
        error('problem with adding');
    end
end

% remove half of them
for i=1:N/2
    if h.removeByKey(I(2*i-1,:));
        error('problem with adding');
    end
end

if h.elem~=N/2
    error('half of the items should be removed');
end

% remaining data should be even, check index sets
for i=1:N/2
    index = h.getIndex(I(2*i,:));
    key = h.getKey(index);
    D = h.getValueByIndex(index);
    if D.ref~=i*2
        error('wrong data extraction');
    end
    if ~all(key == I(2*i,:))
        error('index sets do not hold');
    end
end

end