function test_hash_cat_03_pass
%
% testing horizontal and vertical concatenation
%
    h = HashTable;

    t=[h,h;h,h];
    
    if numel(t)~=4
        error('wrong number of elements.');
    end

end