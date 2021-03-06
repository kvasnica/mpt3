function display(obj)
%
% display function
%

if numel(obj) > 1
    fprintf('Array of %i PolyUnions.\n', numel(obj));
    return
elseif numel(obj)==0
    fprintf('Empty array of PolyUnions.\n');
    return;
end    
if numel(obj.Set)==0
    fprintf('Empty PolyUnion.\n');
    return;
end

fprintf('PolyUnion in the dimension %d with %d polyhedra.\n', obj.Dim, obj.Num);
if ~isempty(obj.Internal.Convex) || ...
    ~isempty(obj.Internal.Overlaps) || ...
    ~isempty(obj.Internal.Connected) || ...
    ~isempty(obj.Internal.Bounded) || ...
    ~isempty(obj.Internal.FullDim)
    fprintf('Properties of the union: \n');
end
if ~isempty(obj.Internal.Convex)
    fprintf('  Convex: %d\n', obj.Internal.Convex);
end
if ~isempty(obj.Internal.Overlaps)
    fprintf('  Overlaps: %d\n', obj.Internal.Overlaps);
end
if ~isempty(obj.Internal.Connected)
    fprintf('  Connected: %d\n', obj.Internal.Connected);
end
if ~isempty(obj.Internal.Bounded)
    fprintf('  Bounded: %d\n', obj.Internal.Bounded);
end
if ~isempty(obj.Internal.FullDim)
    fprintf('  FullDim: %d\n', obj.Internal.FullDim);
end

% display functions (implemented in Union/displayFunctions)
obj.displayFunctions;

end
