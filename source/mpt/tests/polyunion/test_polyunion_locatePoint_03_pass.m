function test_polyunion_locatePoint_03_pass
%
% 4D example
% 

A = [0   -0.0631    1.4897   0
   -1.3499    0.7147    1.4090    0.7172
    3.0349   0    1.4172    0
    0.7254   -0.1241    0    0];
B = [ 1.0347   0   0
    0.7269    0   -2.9443
    0   0    1.4384
    0.1   -1.0689    0.3252];
model = LTISystem('A',A,'B',B);

ctrl = MPCController(model, 2);
c = ctrl.toExplicit;

for i=1:c.optimizer.Num;
    x = c.optimizer.Set(i).grid(3);
    for j=1:size(x,1)
        index = c.optimizer.locatePoint(x(j,:));
        if ~c.optimizer.Set(index).contains(x(j,:))
            error('Wrong region detected.');
        end
    end
end


end