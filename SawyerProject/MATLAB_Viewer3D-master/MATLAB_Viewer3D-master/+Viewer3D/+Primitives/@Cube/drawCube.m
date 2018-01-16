function drawCube( points, ax )
%DRAWCUBE Summary of this function goes here
%   Detailed explanation goes here

    axes(ax);

    Xmin = points(1);
    Ymin = points(2);
    Zmin = points(3);

    Xmax = points(4);
    Ymax = points(5);
    Zmax = points(6);

    x=[ Xmin Xmax Xmax Xmin Xmin Xmin;
        Xmax Xmax Xmin Xmin Xmax Xmax;
        Xmax Xmax Xmin Xmin Xmax Xmax;
        Xmin Xmax Xmax Xmin Xmin Xmin ];

    y=[ Ymin Ymin Ymax Ymax Ymin Ymin;
        Ymin Ymax Ymax Ymin Ymin Ymin;
        Ymin Ymax Ymax Ymin Ymax Ymax;
        Ymin Ymin Ymax Ymax Ymax Ymax ];

    z=[ Zmin Zmin Zmin Zmin Zmin Zmax;
        Zmin Zmin Zmin Zmin Zmin Zmax;
        Zmax Zmax Zmax Zmax Zmin Zmax;
        Zmax Zmax Zmax Zmax Zmin Zmax ] ;

    h = patch( x, y, z, 'green' );
        set( h, 'edgecolor', 'black' )

end

