function test_hash_removeByKey_01_pass
%
% add 5 elements, remove 3 
%

% add 5 elements
    N=5;
    h = HashTable;
    I = zeros(N,5);
    m=0;
    for i=1:N
        I(i,:) = [i 2*i 3*i 4*i 5*i];
        S=h.put(I(i,:),struct('basis',I(i,:)));
        if S==1 
            m=m+1;
        end
    end
    
    if m>0
        error('problem with adding elements');
    end
    
% remove 3 elements
    M=3;
    for i=1:M
        I(i,:) = [i 2*i 3*i 4*i 5*i];
        S=h.removeByKey(I(i,:));
        if S==1 
            m=m+1;
        end
    end
    if m>0
        error('problem with removing elements');
    end

    
    if h.elem~=N-M
        error('here must be %d left',N-M);
    end
        

end
