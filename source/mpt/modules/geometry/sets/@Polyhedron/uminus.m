function Q = uminus(P)
% Unitary minus. Q = -P.
% 
% @return Minus set
%

% allocate
Q(size(P)) = Polyhedron;

% revert A, Ae and Vertices
parfor i=1:length(P)
    Q(i) = Polyhedron('H',[-P(i).A P(i).b],'He',[-P(i).Ae P(i).be],'V',-P(i).V,'R',-P(i).R);    
end


end