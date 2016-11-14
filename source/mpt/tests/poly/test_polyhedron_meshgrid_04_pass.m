function test_polyhedron_meshgrid_04_pass
%
% affine set in 2D
%

% P is just one point
P = Polyhedron('Ae',[-1 -0.4;0 3.1],'be',[-0.1;0.5],'lb',[-2;-3],'ub',[2;3]);

% grid
[X,Y]=P.meshGrid;

Xn = X(:);
Yn = Y(:);
Xn(isnan(Xn))=[];
Yn(isnan(Yn))=[];

P.addFunction(Function(@(x)x), 'a');

% containment test first
if any(~P.contains([Xn,Yn]'))
    error('Wrong default value.');
end

% function plot
P.fplot;

h=get(gca,'Children');
if numel(h)~=1
    error('Wrong plot.');
end

close
    

end
