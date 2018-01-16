% Circle radius 
radius  = 5;
% Higth
higth   = 4;  
% Angle step
angleStep   = deg2rad( 10 );

% Base coordinate vectors
xVec = [1 0 0];
yVec = [0 1 0];
zVec = [0 0 1];

% Prepear axis coods ******************************************************
point0 = [  0, 0, 0, 1;
            1, 0, 0, 1;
            0, 1, 0, 1;
            0, 0, 1, 1  ]';
          
% % Make scale matrix
% smtx = makehgtform( 'scale',  0.5 );
% % Ponit position
% point0 = smtx * point0( : , 1:end );

figure
grid on;
rotate3d;
        
points = [];
quat   = [];
% Calculate points positions
for angle = 0:angleStep:2*pi
    % Calculate point coordinates
    nextPoint(1) = radius * sin(angle);
    nextPoint(2) = radius * cos(angle); 
    nextPoint(3) = higth;
    
    % Calculate vector
    n   = nextPoint; 
    u   = cross([0 0 1], n);
    v   = cross(n,  u);

    % normalize all vectors
	u = u/norm( u, 2 );
	v = v/norm( v, 2 );
    n = n/norm( n, 2 );
    
%     u = [ u dot( -nextPoint, u )];
% 	v = [ v dot( -nextPoint, v )];
%     n = [ n dot( -nextPoint, n )];    
%    
%     V = [ u; v; n; [0 0 0 1] ]; 
%     V = V^-1;    
%     quat = tform2quat(V);
%     
%     R = [ u; v; n ];    
%     rmtx = rotm2tform ( inv(R) );    
% 	tmtx = trvec2tform( nextPoint );    
%     ftmx = tmtx * rmtx;
%     
%     point =  V * point0( : , 1:end );

    eul(1) = atan2(norm(cross(n,xVec)),dot(n,xVec));
    eul(3) = atan2(norm(cross(v,zVec)),dot(v,zVec));
    eul(2) = atan2(norm(cross(u,yVec)),dot(n,yVec));
           
	tmtx = trvec2tform( nextPoint );    
    rmtx = eul2tform ( eul );     
    ftmx = tmtx * rmtx;
    
	point =  rmtx * point0( : , 1:end );
    point =  tmtx *  point( : , 1:end );
    % Draw axis
    lineAxises( gca, point, 2 );
    
    % Append to list
    points = [ points; nextPoint ];
end


% Plot results
% figure

plot3( points(:,1), points(:,2), points(:,3) );

grid on

