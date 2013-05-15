function test_hash_getIndex_04_pass
%
% check index for 2000 items, including removal and possible collision

N=2000;
% add N items
h = HashTable;
I=zeros(N,10);
for i=1:N
    I(i,:) = randi(N,[1,10]);
    if h.put(I(i,:),struct('mydata',num2str(i)));    
        error('problem with adding');
    end
end

% remove ever second item
for i=1:N/2
    if h.removeByKey(I(2*i-1,:));    
        error('problem with removing');
    end
end

% index must be ascending
for i=1:N/2
    if h.getIndex(I(2*i,:))~=i
        error('problem identifying the index set');
    end  
end
    

end