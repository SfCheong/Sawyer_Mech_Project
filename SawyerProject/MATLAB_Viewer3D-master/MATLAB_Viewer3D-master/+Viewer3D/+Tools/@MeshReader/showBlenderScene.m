%% Open data **************************************************************
% dataReading

%% Load STL mesh **********************************************************
% Import an STL mesh, returning a PATCH-compatible face-vertex structure
fv = stlread( [slamData.projectPath 'blender_scene/ColoredCubs.stl'] );

%% Render *****************************************************************
% The model is rendered with a PATCH graphics object. We also add some dynamic
% lighting, and adjust the material properties to change the specular
% highlighting.

patch(fv,'FaceColor',       [0.8 0.8 1.0], ...
         'EdgeColor',       'none',        ...
         'FaceLighting',    'gouraud',     ...
         'AmbientStrength', 0.15);

% Add a camera light, and tone down the specular highlighting
camlight('headlight');
material('dull');

% Fix the axes scaling, and set a nice view angle
axis('image');
view([-135 35]);
