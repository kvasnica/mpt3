function test_hash_getIndex_02_pass
%
% check index for 1000 items, (with possible collision)

N=1000;
% add N items
h = HashTable;
for i=1:N
    if h.put(i,struct('mydata',num2str(i)));    
        error('problem with adding');
    end
end

% data must be the same as iterator
for i=1:N
    if h.getIndex(i)~=i
        error('problem identifying the index set');
    end  
end
    

end