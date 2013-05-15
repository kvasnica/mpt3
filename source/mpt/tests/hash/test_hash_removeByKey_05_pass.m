function test_hash_removeByKey_05_pass
%
% tests hash table for logical strings
%

h = HashTable;

h.put([true false],struct('a',[true,false]));
h.put([false;true],struct('a',[false;true]));

if h.removeByKey([true;false])
    error('removing by key failed');
end

if h.removeByKey([false,true])
    error('removing by key failed');
end

if h.elem~=0
    error('0 elements must remain');
end