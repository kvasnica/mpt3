function test_polyhedron_chebyCenter_05_pass
%
% lower-dimensional polyhedron, unbounded
%

global MPTOPTIONS
if isempty(MPTOPTIONS)
    MPTOPTIONS = mptopt;
end

P = Polyhedron('A',randn(10,15),'b',rand(10,1),'He',randn(2,16));

% whole polyhedron
xc = P.chebyCenter;

if ~P.isBounded
  if xc.r<1e4
      error('Radius should be infbound.');
  end
end

% bound on radius
xn = P.chebyCenter([],1);

if xn.r>1.000001
    error('Radius cannot be greater than 1');
end

% facets 1,2
P.minHRep();

xf = P.chebyCenter([1,2,3]);
if xf.exitflag~=MPTOPTIONS.OK
    error('Three facets should be ok because the dim is 15.');
end


end
