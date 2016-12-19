function test_polyhedron_isfulldim_05_pass
%
% isFullDim test
% 
% 

Q = Polyhedron('lb',-5*ones(5,1),'ub',0.5*ones(5,1));
if ~all(isFullDim([Q 0.5*Q -Q +Q]))
    error('Given polyhedron object should be full-dimensional.');
end

end
