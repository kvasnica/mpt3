function test_polyunion_locatePoint_02_fail
%
% polyunion with overlaps
% 

for i=1:3
    P(i) = ExamplePoly.randVrep('d',3);
end

U = PolyUnion('Set',P);
U.isOverlapping;

% put adj list to check if the error for the union properties is displayed
U.setInternal('adj_list',{});

U.locatePoint(randn(1,3));


end