% make new figure
figure

grid on

ax = gca;
ax.XAxis.Color = 'r';
ax.YAxis.Color = 'g';
ax.ZAxis.Color = 'b';

view(3)

% Finde cubes with a points
testUnique = unique( OT.PointBins );

% draw all cubes
for i = 1:length( testUnique )
    % check for children
    if (    ~ismember( testUnique(i), OT.BinParents )   && ...
             testUnique(i) > 100 )            %      && ...
%             sum(OT.PointBins(:) == testUnique(i) ) > 100 ...
            
        % read next boundary
        boundary = OT.BinBoundaries( testUnique(i), : );
        % Draw this boundary
        drawCube( boundary, ax);
        
        disp( i );
    end
end