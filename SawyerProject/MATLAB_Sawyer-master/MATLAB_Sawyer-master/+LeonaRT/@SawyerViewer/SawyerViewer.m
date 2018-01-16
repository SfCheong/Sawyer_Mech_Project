classdef SawyerViewer < handle
    %SAWYERVIEWER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        hAxis;      % axis handle for drawing
    end
    
    methods        
        %% Constructor
        function obj = SawyerViewer( hAxis )
            % Save handle
            obj.hAxis = hAxis;           
        end
    end
    
end

