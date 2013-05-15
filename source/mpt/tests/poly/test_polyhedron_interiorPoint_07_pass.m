function test_polyhedron_interiorPoint_07_pass
%
% unbounded sets
%

global MPTOPTIONS

P(1) = Polyhedron('H',rand(4,5),'He',[1.5 -2.9 0.4 0  -1]);
P(2) = Polyhedron('V',randn(5,4),'R',[0 0.1 -0.3 0.5; 0.5 -0.1 0.2  0.8]);

res = P.interiorPoint;

if res{1}.r<MPTOPTIONS.infbound
    error('Unbounded set returns infbound on radius for H-rep.');
end
if ~isempty(res{2}.r)
    error('Unbounded set returns [] for V-rep.');
end

end