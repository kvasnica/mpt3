function test_hash_put_07_pass
%
% add 10 items
%

h = HashTable;
for i=1:10
    if h.put(i,struct('mydata',num2str(i)));    
        error('problem with adding');
    end
end

    

end