function test_polyhedron_meshgrid_03_pass
%
% low-dim 2D polyhedron
%

H = [   -0.0433    0.3593    1.0000
   -1.7921    0.2950    1.0000
   -0.3210   -0.2140    1.0000
    1.0281    0.5193    1.0000
    1.7228    1.0891    1.0000
    0.1586    1.4860    1.0000
    0.6903    0.9237    1.0000
    1.0824    0.6559    1.0000
    0.6791   -1.2822    1.0000
   -1.0438   -0.5517    1.0000];
He = [   -0.1051   -0.9945         0];
P = Polyhedron('H',H,'He',He);

[X,Y]=P.meshGrid(10);

Xn = X(:);
Yn = Y(:);
Xn(isnan(Xn))=[];
Yn(isnan(Yn))=[];

P.addFunction(Function(@(x)sqrt(x.^2+1)), 'a');

% containment test first
if any(~P.contains([Xn,Yn]'))
    error('Wrong default value.');
end

% function plot
P.fplot('a',1,'Contour',true)

h=get(gca,'Children');
if isempty(h)
    error('Wrong plot.');
end

close
    

end
