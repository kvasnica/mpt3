function test_mintime_01_pass
% empty constructor

MT = MinTimeController;
MT.display();
EMT = EMinTimeController;
EMT.display();
assert(isempty(MT.model));
assert(isempty(EMT.model));

end
