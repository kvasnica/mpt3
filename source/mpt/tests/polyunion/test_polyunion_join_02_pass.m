function test_polyunion_join_02_pass
%
% three empty polyunions
%

U(3,1) = PolyUnion;

Un = U.join;

if numel(Un)~=0
    error('Empty polyunion.')
end

end
