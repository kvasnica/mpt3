function test_hash_cat_05_pass
%
% testing matrix concatenation
%
    h = HashTable;

    t=[h,h;h;HashTable,[],h];
    
    if numel(t)~=5
        error('Wrong number of elements.');
    end

end