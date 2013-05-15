function test_polyhedron_13_pass
%
% allow inf terms in "b" field
%

P=Polyhedron('A', [1 0; 1 0], 'b', [1; Inf]);

if numel(P.b)~=1
    error('Inf rows must be removed.');
end
% b = P.b;
% if b(2)~=0
%     error('Inf rows must be converted to zero rows.')
% end

end