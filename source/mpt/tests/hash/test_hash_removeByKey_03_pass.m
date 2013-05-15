function test_hash_removeByKey_03_pass
%
% add 1000 elements, remove every second 
%

% add 1000 elements
    N=1000;
    h = HashTable;
    I = zeros(N,5);
    m=0;
    for i=1:N
        I(i,:) = randi(1000,[1, 5]);
        S=h.put(I(i,:),struct('dat',I(i,:)));
        if S==1 
            m=m+1;
        end
    end    
    if m>0
        error('problem with adding elements');
    end
    
    for i=2:2:N        
        if h.removeByKey(I(i,:));
            error('problem with removing elements');
        end
    end
            
    if h.elem~=N/2
        error('here must be %d elements removed',N/2);
    end
    
    z = zeros(N/2,1);
    for i=1:N/2
        z(i) = h.getIndex(I(2*i-1,:));
        if z(i)~=i
            error('index is not the same');
        end
    end
    

end