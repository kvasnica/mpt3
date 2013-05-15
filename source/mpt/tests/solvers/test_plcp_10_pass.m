function test_plcp_10_pass
% feasibility MPLP with many inequalities on the parameter

%% input data
% 

global MPTOPTIONS

A = [-eye(5,7), zeros(5,20);
    randn(10,7), 0.0001*randn(10,20);
    0.1*eye(3,7), randn(3,20)];

b = zeros(18,1);
pB = [zeros(10,1), randn(10,1);
       ones(5,1), zeros(5,1);
       randn(3,2)];

% bound on theta somewhere out of origin
Pth = Polyhedron('A',randn(18,2),'b',5*ones(18,1))+ 5*randn(2,1);

% generate data s.t. the solution exists
Px = Polyhedron('A',[A -pB; zeros(18,27) Pth.A; eye(27) zeros(27,2); -eye(27) zeros(27,2)],'b',[b;Pth.b;10*ones(27,1);20*ones(27,1)]);
while Px.isEmptySet
    A = [-eye(5,7), zeros(5,20);
        randn(10,7), 0.0001*randn(10,20);
        0.1*eye(3,7), randn(3,20)];
    
    b = zeros(18,1);
    pB = [zeros(10,1), randn(10,1);
        ones(5,1), zeros(5,1);
        randn(3,2)];
    
    % bound on theta somewhere out of origin
    Pth = Polyhedron('A',randn(18,2),'b',5*ones(18,1))+ 5*randn(2,1);
    
    Px = Polyhedron('A',[A -pB; zeros(18,27) Pth.A; eye(27) zeros(27,2); -eye(27) zeros(27,2)],'b',[b;Pth.b;10*ones(27,1);20*ones(27,1)]);
end   



% define problem
problem = Opt('A',A,'b',b,'pB',pB,'Ath',Pth.A,'bth',Pth.b,'lb',-20*ones(27,1),'ub',10*ones(27,1));

% solve
res = problem.solve;
%plot(res.regions)

% new problem with MPLP
pn = Opt('A',A,'b',b,'pB',pB,'Ath',Pth.A,'bth',Pth.b,'lb',-20*ones(27,1),'ub',10*ones(27,1),'solver','mplp');
rn = pn.solve;

% feasible domain
Phard = double(rn.mplpsol.Phard);

for i=1:rn.xopt.Num
    
    % solution is degenerate, but there must exist an equivalent region to 
    [x,y] = rn.xopt.Set(i).meshGrid(2);
    % get points inside the polytope Pn(i)
    p=[x(:),y(:)];                
    % delete NaN 
    p(any(~isfinite(p),2),:)=[];
    
    % gridding is not exact, so we cut the points outside of feasible
    % domain
    ts = false(size(p,1),1);
    for k=1:size(p,1)
       ts(k) = any(Phard*[p(k,:),-1]'>0);
    end
    p(ts,:)=[];

    % for any point in the grid find the appropriate region via adjacency
    % list - if there's is a point missing -either a solution or adjacency
    % list is wrong
    for j=1:size(p,1)
        index = find_region(p(j,:)',res.xopt.Set,res.xopt.Internal.adj_list);
        %[isin, index] = isInside(res.xopt.Set,p(j,:)');
        
        if isempty(index)
            error('PLCP solution does not hold.');
        end
    end
    
end

end