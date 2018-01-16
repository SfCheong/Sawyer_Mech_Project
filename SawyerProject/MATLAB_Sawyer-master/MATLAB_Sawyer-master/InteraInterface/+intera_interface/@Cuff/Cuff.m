classdef Cuff < handle
    % Interface class for cuff on the Intera robots.
    %    
    properties (Access = private)        
        limb    = [];
        device  = [];
        name    = [];
        
        cuff_config_sub = [];
        cuff_io         = [];
    end
    
    methods
        function obj = Cuff( limb )
            % % Constructor.
            % 
            % @type limb:   str
            % @param limb:	limb side to interface

            % Default input values    
            if nargin < 1 || isempty( limb )
                limb = 'right';
            end    

            % Recieve avelable limbs 
            params      = intera_interface.RobotParams();
            limb_names	= params.get_limb_names();

            % If not containe interested limb        
            if isemty( limb_names( limb) )
                % show error
                error( [ 'Cannot detect Cuff''s limb' limb 'on this robot.'
                             ' Valid limbs are ' limb_names '. Exiting Cuff.init().']);                
            else
                % Initialize propertys
                obj.limb   = limb;
                obj.device = [];
                obj.name   = 'cuff';

                % Create subscriber
                obj.cuff_config_sub = rosubscriber( '/io/robot/cuff/config',                    ...
                                                    'intera_core_msgs/IODeviceConfiguration',	...
                                                    @obj.config_callback );

                % Wait for the cuff status to be true
                intera_dataflow.wait_for(   @() isemty( obj.device ),	...
                                            5.0,                        ...
                                            true,                       ...                
                                            [ 'Failed find cuff on limb ' limb ]  );

                obj.cuff_io = IODeviceInterface('robot', obj.name);
            end
        end

        function config_callback(obj, msg)
        % config topic callback
            if msg.device != []
                if str(msg.device.name) == obj.name
                    obj.device = msg.device;
                end
            end           
        end

        function res = lower_button(obj)
        % % Returns a boolean describing whether the lower button on cuff is pressed.
        % 
        % @rtype:   bool
        % @return:  a variable representing button state: (True: pressed, False: unpressed)
            res = bool(obj.cuff_io.get_signal_value('_'.join([obj.limb, 'button_lower'])));
        end

        function res = upper_button( obj )
        %{
            Returns a boolean describing whether the upper button on cuff is pressed.
            (True: pressed, False: unpressed)
            @rtype: bool
            @return:  a variable representing button state: (True: pressed, False: unpressed)
        %}        
            res = bool(obj.cuff_io.get_signal_value('_'.join([ obj.limb, 'button_upper'])));
        end

        function cuff_button(obj)
        %{ 
            Returns a boolean describing whether the cuff button on cuff is pressed.
            (True: pressed, False: unpressed)
            @rtype: bool
            @return:  a variable representing cuff button state: (True: pressed, False: unpressed)
        %}
            res = bool(obj.cuff_io.get_signal_value('_'.join([obj.limb, 'cuff'])));
        end

        function res = register_callback(obj, callback_function, signal_name, poll_rate=10):            
        %{
            Registers a supplied callback to a change in state of supplied
            signal_name's value. Spawns a thread that will call the callback with
            the updated value.

            @type callback_function: function
            @param callback_function: function handle for callback function
            @type signal_name: str
            @param signal_name: the name of the signal to poll for value change
            @type poll_rate: int
            @param poll_rate: the rate at which to poll for a value change (in a separate
                    thread)

            @rtype: str
            @return: callback_id retuned if the callback was registered, and an
                     empty string if the requested signal_name does not exist in the
                     Navigator
        %}
            
            res = obj.cuff_io.register_callback( callback_function, signal_name, poll_rate);
        end

        function res = deregister_callback(obj, callback_id)
        %{
            Deregisters a callback based on the supplied callback_id.

            @type callback_id: str
            @param callback_id: the callback_id string to deregister

            @rtype: bool
            @return: returns bool True if the callback was successfully
                     deregistered, and False otherwise.
        %}

            res = obj.cuff_io.deregister_callback(callback_id);
        end
    end    
end




    