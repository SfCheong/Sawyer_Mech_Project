function Joints = initializeJoints( obj )
%INITIALIZEJOINTS Summary of this function goes here
%   Detailed explanation goes here

    % Point 1 *****************************************************************
    obj.Joints(1).translationVec    = [0 0 0];      % Position vector
    obj.Joints(1).length            = 0;            % Langth of rotation

    obj.Joints(1).rotationVec       = [0 0 1];      % Rotation vector
    obj.Joints(1).rotationAngle     = 0;            % Angle

    obj.Joints(1).axisScale         = 0.1;          % Axis scale

    % Point 2 *****************************************************************
    obj.Joints(2).translationVec    = [0 0 1];     	% Position vector
    obj.Joints(2).length            = 0.317;       	% Langth of rotation

    obj.Joints(2).rotationVec       = [0 0 1];     	% Rotation vector
    obj.Joints(2).rotationAngle     = 0;          	% Angle

    obj.Joints(2).axisScale         = 0.05;       	% Axis scale

    % Point 3 *****************************************************************
    obj.Joints(3).translationVec    = [1 0 0];      % Position vector
    obj.Joints(3).length            = 0.081;        % Langth of rotation

    obj.Joints(3).rotationVec       = [0 1 0];      % Rotation vector
    obj.Joints(3).rotationAngle     = 0;            % Angle

    obj.Joints(3).axisScale         = 0.1;          % Axis scale

    % Point 4 *****************************************************************
    obj.Joints(4).translationVec    = [0 1 0];      % Position vector
    obj.Joints(4).length            = 0.1925;       % Langth of rotation

    obj.Joints(4).rotationVec       = [0 1 0];      % Rotation vector
    obj.Joints(4).rotationAngle     = 0;            % Angle

    obj.Joints(4).axisScale         = 0.1;          % Axis scale

    % Point 5 *****************************************************************
    obj.Joints(5).translationVec    = [1 0 0];      % Position vector
    obj.Joints(5).length            = 0.4;        	% Langth of rotation

    obj.Joints(5).rotationVec       = [1 0 0];      % Rotation vector
    obj.Joints(5).rotationAngle     = 0;            % Angle

    obj.Joints(5).axisScale         = 0.1;          % Axis scale

    % Point 6 *****************************************************************
    obj.Joints(6).translationVec    = [0 1 0];      % Position vector
    obj.Joints(6).length            = -0.1685;      % Langth of rotation

    obj.Joints(6).rotationVec       = [0 1 0];      % Rotation vector
    obj.Joints(6).rotationAngle     =  0;           % Angle

    obj.Joints(6).axisScale         = 0.1;          % Axis scale

    % Point 7 *****************************************************************
    obj.Joints(7).translationVec    = [1 0 0];      % Position vector
    obj.Joints(7).length            =  0.4;         % Langth of rotation

    obj.Joints(7).rotationVec       = [1 0 0];      % Rotation vector
    obj.Joints(7).rotationAngle     =  0;           % Angle

    obj.Joints(7).axisScale         = 0.1;          % Axis scale

    % Point 8 *****************************************************************
    obj.Joints(8).translationVec    = [0 1 0];      % Position vector
    obj.Joints(8).length            = 0.1363;       % Langth of rotation

    obj.Joints(8).rotationVec       = [1 0 0];      % Rotation vector
    obj.Joints(8).rotationAngle     = 0;            % Angle

    obj.Joints(8).axisScale         = 0.1;          % Axis scale

    % Point 9 *****************************************************************
    obj.Joints(9).translationVec    = [1 0 0];      % Position vector
    obj.Joints(9).length            =  0.13375;     % Langth of rotation

    obj.Joints(9).rotationVec       = [1 0 0];      % Rotation vector
    obj.Joints(9).rotationAngle     =  0;           % Angle

    obj.Joints(9).axisScale         = 0.1;          % Axis scale
    
    Joints = obj.Joints;
end

