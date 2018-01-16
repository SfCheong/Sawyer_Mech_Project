classdef (Abstract) IDrawable < matlab.mixin.Heterogeneous & handle
    %IDRAWABLE Summary of this class goes here
    %   Detailed explanation goes here
        
    properties
        boundingBox = [];       % Bonding box 
        Visible     = true;     
    end
    
    methods
        %% Draw function
        draw( obj, axes );
    end
    
end

