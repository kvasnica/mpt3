function test_polyunion_locatePoint_01_pass
%
% empty polyunion
% 

U = PolyUnion;

U.locatePoint([]);

U.locatePoint(12);

[a,b]=U.locatePoint([2;3]);

U(1) = [];
U.locatePoint([]);
U.locatePoint([1;-2;NaN]);

end