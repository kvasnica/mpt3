function test_polyhedron_isempty_07_pass
%
% isempty test
% 
% 

% callin from cell
P = { Polyhedron(randn(18,5)); 
      Polyhedron(randn(3), randn(3,1));
      Polyhedron
      Polyhedron('He', randn(10,4)) };
il = cellfun(@isEmptySet,P);
  
if ~all(il(3:end))
    error('Given polyhedron object should be empty');
end

end
