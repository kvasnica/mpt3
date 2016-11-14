function D = iSetDiff(A,B)
%
% D = iSetDiff(A,B)
%
% Fast set difference for interger sets
%

%D = setdiff(A,B);
%return;

if(isempty(B)) D = A;  return; end;
if(isempty(A)) D = []; return; end;

D = iSetDiff_c(sort(A),sort(B));
D = D';
return;

if(isempty(B)) D = A;  return; end;
if(isempty(A)) D = []; return; end;

D = [];
for i=[1:length(A)]
    if(isempty(find(B - A(i) == 0)))
        D = [D A(i)];
    end;
end;

