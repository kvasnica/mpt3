function test_hash_cat_01_pass
%
% testing vertical concatenation
%
    h = HashTable;

    t=[h;h];

    if size(t,1)~=2
        error('Wrong size.');
    end
    if size(t,2)~=1
        error('Wrong size.');
    end
    if ~iscell(t)
        error('Output must be a cell array.');
    end

end