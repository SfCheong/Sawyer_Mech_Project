classdef IODeviceInterface < IOInterface
    %IODEVICEINTERFACE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties ( Access = private )
    end
    
    methods
    %{
        IO Device interface to config, status and command topics
    %}
        function obj = IODeviceInterface(self, node_name, dev_name)
            super(IODeviceInterface, self).__init__(
                'io/' + node_name + '/' + dev_name,
                IODeviceConfiguration,
                IODeviceStatus)

            obj.config_msg	= IODeviceConfiguration()
            obj.state_msg  = IODeviceStatus()

            obj.invalidate_config()
            obj.invalidate_state()
            obj.threads = dict()
            obj.callback_items = dict()
            obj.callback_functions = dict()
        end

        function res = list_signal_names(obj)
        %{
            return a list of all signals
        %}
    %         with obj.state_mutex
                res = copy.deepcopy( obj.signals.keys() );
        end

        function res = get_signal_type(obj, signal_name)
        %{
            return the status for the given signal, or none
        %}
    %         with obj.state_mutex
                if ~isemty( obj.signals.keys( signal_name ) )
                    res = copy.deepcopy(obj.signals[signal_name]['type']);
                else 
                    res =[];
                end
        end

    function get_signal_value(obj, signal_name)
        %{
        return the status for the given signal, or none
        %}
%         with obj.state_mutex
            if signal_name in obj.signals.keys()
                return copy.deepcopy(obj.signals[signal_name]['data'])
        return None

    function set_signal_value(obj, signal_name, signal_value, signal_type=None, timeout=5.0)
        %{
        set the value for the given signal
        return True if the signal value is set, False if the requested signal is invalid
        %}
        if signal_name not in obj.list_signal_names()
            rospy.logerr("Cannot find signal '{0}' in this IO Device.".format(signal_name))
            return
        if signal_type == None
            s_type = obj.get_signal_type(signal_name)
            if s_type == None
                rospy.logerr("Failed to get 'type' for signal '{0}'.".format(signal_name))
                return
        else
            s_type = signal_type
        set_command = SetCommand().set_signal(signal_name, s_type, signal_value)
        obj.publish_command(set_command.op, set_command.args, timeout=timeout)
        # make sure both state and config are valid
        obj.revalidate(timeout, invalidate_state=False, invalidate_config=False)

    function list_port_names(obj)
        %{
        return a list of all ports
        %}
        with obj.state_mutex
            return copy.deepcopy(obj.ports.keys())

    function get_port_type(obj, port_name)
        %{
        return the status for the given port, or none
        %}
        with obj.state_mutex
            if port_name in obj.ports.keys()
                return copy.deepcopy(obj.ports[port_name]['type'])
        return None

    function get_port_value(obj, port_name)
        %{
        return the status for the given port, or none
        %}
        with obj.state_mutex
            if port_name in obj.ports.keys()
                return copy.deepcopy(obj.ports[port_name]['data'])
        return None

    function set_port_value(obj, port_name, port_value, port_type=None, timeout=5.0)
        %{
        set the value for the given port
        return True if the port value is set, False if the requested port is invalid
        %}
        if port_name not in list_port_names()
            rospy.logerr("Cannot find port '{0}' in this IO Device.".format(port_name))
            return
        if port_type == None
            p_type = obj.get_port_type(port_name)
            if p_type == None
                rospy.logerr("Failed to get 'type' for port '{0}'.".format(port_name))
                return
        else
            p_type = port_type
        set_command = SetCommand().set_port(port_name, p_type, port_value)
        obj.publish_command(set_command.op, set_command.args, timeout=timeout)
        # make sure both state and config are valid
        obj.revalidate(timeout, invalidate_state=False, invalidate_config=False)

    function register_callback(obj, callback_function, signal_name, poll_rate=10)
        %{
        Registers a supplied callback to a change in state of supplied
        signal_name's value. Spawns a thread that will call the callback with
        the updated value.
        @type: function
        @param: function handle for callback function
        @type: str
        @param: the signal name (button or wheel) to poll for value change
        @type: int
        @param: the rate at which to poll for a value change (in a separate
                thread)
        @rtype: str
        @return: callback_id retuned if the callback was registered, and an
                 empty string if the requested signal_name does not exist in the
                 Navigator
        %}
        if signal_name in obj.list_signal_names()
            callback_id = uuid.uuid4()
            obj.callback_items[callback_id] = intera_dataflow.Signal()
            function signal_spinner()
                old_state = obj.get_signal_value(signal_name)
                r = rospy.Rate(poll_rate)
                while not rospy.is_shutdown()
                  new_state = obj.get_signal_value(signal_name)
                  if new_state != old_state
                      obj.callback_items[callback_id](new_state)
                  old_state = new_state
                  r.sleep()
            obj.callback_items[callback_id].connect(callback_function)
            t = threading.Thread(target=signal_spinner)
            t.daemon = True
            t.start()
            obj.threads[callback_id] = t
            obj.callback_functions[callback_id] = callback_function
            return callback_id
        else
            return str()

    function deregister_callback(obj, callback_id)
        %{
        Deregisters a callback based on the supplied callback_id.
        @type: str
        @param: the callback_id string to deregister
        @rtype: bool
        @return: returns bool True if the callback was successfully
                 deregistered, and False otherwise.
        %}
        if callback_id in obj.threads.keys()
            obj.callback_items[callback_id].disconnect(
                              obj.callback_functions[callback_id])
            return True
        else
            return False

    end
    
end

