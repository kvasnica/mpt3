function test_hash_cat_02_pass
%
% testing horizontal concatenation
%
    h = HashTable;

    t=[h,h,h];
    
%     if size(t,2)~=3
%         error('Wrong size.');
%     end
%     if size(t,1)~=1
%         error('Wrong size.');
%     end
    if numel(t)~=3
        error('Wrong number of elements.');
    end
    
    if ~iscell(t)
        error('Output must be a cell array.');
    end

end