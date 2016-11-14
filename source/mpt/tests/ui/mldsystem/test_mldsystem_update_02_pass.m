function test_mldsystem_update_02_pass
% MLDSystem/update should fail nicely if system is not initialized

sys = MLDSystem('pwa_car');
x0 = [-5; 0];
[worked, msg] = run_in_caller('sys.update(1);');
assert(~worked);
assert(~isempty(strfind(msg, 'Internal state not set, use "sys.initialize(x0)".')));

end
