function test_polyhedron_chebyCenter_06_pass
%
% array of two polyhedra
%

global MPTOPTIONS
if isempty(MPTOPTIONS)
    MPTOPTIONS = mptopt;
end

P(1) = Polyhedron(randn(15,4));
P(2) = Polyhedron(randn(11,4),5*rand(11,1));

% H-rep
P.minHRep();

% whole polyhedron
xc = P.chebyCenter;

for i=1:2
   if xc{i}.exitflag~=MPTOPTIONS.OK
       error('Should be ok here.');
   end
end

% bound on radius, facets
xn = P.chebyCenter([2 3],5);

for i=1:2
    if xn{i}.r>5.000001
        error('Radius cannot be greater than t');
    end
end


end
