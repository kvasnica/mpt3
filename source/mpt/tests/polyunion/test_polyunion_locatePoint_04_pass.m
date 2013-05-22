function test_polyunion_locatePoint_04_pass
%
% array of polyunions
% 

nu = 2;
nx = 3;
A = randn(nx);
B = randn(nx,nu);
U = Polyhedron('lb',-ones(nu,1),'ub',ones(nu,1));
P = ExamplePoly.randVrep('d',nx);
T=P.triangulate;

PU(1,3) = PolyUnion;
for i=1:numel(T)
    
    %% formulate the parametric problem and solve it
    problem = Opt('f',[zeros(nu,1);1],'A',[T(i).A*B -T(i).b; U.A zeros(size(U.A,1),1); zeros(2,nu) [1;-1]],...
        'b',[zeros(size(T(i).H,1),1);U.b;1;0],'pB',[-T(i).A*A; zeros(size(U.A,1),nx);zeros(2,nx)],...
        'Ath',T(i).A,'bth',T(i).b);
    res=problem.solve;
    PU(i) = res.xopt;
end


x = P.grid(10);
for j=1:size(x,1)
    [index,details] = PU.locatePoint(x(j,:));
	c = cellfun('isempty',index);
    uind = find(~c);
    if ~isempty(uind)
        if ~PU(uind).Set(index{uind}).contains(x(j,:))
            error('Wrong region detected.');
        end
    end
end



end