function test_polyhedron_meshgrid_05_pass
%
% ellipse cut
%

t = -pi:0.1:pi;

x = 2*sin(-0.2*t+pi/6);
y = 2*cos(-0.2*t+pi/6);

P = Polyhedron([x(:),y(:)]);

% grid
[X,Y]=P.meshGrid;

Xn = X(:);
Yn = Y(:);
Xn(isnan(Xn))=[];
Yn(isnan(Yn))=[];

P.addFunction(Function(@(x)2*x.^4-0.5*x.^3-3.5*x-1), 'a');

% containment test first
if any(~P.contains([Xn,Yn]))
    error('Wrong default value.');
end

% function plot
P.fplot('a',1,'Contour',true,'Polyhedron',true)

h=get(gca,'Children');
if isempty(h)
    error('Wrong plot.');
end

close
    

end
