classdef MotionCommand < handle
    properties
        Interface = '';
        goalMsg   = '';
    end
    methods 
        function obj = MotionCommand()
        obj.goalMsg.names = {'right_j0', 'right_j1', 'right_j2', 'right_j3', 'right_j4', 'right_j5',  'right_j6'};
        obj.goalMsg.Mode      = 0;
        end
    end
end