function test_ultisystem_02_pass
% test the ULTISystem constructor with valid inputs

% autonomous LTI system
S = ULTISystem('A', 1);
assert(isempty(S.B));
assert(isequal(size(S.B), [1 0]));
assert(isequal(S.E, 1));
assert(isequal(size(S.C), [0 1]));
assert(isequal(size(S.D), [0 0]));
assert(ismember('d', S.listComponents)); % no S.d if "E" not specified
assert(S.nd==1);
assert(S.d.min==0);
assert(S.d.max==0);
% 2 default disturbances
S = ULTISystem('A', 2*eye(2));
assert(S.nd==2);
assert(isequal(S.E, eye(2)));
assert(isequal(S.d.min, zeros(2, 1)));
assert(isequal(S.d.max, zeros(2, 1)));
% 1 custom disturbance
S = ULTISystem('A', 2*eye(2), 'E', [1; 1]);
assert(S.nd==1);
assert(isequal(S.E, [1;1]));
assert(isequal(S.d.min, zeros(1, 1)));
assert(isequal(S.d.max, zeros(1, 1)));


% autonomous LTI system with additive disturbance
S = ULTISystem('A', 1, 'E', 2);
assert(isequal(S.E, 2));
assert(S.nd==1);
assert(ismember('d', S.listComponents));
assert(~S.d.hasFilter('penalty'));

% autonomous LTI system with two additive disturbances
S = ULTISystem('A', 1, 'E', [2 3]);
assert(isequal(S.E, [2 3]));
assert(ismember('d', S.listComponents));
assert(S.d.n==2);
assert(S.nd==2);

% autonomous LTI system with parametric A matrix
S = ULTISystem('A', {1, 2});
assert(iscell(S.A));

% parametric uncertainty + additive disturbance
S = ULTISystem('A', {1, 2}, 'E', [2 3 4]);
assert(iscell(S.A));
assert(isequal(S.E, [2 3 4]));
assert(S.nd==3);

% non-autonomous system with parametric uncertainties
S = ULTISystem('A', {1, 2}, 'B', {1, 2, 3}, 'C', 1);
assert(iscell(S.A));
assert(numel(S.A)==2);
assert(iscell(S.B));
assert(numel(S.B)==3);
assert(~iscell(S.C));
assert(isequal(S.C, 1));

% non-autonomous system with parametric uncertainties and additive
% disturbance
S = ULTISystem('A', {1, 2}, 'B', {1, 2, 3}, 'C', 1, 'E', 4);
assert(isequal(S.E, 4));
assert(iscell(S.A));
assert(numel(S.A)==2);
assert(iscell(S.B));
assert(numel(S.B)==3);
assert(~iscell(S.C));
assert(isequal(S.C, 1));

end