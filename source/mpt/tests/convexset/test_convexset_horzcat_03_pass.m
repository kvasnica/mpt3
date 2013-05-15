function test_convexset_horzcat_03_pass
%
% same objects, matrix concatenation
%

x = sdpvar(2,1);
F1 = set(x>=0); 
F2 = set(x'*x-x <=1);
F3 = set( -1<=0.123*pi./x <= 1);
F4 = set( 0 <= x <= 1);
Y1 = YSet(x,F1);
Y2 = YSet(x,F2);
Y3 = YSet(x,F3);
Y4 = YSet(x,F4);


Set = [Y1,Y2;Y3, Y4];


if size(Set,1)~=4
    error('Must be concatentenated into a column.');
end

end
