function test_polyhedron_meshgrid_02_pass
%
% array V-H-polyhedron
%

P(1) = ExamplePoly.randVrep;
P(2) = ExamplePoly.randHrep;

% arrays must be rejected
[~, msg] = run_in_caller('[X, Y] = P.meshGrid;');
asserterrmsg(msg, 'This method does not support arrays. Use the forEach() method.');

% UniformOutput must be set to false
[~, msg] = run_in_caller('[X, Y] = P.forEach(@(e) e.meshGrid)');
asserterrmsg(msg, 'Non-scalar in Uniform output, at index 1, output 1.');

% this must work
[X, Y] = P.forEach(@(e) e.meshGrid, 'UniformOutput', false);

for i=1:2
    Xn = X{i}(:);
    Yn = Y{i}(:);
    Xn(isnan(Xn))=[];
    Yn(isnan(Yn))=[];
    
    if any(~P(i).contains([Xn,Yn]'))
        error('Wrong default value.');
    end
end

end
