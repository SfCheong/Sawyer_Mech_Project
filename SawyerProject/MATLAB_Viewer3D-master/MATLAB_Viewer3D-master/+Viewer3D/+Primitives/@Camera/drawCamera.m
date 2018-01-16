function handle = drawCamera( obj, axisScale )
% Draw coods **************************************************************
% axesArrows = coodsAxises( axisScale );

% Draw camera *************************************************************
dist    = 1     * axisScale;
w       = 1     * axisScale;
h       = 0.8   * axisScale;

% Make vertices
% vert = [    0       0        0;
%             dist    -w/2     h/2;
%             dist     w/2     h/2;
%             dist    -w/2    -h/2;
%             dist     w/2    -h/2     ];
        
vert = [    0       0        0;
           -w/2     h/2     -dist;
           -w/2    -h/2     -dist;
            w/2    -h/2     -dist;
            w/2     h/2     -dist       ];

% Make faces 
fac = [ 1 2 5 1; 
        1 3 2 1;
        1 3 4 1;
        1 4 5 1;
        2 3 4 5     ];
    
% Make camera patch
cameraPatch = patch(	'Vertices',         vert,   ...
                        'Faces',            fac,    ...
                        'FaceColor',        'none', ...
                        'EdgeColor',        'r'          );

% Make camera group 
handle = hggroup;

% set( axesArrows,  'Parent', handle );
set( cameraPatch, 'Parent', handle );

