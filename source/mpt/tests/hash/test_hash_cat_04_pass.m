function test_hash_cat_04_pass
%
% testing matrix concatenation
%
    h = HashTable;

    t=[h,h;h];
    
    if numel(t)~=3
        error('wrong number of elements.');
    end

end