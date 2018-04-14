classdef Trajectory<handle
    properties
        trajName       = '';
        JointStateList = []; 
        lostframes     = [0];
    end
    
    methods
        %Constructor
        %trajName refers to .mat file that store desired Trajetory
        %On .m script should load the file first, in order to load
        %jointStateList
        function obj=Trajectory(trajName,structName)
            if nargin>0
            obj.trajName       = trajName;
            obj.JointStateList = structName;
            end
        end

        function calc_lostframes(obj)
            obj.lostframes = [0];
            for i =1:size(obj.JointStateList.position,2)-1
                frame_new         = obj.JointStateList.id(i+1) - obj.JointStateList.id(i);
                obj.lostframes    = [obj.lostframes frame_new];
            end
        end
        
        function setLostFrames(obj,val)
            obj.lostframes    = ones(1,size(obj.JointStateList.position,2))*val;
            obj.lostframes(1) = 0;
        end
        
        function appendTrajectory(obj,fieldName,data)           
            obj.JointStateList.(fieldName) = data;
        end
        
        function calcVel = calc_velocity(obj,totalTime,dataName,calcDataName)
            
            period      = totalTime/(size(obj.JointStateList.(dataName),2)-1)
            q           = 1;
                while q<size(obj.JointStateList.(dataName),2)   
                    for i =1:size(obj.JointStateList.(dataName),1)
                        calcVel(i,1)   = 0;
                        calcVel(i,q+1) = (obj.JointStateList.(dataName)(i,q+1) - obj.JointStateList.(dataName)(i,q))/period;                      
                    end
                    q = q+1;
                end
                obj.JointStateList.(calcDataName)=calcVel;
        end
        
    end
    end