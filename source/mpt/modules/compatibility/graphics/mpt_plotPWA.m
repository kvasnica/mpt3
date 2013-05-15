function handle=mpt_plotPWA(PA,Fi,Gi,Options)
%MPT_PLOTPWA Plots a PWA function defined over a given polyhedral partition
%
% THIS FUNCTION IS OBSOLETE!
%
% Use PolyUnion/fplot() instead.

mpt_obsoleteFunction;

error(nargchk(3,4,nargin));

if ~isa(PA,'polytope')
    error('mpt_plotPWA: First input argument MUST be a polytope');
end

Q = toPolyhedron(PA);
Q.removeAllFunctions();
for i = 1:numel(Q)
	Q(i).addFunction(AffFunction(Fi{i}, Gi{i}), 'pwa');
end
Q.fplot;
