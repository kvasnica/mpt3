function test_hash_getIndex_03_pass
%
% check index for 1000 items, (with possible collision)

N=1000;
% add N items
h = HashTable;
I=zeros(N,10);
for i=1:N
    I(i,:) = randi(N,[1,10]);
    if h.put(I(i,:),struct('mydata',num2str(i)));    
        error('problem with adding');
    end
end

% data must be the same as iterator
for i=1:N
    if h.getIndex(I(i,:))~=i
        error('problem identifying the index set');
    end  
end
    

end