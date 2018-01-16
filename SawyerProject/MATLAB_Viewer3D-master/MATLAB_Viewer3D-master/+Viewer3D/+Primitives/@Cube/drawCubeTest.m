%% Clear 
close all
% s=input('side: ');


%% Make new figure
figure

ax = gca;
grid on

set( ax, 'xlim', [-5, 5] );
set( ax, 'ylim', [-5, 5] );
set( ax, 'zlim', [0 , 5] );

view(3)


drawCube( [0 0 0 1 1 1], ax )

s = 1;

x=[ 0 1 1 0 0 0;
    1 1 0 0 1 1;
    1 1 0 0 1 1;
    0 1 1 0 0 0 ] * s;

y=[ 0 0 1 1 0 0;
    0 1 1 0 0 0;
    0 1 1 0 1 1;
    0 0 1 1 1 1 ] * s;

z=[ 0 0 0 0 0 1;
    0 0 0 0 0 1;
    1 1 1 1 0 1;
    1 1 1 1 0 1]  * s;

h = patch( x, y, z, 'green' );
    set( h, 'edgecolor', 'black' )

% for each patch
% for i = 1:6
%     h = patch( x(:,i), y(:,i), z(:,i), 'green' );
%     set( h, 'edgecolor', 'black' )
% end 

s = 2;

x1 = x * s;
y1 = y * s;
z1 = z * s;

h = patch( x1, y1, z1, 'green' );
    set( h, 'edgecolor', 'black' )
    
% for each patch
% for i = 1:6
%     h = patch( x(:,i), y(:,i), z(:,i), 'green' );
%     set( h, 'edgecolor', 'black' )
% end 
