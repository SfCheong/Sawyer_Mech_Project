function updateInputAngleForms( obj, hObject, eventdata, handles )
%UPDATEINPUTANGLEFORMS Summary of this function goes here
%   Detailed explanation goes here

    % Find joint name     
    objectName      = hObject.Tag;
    objectNumber	= strsplit( objectName, {'edit', 'slider'});
    objectNumber    = objectNumber{1,2};
    
    if contains( objectName, 'edit')
        % Get value 
        jointValue =  str2double( get( hObject, 'String' ) );        
        % Set text in edit box
        handle = findobj( 'Tag', ['slider'  objectNumber] );                
        set( handle, 'Value', jointValue );
    else
        % Get value 
        jointValue =  get( hObject, 'Value' );
        % Set text in edit box
        handle = findobj( 'Tag', ['edit'  objectNumber]  );                
        set( handle, 'String', num2str( jointValue ) );
    end
    
    % Read all sliders values
    angles = deg2rad(  [	handles.slider2.Value
                            handles.slider4.Value
                            handles.slider5.Value
                            handles.slider6.Value
                            handles.slider7.Value
                            handles.slider8.Value
                            handles.slider9.Value   ] );
   
    % Set value to model
    obj.hRobotTargetState.setJointAngle( angles );   
    
    % Create new joint position class
    jointState = LeonaRT.JointState();
%     jointState.setAngles( obj.robotCurrentState.getAngles() );
    jointState.setAngles( angles );
	% Update target 
    obj.hSawyerMotionController.setPosition( jointState );
    
% 	% Redraw 
% 	obj.hScene.redraw();
    
	% debug output
% 	disp(  ['Joint ' objectNumber ': ' num2str( jointValue )] );
    
    % Update handles structure
    % guidata(hObject, handles); ??
end

