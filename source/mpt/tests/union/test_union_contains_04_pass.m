function test_union_contains_04_pass
%
% array of unions
%

x = sdpvar(2,1);

F = set(norm(randn(3,2)*x-randn(3,1)) <= ones(3,1));

Y(1) = YSet(x,F);
Y(2) = YSet(x,set(-5<=x<=5));

U = Union(Y);
U.add(ExamplePoly.randHrep+[1;2]);
U.add(ExamplePoly.randVrep-[1;2]);

U(2) = Union([ExamplePoly.randHrep; ExamplePoly.randZono]);

[isin,inwhich,closest] = U.contains( 0.01*rand(2,1),true);

for i=1:2
    if ~isin(i) && isempty(closest{i})
        error('The closest regions should be found always when the point is not contained anywhere.');
    end
    if numel(inwhich{i})~=1
        error('The length of inwhich must be 1 for fastbreak option.');
    end
end

end
