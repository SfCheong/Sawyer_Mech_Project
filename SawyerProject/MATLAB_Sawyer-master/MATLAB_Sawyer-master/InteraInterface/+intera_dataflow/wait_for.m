function res = wait_for( test, timeout, raise_on_error, rate, timeout_msg, body )
%% Waits until some condition evaluates to true.
% 
% @param test:              zero param function to be evaluated
% @param timeout:           max amount of time to wait. negative/inf for indefinitely
% @param raise_on_error:    raise or just return False
% @param rate:              the rate at which to check
% @param timout_msg:        message to supply to the timeout exception
% @param body:              optional function to execute while waiting
    if nargin < 6 || isempty(body)
        body = [];
    end

    if nargin < 5 || isempty(timeout_msg)
        timeout_msg = 'timeout expired';
    end

    if nargin < 4 || isempty(rate)
        rate = 100;
    end

    if nargin < 3 || isempty(raise_on_error)
        raise_on_error = true;
    end

    if nargin < 2 || isempty(timeout)
        timeout = 1.0;
    end

    if nargin < 1 || isempty(test)
        test = [];
    end

    % Result by default    
    res = false;

    % Calculate time of timeout
    end_time    = rostime('now') + timeout;
    % Create rate time 
    hRate        = rosrate(rate);
    % Is timeout?
    % notimeout   = (timeout < 0.0) || timeout == float('inf');
    notimeout   = (timeout < 0.0);

    reset( hRate );
    % Wile not stop by external creteria
    while ~test()
    %     % If ros stoped
    %     if rospy.is_shutdown()
    %         if raise_on_error
    %             raise OSError(errno.ESHUTDOWN, "ROS Shutdown");
    %         end     
    %     % If not infinity and time is out
    %     elseif (~notimeout) && (rospy.get_time() >= end_time)
    %         if raise_on_error
    %             raise OSError(errno.ETIMEDOUT, timeout_msg)
    %         end
    %     end
    
            % if not infinity and time is out
        if (~notimeout) && (rostime('now') >= end_time)
            if raise_on_error
                error( timeout_msg );
            end
        end

        % If have function for execut on free time
        if isa( body,'function_handle' )
            % Execute it
            body();
        end

        % Sleep for next check
        waitfor( hRate );
    end
    % All done. Return true
    res = true;
end

