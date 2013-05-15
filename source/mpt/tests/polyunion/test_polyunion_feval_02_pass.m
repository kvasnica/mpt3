function test_polyunion_feval_02_pass
%
% two set, two functions, one names
%

P(1) = ExamplePoly.randVrep('d',4);
P(2) = ExamplePoly.randVrep('d',4);

P.addFunction(AffFunction(rand(1,4)), 'a');
P.addFunction(AffFunction(rand(1,4)),'f');


U = PolyUnion(P);

x = P(1).interiorPoint.x;

y1=U.feval(x,'f');

if all(P.contains(x))
    if ~iscell(y1)
        error('The result must be cell because the regions overlap.')
    end    
else
    if iscell(y1)
        error('The result must be double because we evaluate only 1 function and there is no overlap.')
    end
end

end
