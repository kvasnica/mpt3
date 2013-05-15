function test_hash_cat_06_pass
%
% testing matrix concatenation
%
    h = HashTable;

    t=[h,h;[h;HashTable,[],h];[];[h,h;h]];
    
    if numel(t)~=8
        error('Wrong number of elements.');
    end

end