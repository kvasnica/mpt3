function test_union_contains_01_pass
%
% two overlapping Ysets
%

x = sdpvar(1,1);
Y1 = YSet(x, [-1 <= x <= 1]);
Y2 = YSet(x, [0 <= x <= 2]);
U = Union([Y1 Y2]);

% point outside (closer to Y2)
x = 10;
isin = U.contains(x);
assert(~isin);
[isin, inwhich] = U.contains(x);
assert(~isin);
assert(isempty(inwhich));
[isin, inwhich, closest] = U.contains(x);
assert(~isin);
assert(isempty(inwhich));
assert(closest==2);

% point outside (closer to Y1)
x = -10;
isin = U.contains(x);
assert(~isin);
[isin, inwhich] = U.contains(x);
assert(~isin);
assert(isempty(inwhich));
[isin, inwhich, closest] = U.contains(x);
assert(~isin);
assert(isempty(inwhich));
assert(closest==1);

% point in Y1
x = -1;
isin = U.contains(x);
assert(isin);
[isin, inwhich] = U.contains(x);
assert(isin);
assert(inwhich==1);
[isin, inwhich, closest] = U.contains(x);
assert(isin);
assert(inwhich==1);
assert(isempty(closest));

% point in Y2
x = 2;
isin = U.contains(x);
assert(isin);
[isin, inwhich] = U.contains(x);
assert(isin);
assert(inwhich==2);
[isin, inwhich, closest] = U.contains(x);
assert(isin);
assert(inwhich==2);
assert(isempty(closest));

% point in Y1 and Y2, no fastbreak
x = 0;
isin = U.contains(x);
assert(isin);
[isin, inwhich] = U.contains(x);
assert(isin);
assert(isequal(inwhich, [1 2]));
[isin, inwhich, closest] = U.contains(x);
assert(isin);
assert(isequal(inwhich, [1 2]));
assert(isempty(closest));

% point in Y1 and Y2, fastbreak
x = 0;
isin = U.contains(x, true);
assert(isin);
[isin, inwhich] = U.contains(x, true);
assert(isin);
assert(inwhich==1);
[isin, inwhich, closest] = U.contains(x, true);
assert(isin);
assert(inwhich==1);
assert(isempty(closest));

end
