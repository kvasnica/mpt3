function test_polyhedron_computevrep_03_pass
% wrong vertices on a lower-dimensional polyhedron (not normalized)
% reported by Nick Eckenstein on Nov 4, 2016

H = [-1 1.8494502140808 0 38.7833310061572;-64864.4712828676 1 0 804680.596298263];
He = [32.0000000125995 -1 0 -408.282695998769;0.0222166565412465 -0.00069427051658999 -1 -0.021659250486664];
P = Polyhedron('H', H, 'He', He);
V = P.V; % normalizing the polyhedron first yields correct result
Vexp = [-12.4053934346161 11.3101059347531 -0.261799387799243;-12.3115427326148 14.3133283999749 -0.261799387799092];

% the vertices used to be 2x off
assert(norm(sortrows(V)-Vexp)<1e-5);

end
