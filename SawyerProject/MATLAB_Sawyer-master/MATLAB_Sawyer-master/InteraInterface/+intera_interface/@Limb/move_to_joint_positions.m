%% (Blocking) Commands the limb to the provided positions.
% Waits until the reported joint state matches that specified.
% This function uses a low-pass filter to smooth the movement.
% 
% @type     positions:      dict({str:float})
% @param	positions:     joint_name:angle command
% @type     timeout:        float
% @param    timeout:       seconds to wait for move to finish [15]
% @type     threshold:      float
% @param    threshold:     position threshold in radians across each joint when
% move is considered successful [0.008726646]
% @param    test:          optional function returning True if motion must be aborted
function res = move_to_joint_positions(   obj, positions, timeout, threshold, test )
    % Organize default values
    if nargin < 5 || isempty( test )
        test = [];
    end
    
    if nargin < 4 || isempty( threshold )
        threshold = 0.008726646; % settings.JOINT_ANGLE_TOLERANCE;
    end
    
    if nargin < 3 || isempty( timeout )
        timeout = 15.0;
    end
    
    res = false;
    
    % Get current angles for all joints
%     cmd = obj.joint_angles;

    % Calculate diff
%     function res = genf( obj, joint, angle)
% 
%         function res = joint_diff()
%             res = abs(angle - obj.joint_angles(joint));
%         end
% 
%         res = joint_diff();
%     end
% 	diffs = [ genf(j, a) for j, a in positions.items() if j in self._joint_angle];

    diffs = containers.Map( obj.joint_angles.keys , ...
                            cellfun(@minus,positions.values ,obj.joint_angles.values,'Un',0) );

    % Check collisions
    fail_msg = [ obj.name ' limb failed to reach commanded joint positions.'];
    
    function res = test_collision( obj, fail_msg )
        res = false;
        if obj.has_collided()
            disp(['Collision detected.', fail_msg] );
            res = true;
        end      
    end

    % Set new joint position
    obj.set_joint_positions(positions);
    % Wait for finish of moiton 
    % res = wait_for( test, timeout, raise_on_error, rate, timeout_msg, body )
    test = @( obj, fail_msg ) ( test_collision( obj, fail_msg )	|  ( isa( test,'function_handle' ) && test() == true ) | ( diffs < threshold  ) );
    intera_dataflow.wait_for(  test(obj, fail_msg),  timeout, fail_msg, 100, false, @() obj.set_joint_positions( positions ) );
    res = true;
end