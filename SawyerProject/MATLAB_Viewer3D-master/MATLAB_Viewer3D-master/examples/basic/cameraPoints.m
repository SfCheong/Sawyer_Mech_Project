%% CLEAR ALL **************************************************************
clc             % Clear command window
clear           % Clear all variables
close all       % Close all figures

axisScale	= 1;

dist    = 1     * axisScale;
w       = 1     * axisScale;
h       = 0.8   * axisScale;

vert = [    0       0        0;
           -w/2     h/2     -dist;
           -w/2    -h/2     -dist;
            w/2    -h/2     -dist;
            w/2     h/2     -dist       ];

% Make faces 
% fac = [ 1 2 5 1; 
%         1 3 2 1;
%         1 3 4 1;
%         1 4 5 1;
%         2 3 4 5     ];

camera = [];

camera = [ camera; vert( 1 ,: ) ];
camera = [ camera; vert( 2 ,: ) ];
camera = [ camera; vert( 5 ,: ) ];
camera = [ camera; vert( 1 ,: ) ];

camera = [ camera; vert( 1 ,: ) ];
camera = [ camera; vert( 3 ,: ) ];
camera = [ camera; vert( 2 ,: ) ];
camera = [ camera; vert( 1 ,: ) ];

camera = [ camera; vert( 1 ,: ) ];
camera = [ camera; vert( 3 ,: ) ];
camera = [ camera; vert( 4 ,: ) ];
camera = [ camera; vert( 1 ,: ) ];

camera = [ camera; vert( 1 ,: ) ];
camera = [ camera; vert( 4 ,: ) ];
camera = [ camera; vert( 5 ,: ) ];
camera = [ camera; vert( 1 ,: ) ];

camera = [ camera; vert( 2 ,: ) ];
camera = [ camera; vert( 3 ,: ) ];
camera = [ camera; vert( 4 ,: ) ];
camera = [ camera; vert( 5 ,: ) ];

plot3( camera(:,1), camera(:,2), camera(:,3) );

grid on


view(3)


