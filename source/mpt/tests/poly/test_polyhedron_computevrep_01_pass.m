function test_polyhedron_computevrep_01_pass
% wrong vertices returned if input is not in minimal representation (issue
% #131)

A = [-0.584244044911839 0.811578028278891;-0.581748755912863 -0.813368541925391;0.161600880466547 -0.986856197950054;0.196855913174092 0.980432429822879;-0.202168114540521 -0.979350832675977;0.817061220440044 0.576550918872762;-0.273481171810843 -0.961877356353173;0.196202427019426 0.98056341336585;0.817409491173812 -0.576057049031578;0.0239458707305332 0.999713256526568;0 -1;1 0;0.584244044911839 -0.811578028278891;0.581748755912863 0.813368541925391;-0.161600880466547 0.986856197950054;-0.196855913174092 -0.980432429822879;0.202168114540521 0.979350832675977;-0.817061220440044 -0.576550918872762;0.273481171810843 0.961877356353173;-0.196202427019426 -0.98056341336585;-0.817409491173812 0.576057049031578;-0.0239458707305332 -0.999713256526568;0 1;-1 0];
b = [-0.0147028983679255;-0.162846895009167;-0.0537024887672983;0.263158724006511;-0.113489306518343;0.376144807663179;-0.12388405992409;0.262982016948695;0.145461315684078;0.213237595389724;-0.0816492769363041;0.319067958018169;0.0309107745558671;0.348740110120525;0.152860196759389;-0.112697020248007;0.264591715027993;-0.179704654139771;0.28322077559221;-0.112599387231301;-0.0791849293194631;-0.0856079709429027;0.205846127144337;-0.158367162692208];
P = Polyhedron(A, b);
P.computeVRep();
P.minVRep();
% must have 14 vertices (6 if things went wrong)
assert(size(P.V, 1)>=14);
% make sure all points are really vertices
for i = 1:size(P.V, 1)
    x = P.V(i, :)';
    assert(abs(max(P.A*x-P.b))<1e-6);
end

A = [0.826447623734575 -0.563013610158294;-0.963173102635576 -0.268882082629837;0.833300780139572 -0.552819871041899;-0.827320210369012 0.561730602259637;0.826508965578608 -0.562923555927604;0.861098671163579 -0.508437880689784;0.826709560151865 -0.562628921362482;0.964112998186042 -0.265492234780457;0.826467918135788 -0.562983818854767;-0.929749379485362 0.368193008280419;0 -1;1 0;-0.826447623734575 0.563013610158294;0.963173102635576 0.268882082629837;-0.833300780139572 0.552819871041899;0.827320210369012 -0.561730602259637;-0.826508965578608 0.562923555927604;-0.861098671163579 0.508437880689784;-0.826709560151865 0.562628921362482;-0.964112998186042 0.265492234780457;-0.826467918135788 0.562983818854767;0.929749379485362 -0.368193008280419;0 1;-1 0];
b = [-6.85682004106228;-0.791634171514845;-6.77132494630712;7.4649251374631;-6.85607599373548;-6.37284435767276;-6.85363365136434;-4.04780247478765;-6.85657414745578;5.58977011508292;-9.49454783041348;-1.28267626531033;7.47790484104065;1.61161165248767;7.37523980682868;-6.84615029361373;7.47698924611956;6.94782624768934;7.47400133232775;4.59113783853541;7.47760170505608;-5.05833261756487;11.1634640052372;1.9891379212943];
P = Polyhedron(A, b);
P.computeVRep();
P.minVRep();
% must have 20 vertices (3 if things went wrong)
assert(size(P.V, 1)==20);
% make sure all points are really vertices
for i = 1:size(P.V, 1)
    x = P.V(i, :)';
    assert(abs(max(P.A*x-P.b))<1e-6);
end

end
