function Q = copy(P)
%
% creates a copy of object P
%

% deal with arrays
if numel(P)>1
    parfor i=1:numel(P)
        Q(i)=P(i).copy;
    end
    return
end

% construct non-empty object with minimal arguments such the error is not thrown
Q(size(P)) = Opt('A',P(1).A,'b',P(1).b,'Ae',P(1).Ae,'be',P(1).be,'lb',P(1).lb,'ub',P(1).ub,'M',P(1).M,'q',P(1).q);

% copy remaining elements field by field because struct on object may be disabled in the
% future
np = fieldnames(P);
for i=1:numel(np)
    Q.(np{i}) = P.(np{i});
end

% copy the substructures because object on the struct gives [] for these
Q.recover = P.recover;
Q.varOrder = P.varOrder;
% copy internal data field by field, otherwise it will refer to the same data
if isstruct(P.Internal)
    nf = fieldnames(P.Internal);
    for i=1:numel(nf)
        Q.Internal.(nf{i}) = P.Internal.(nf{i});
    end
else
    Q.Internal = P.Internal;
end
% copy internal data field by field, otherwise it will refer to the same data
if isstruct(P.Data)
    nd = fieldnames(P.Data);
    for i=1:numel(nd)
        Q.Data.(nd{i}) = P.Data.(nd{i});
    end
else
    Q.Data = P.Data;
end


end
