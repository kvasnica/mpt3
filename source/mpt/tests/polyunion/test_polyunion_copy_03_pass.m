function test_polyunion_copy_03_pass
%
% copy two sets including functions
%

P(1) = ExamplePoly.randHrep;
P(2) = ExamplePoly.randVrep;
P.addFunction(Function(@(x)x),'a');
P.addFunction(Function(@(x)x.^2),'b');
U = PolyUnion(P);
Un = U.copy;

% remove one set from U
U.remove(1);

% Un must have two sets
if Un.Num~=2
    error('Here must be 2 sets.');
end

end