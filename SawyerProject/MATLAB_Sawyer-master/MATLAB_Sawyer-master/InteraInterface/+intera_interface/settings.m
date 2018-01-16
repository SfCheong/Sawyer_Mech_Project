%%
JOINT_ANGLE_TOLERANCE       = 0.008726646;
HEAD_PAN_ANGLE_TOLERANCE	= 0.1;

%% Versioning
SDK_VERSION     = '5.1.0';
CHECK_VERSION	= true;

%% Version Compatibility Maps - {current: compatible}
VERSIONS_SDK2ROBOT      = contains.Map({'5.1.0'}, {['5.1.0', '5.1.1', '5.1.2']});
VERSIONS_SDK2GRIPPER	= contains.Map({'5.1.0'}, contains.Map( {'warn', 'fail'}, { '2014/5/20  00:00:00', ...      % Version 1.0.0
                                                                                    '2013/10/15 00:00:00' } ));     % Version 0.6.2

