function test_polyunion_copy_01_pass
%
% copy empty polyunion
%

U = PolyUnion;
Un = U.copy;
assert(isa(Un, 'PolyUnion'));

if ~isempty(Un.Set)
    error('Empty polyunion.');
end

end
