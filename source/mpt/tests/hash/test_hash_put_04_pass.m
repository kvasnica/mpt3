function test_hash_put_04_pass
%
% testing add method, 1000 ascending index sets
%
    N=1000;
    h = HashTable;
    I = zeros(N,5);
    m=0;
    for i=1:N
        I(i,:) = [i 2*i 3*i 4*i 5*i];
        S=h.put(I(i,:),struct('dat',I(i,:)));
        if S==1 
            m=m+1;
        end
    end   

    z = zeros(N,1);
    for i=1:N
        z(i) = h.getIndex(I(i,:));
        if z(i)~=i
            error('index is not the same');
        end
    end
    u = unique(z);
    
    if length(u)~=N
        error('getIndex method failed');
    end
    
    if m>1
        error('problem with adding');
    end
    

end


function I = randset(N)

  I = zeros(1,N);
  parfor i=1:N
      I(i) = randi(N);
  end
end
      

