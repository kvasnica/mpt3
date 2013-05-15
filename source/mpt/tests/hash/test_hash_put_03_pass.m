function test_hash_put_03_pass
%
% testing add method, 1000 random index sets
%
    N=1000;
    h = HashTable;
    I = zeros(N,100);
    m=0;
    for i=1:N
        I(i,:) = randset(100);
        S=h.put(I(i,:),struct('data',I(i,:)));
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
      

