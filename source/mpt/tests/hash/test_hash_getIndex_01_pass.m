function test_hash_getIndex_01_pass
%
% check index

% add 10 items
h = HashTable;
for i=1:10
    if h.put(i,struct('mydata',num2str(i)));    
        error('problem with adding');
    end
end

% data must be the same as iterator
for i=1:10
    if h.getIndex(i)~=i
        error('problem identifying the index set');
    end  
end
    

end