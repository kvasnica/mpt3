function test_polyhedron_14_pass
%
% allow inf terms in "lb" field
%

P=Polyhedron('lb', [1; -Inf]);

if numel(P.b)~=1
    error('Inf rows must be removed.');
end
% b = P.b;
% if b(2)~=0
%     error('Inf rows must be converted to zero rows.')
% end


end