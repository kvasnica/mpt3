function test_hash_removeByKey_02_pass
%
% add 5 elements, remove all
%

% add 5 elements
    N=5;
    h = HashTable;
    I = zeros(N,5);
    m=0;
    for i=1:N+1
        I(i,:) = randi(1000,[1, N]);
    end
    for i=1:N
        S=h.put(I(i,:),struct('basis',I(i,:)));
        if S==1 
            m=m+1;
        end
    end
    
    if m>0
        error('problem with adding elements');
    end
    
% remove N+1 elements
    for i=1:N
        if h.removeByKey(I(i,:));
            error('problem with removing elements');
        end
    end
    
    if h.elem~=0
        error('here must be 0 elements left');
    end
        

end

