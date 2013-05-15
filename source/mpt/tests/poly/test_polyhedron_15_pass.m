function test_polyhedron_15_pass
%
% allow inf terms in "ub" field
%

P=Polyhedron('ub', Inf);

if numel(P.b)~=0
    error('Inf rows must be removed.');
end
% b = P.b;
% if b(1)~=0
%     error('Inf rows must be converted to zero rows.')
% end


end