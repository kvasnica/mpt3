function B = outerApprox(U)
%
% Bounding box for union of polyhedra
%

global MPTOPTIONS
if isempty(MPTOPTIONS)
    MPTOPTIONS = mptopt;
end

% deal with arrays
if numel(U)>1
    B(size(U)) = Polyhedron;
    for i=1:numel(U)
        B(i) = U(i).outerApprox;
    end
    return;
end

% if there is 0 sets contained, return empty polyhedron
if U.Num<1
    B = Polyhedron;
    return
end


% single bounding box for arrays
BP = U.Set.outerApprox;
d = U.Dim;
lb = Inf(d, 1);
ub = -Inf(d, 1);
for i = 1:length(BP)
    lb = min(lb, BP(i).Internal.lb);
    ub = max(ub, BP(i).Internal.ub);
end

Hbox = [eye(d) ub; -eye(d) -lb];

B = Polyhedron(Hbox(:, 1:end-1), Hbox(:, end));

% store internally
B.setInternal('lb',lb);
B.setInternal('ub',ub);


end
