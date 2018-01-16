classdef IOInterface < handle
    %{
        Base class for IO interfaces.
    %}
    
    properties (Access = private)
        path            = [];
            
        config_mutex    = [];
        state_mutex     = [];

        cmd_times       = [];

        ports           = [];
        signals         = [];

        state           = [];
        config          = [];

        state_changed   = [];
        config_changed  = [];

        config_sub      = [];
        state_sub       = [];

        command_pub     = [];
    end
        
    methods
        function obj = IOInterface( path_root, config_msg_type, status_msg_type )

            obj.path            = path_root;
            
            obj.config_mutex    = Lock();
            obj.state_mutex     = Lock();
            
           
            obj.state_changed   = intera_dataflow.Signal();
            obj.config_changed  = intera_dataflow.Signal();

            obj.config_sub	= rosubscriber	( [ obj.path '/config' ], config_msg_type,    @obj.handle_config	);
            obj.state_sub   = rosubscriber	( [ obj.path '/state'  ], status_msg_type,    @obj.handle_state     );
            
            obj.command_pub = rospublisher	( [ obj.path '/command'], 'intera_core_msgs/IOComponentCommand ' );

            % Wait for the state to be populated
            intera_dataflow.wait_for(   @() isempty(obj.state), ...
                                        5.0,                    ...
                                        true,                   ...
                                        'Failed to get state.'          );

            disp( ['Making new IOInterface on ' obj.path ]);
        end

        function invalidate_config( obj )
        %{
            mark the config topic data as invalid
        %}
%             with obj.config_mutex
            obj.config.time.secs = 0;
        end

        function invalidate_state( obj )
        %{
            mark the state topic data as invalid
        %}
%             with obj.state_mutex
            obj.state.time.secs = 0;
        end

        function res = is_config_valid( obj )
        %{
            return true if the config topic data is valid
        %}
            res = ( obj.config.time.secs ~= 0 );
        end

        function res = is_state_valid( obj )
        %{
            return true if the state topic data is valid
        %}
            res = ( obj.state.time.secs ~= 0 );
        end

        function res = is_valid( obj )
        %{
            return true if both the state and config topic data are valid
        %}
            res = obj.is_config_valid() && obj.is_state_valid();
        end

        function res = revalidate( obj , timeout, invalidate_state, invalidate_config )
        %{
            invalidate the state and config topics, then wait up to timeout
            seconds for them to become valid again.
            return true if both the state and config topic data are valid
        %}

            % Initialize default parameters
            if nargin < 4 || isempty(invalidate_config)
                invalidate_config = true;
            end             

            if nargin < 3 || isempty(invalidate_state)
                invalidate_state = true;
            end            
            
            % Invalidate state
            if invalidate_state
                obj.invalidate_state();
            end
            % Invalidate config
            if invalidate_config
                obj.invalidate_config();
            end
            
            % calculate timeout time
            timeout_time = rostime('now') + rosduration(timeout);
            
            hRate = rosrate( 0.1 );
            
            while ~obj.is_state_valid() % && ~rospy.is_shutdown()
                
                sleep( hRate );
                
                if timeout_time < rostime( 'now' )                    
                    warning('Timed out waiting for node interface valid...');
                    res = false;
                    return;
                end
            end
                    
            res = true;
        end

        function handle_config( obj , msg)
        %{
            config topic callback
        %}
            if ~obj.config || obj.time_changed(obj.config.time, msg.time)
%                 with obj.config_mutex
                    obj.config = msg;
                    obj.config_changed();
            end
        end

%         function load_state( obj , current_state, incoming_state)
%             
%             for incoming_state
%                 
%                 if isempty( current_state( state.name ) )
%                     current_state(state.name) = [];
%                 end
%                 
% %                 formatting = json.loads( state.format );
%                 
%                 current_state(state.name).type  = 'type';
%                 current_state(state.name).role  = 'role';
% 
% %                 data = json.loads(state.data)
%                 
%                 current_state(state.name).data  = data[0] if len(data) > 0 else None end
%                 end
                

%         function handle_state( obj , msg)
%             %{
%             state topic callback
%             %}
%             if not obj.state or _time_changed(obj.state.time, msg.time)
%                 with obj.state_mutex
%                     obj.state = msg
%                     obj.state_changed()
%                     obj.load_state(obj.ports,   obj.state.ports)
%                     obj.load_state(obj.signals, obj.state.signals)

        function res = publish_command( obj , op, args, timeout )
        %{
            publish on the command topic
            return true if the command is acknowleged within the timeout
        %}
            
            % Initialize default parameters
            if nargin < 4 || isempty(timeout)
                timeout = 2.0;
            end             

            cmd_time = rostime( 'now' );
            obj.cmd_times = [ obj.cmd_times cmd_time ];
            
            % leave only las 100 time marks ? 
            obj.cmd_times = obj.cmd_times[-100:];
            
            cmd_msg = IOComponentCommand( cmd_time, op,json.dumps(args) );                
                
            warning( [ 'publish_command' cmd_msg.op, cmd_msg.arg ] );
            
            if ~isemty(timeout)
                
                timeout_time = rostime( 'now' ) + rosduration( timeout );
                
                while 1 % ~rospy.is_shutdown()
                    
                    send( obj.command_pub, cmd_msg );
                    
                    if obj.is_state_valid()
                        
                        if obj.state.commands(cmd_time)
                            warning(['command ' cmd_msg.op ' acknowleged']);
                            res = true;
                            return;
                        end
                    end
                        
                    sleep(0.1);
                    
                    if timeout_time < rostime( 'now' )
                        worning('Timed out waiting for command acknowlegment...');
                        break;
                    end
                    
                    res = false;
                    return;
                end
            
                res = true;
            end
        end
                    
    
        function res = time_changed( time1, time2 )
        %{
            return true if the times are different
        %}
        	res = (time1.secs ~= time2.secs) ||  (time1.nsecs ~= time2.nsecs);
        end
        
    end
end

