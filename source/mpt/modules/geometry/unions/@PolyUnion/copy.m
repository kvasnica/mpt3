function Un = copy(U)
%
% creates a new copy of the PolyUnion object
%

% deal with arrays
if numel(U)>1
    Un(size(U)) = PolyUnion;
    parfor i=1:numel(U)
        Un(i) = U(i).copy;
    end
    return;
end

if numel(U)==0
    % for empty array return empty polyunion
    Un = PolyUnion;
    return
end

if isempty(U.Set)
    % for empty array return empty polyunion
    Un = PolyUnion;
    return;
end

Un = PolyUnion(Polyhedron(U.Set));

% copy internal data field by field, otherwise it will refer to the same data
if isstruct(U.Internal)
    nf = fieldnames(U.Internal);
    for i=1:numel(nf)
        Un.Internal.(nf{i}) = U.Internal.(nf{i});
    end
else
    Un.Internal = U.Internal;
end

if isstruct(U.Data)
    nd = fieldnames(U.Data);
    for i=1:numel(nd)
        Un.Data.(nd{i}) = U.Data.(nd{i});
    end
else
    Un.Data = U.Data;
end

end
