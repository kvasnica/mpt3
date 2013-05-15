function Psliced = slice(P, dims, offsets)
%
% Slice the set through the given dimensions.<p>
%
% @param dims Variables to remove
% @return Sliced polyhedron
%


if nargin < 3,
    offsets = 0;
end


% deal with arrays
no = numel(P);
if no>1
    Psliced = cell(size(P));
    parfor i=1:no
        Psliced{i} = P(i).slice(dims, offsets);
    end
    return;
end
        
dim = P.Dim;
if dim<1
    error('Cannot slice with empty polyhedra.');
end
% check dimensions
for i=1:numel(dims)
    validate_dimension(dims(i));
end
if any(dims>P.Dim)
    error('Cannot compute slicing on higher dimension than %i.', P.Dim);
end


%% the algorithm
Psliced(size(offsets)) = Polyhedron;
parfor i=1:length(offsets)
  % Set all dimensions we're not interested in to offset
  I = eye(P.Dim);
  ind = ones(P.Dim,1) == 1; ind(dims) = false;
  tmp = P.intersect(Polyhedron('He',[I(ind,:) offsets(i)*ones(sum(ind),1)]));

  % Project onto the dimensions that we want
  Psliced(i) = tmp.projection(dims);
end


% if P.hasHRep
%   A = P.A; Ae = P.Ae;
%   Psliced = Polyhedron('H',[A(:,dims) P.b], 'He', [Ae(:,dims) P.be]);
% else
%   % Intersect with affine hull
%   I = eye(P.Dim);
%   ind = ones(P.Dim,1) == 1; ind(dims) = false;  
%   Psliced = P.intersect(Polyhedron('He',[I(ind,:) zeros(sum(ind),1)]));
% end

end