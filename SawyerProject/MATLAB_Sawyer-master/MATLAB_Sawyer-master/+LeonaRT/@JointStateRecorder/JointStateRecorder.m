classdef JointStateRecorder < handle
    %JOINTSTATERECORDER Class for control file contant
    %   Detailed explanation goes here
    
    properties
        hFile = [];             % File handle
        
        version;                % Structure for header description
        description;            % Text file discription
        type;                   % File type
        
        recordsCounter;         % Record lenth
        recordSize;             % Record counter
    end
    
    properties( Constant )
        REGULAR_RECORD_SIZE     = 0;    % File containe structs with regular size
        
        DISCRIPTION_TEXT_SIZE   = 128	% Size for header fild
        
        HEADER_LENGTH           = 139;  % Length of header structure
    end
    
    methods 
        %% Constructor 
        function obj = FileStorage( file )
            % Check for default values 
            if nargin == 2
                % Try to open file
            end
            
            % Try to open file file
            
            % If file not exist
                % create file 
            
            
            % Initialize structure
            obj.version         = uint16( 0 );
            
            % Set default text to header
            text    = 'Default description text';
            buffer 	=  zeros( DISCRIPTION_TEXT_SIZE );
            
            buffer( 1:length(text) )        = text;
            obj.description = uint8( buffer );            
            
            % Temporary by default 
            obj.type          	= uint8 ( FileStorage.REGULAR_RECORD_SIZE );
            
            obj.recordsCounter  = uint32( 0 );
            obj.recordSize      = uint32( 0 );
        end
        
        %% Open file
        function res = open( obj, file )
        end
        
      	%% Close file
        function res = open( obj )
        end
        
     	%% Is empty
        function res = ismpty( obj)
        end
        
        %% Desplay header
        function res = dispHeader( obj )
        end        
        
        %% Write data
        function res = write( obj, data )
        end
        
        %% Read data
        function data = read( obj )
        end
    end
    
end

