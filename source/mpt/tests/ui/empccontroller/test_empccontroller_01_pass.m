function test_empccontroller_01_pass

E = EMPCController;
E.display();
assert(isempty(E.optimizer));
assert(isempty(E.model));
assert(E.isExplicit);

end
