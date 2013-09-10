function S = mpt_geometry_options
%
% Option settings for "geometry module.
%

%% parameters for set methods

% default projection method. Leave empty for automatic selection.
S.sets.Polyhedron.projection.method = '';

%% unions methods
% how many trials to perform in greedy merging
S.unions.polyunion.merge.trials = 1;
S.unions.BinTreePolyUnion.round_places = 12;

end
