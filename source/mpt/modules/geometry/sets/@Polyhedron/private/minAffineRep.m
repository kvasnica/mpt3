function obj = minAffineRep(obj)
% MINAFFINEREP Compute a minimum representation for the affine set
%

global MPTOPTIONS
if isempty(MPTOPTIONS)
    MPTOPTIONS = mptopt;
end

if size(obj.He_int,1) == 0,
    return;
end;

r = rank(obj.He_int,MPTOPTIONS.abs_tol);
if r == size(obj.He_int,1),
    return;
end; % Already minimal

% Choose r linearly independant rows of He
% Note: We don't do any factorizations here, since that can cause fill-in
% of the matrices.
nHe = zeros(r,obj.Dim+1);
k=1;
for i=1:size(obj.He_int,1)
    if rank([nHe;obj.He_int(i,:)],MPTOPTIONS.abs_tol) > k-1
        nHe(k,:) = obj.He_int(i,:);
        k=k+1;
    end
    if k >r, break; end
end
obj.He_int = nHe;

end
