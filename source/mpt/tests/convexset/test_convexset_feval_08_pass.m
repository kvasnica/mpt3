function test_convexset_feval_08_pass
%
% 3 functions, identify by the string
%

P = Polyhedron('lb',[-1;-2;-3;-4;-5],'ub',[1;2;3;4;5]);

P.addFunction(AffFunction(randn(1,5)),'f1');
P.addFunction(AffFunction(randn(1,5)),'f2');
P.addFunction(AffFunction(randn(1,5)),'f3');


y = feval(P,[0;0.1;0.2;0.3;0.4],{'f1','f3'});

if numel(y)~=2
    error('Two outputs required.');
end


end