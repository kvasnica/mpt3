function test_polyunion_plot_01_pass
% plotting of empty polyunions

p = PolyUnion;
% plot should be silent if no output argument is requested
clear ans
p.plot();
close all
assert(~exist('ans', 'var'));

% handle should be returned if requested
h = p.plot();
close all

end
