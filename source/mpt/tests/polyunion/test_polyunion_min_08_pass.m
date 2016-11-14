function test_polyunion_min_08_pass
% fail test for PolyUnion/min using where no functions is provided
%

% generate random polyunion
for i=1:2
    P(i) = ExamplePoly.randVrep;
    Q(i) = ExamplePoly.randVrep;
end

U(1) = PolyUnion(P);
U(2) = PolyUnion(Q);

[worked, msg] = run_in_caller('U.min');

assert(~worked)

asserterrmsg(msg, 'The object has no functions.')

end
