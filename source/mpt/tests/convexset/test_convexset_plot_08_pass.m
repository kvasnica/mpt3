function test_convexset_plot_08_pass
%
% empty sets
%

x = sdpvar(2,1);
F1 = set( -1<= x <= 2)  + set( x<=-1 );

Y1 = YSet(x,F1);

h = Y1.plot('wire',true,'Marker','x','MarkerSize',5);

if isempty(h)
    error('Must return a handle.');
end

close all

end
