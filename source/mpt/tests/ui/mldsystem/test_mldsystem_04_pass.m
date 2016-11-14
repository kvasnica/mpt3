function test_mldsystem_04_pass
% import of MLD structures with B5/D5 terms should work

onCleanup(@() delete('data_mldsystem_binary_01.m'));

param1 = 0.5;
param2 = 3.7;
period = 6;
param3 = [0.5;1.5;2.5]*param2;
epsilon = 0.1;

%% Initial State
initialState=[  
    15; param3(2);    10; param3(2);... 
    30; 10;...                      
    1; 0; 0; 0; 0;...               
    ];
            
%% Hybrid System
params.param1 = param1;
params.param2 = param2;
params.param3 = param2/period;
params.epsilon = epsilon;

hysdel('data_mldsystem_binary_01.hys');
pause(0.1);
rehash;
pause(0.1);
rehash;
data_mldsystem_binary_01;

% must not break with an error
model = MLDSystem(S);
% B5, D5 terms must be automatically set to zero vectors
assert(isequal(model.S.B5, zeros(model.S.nx, 1)));
assert(isequal(model.S.D5, zeros(model.S.ny, 1)));

end