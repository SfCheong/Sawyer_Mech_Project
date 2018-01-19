%%
%this script is to extract the jointStatelist from positionRecorder class
%and save it in seperate *.mat file
clear all
clc
%%
import LeonaRT.*;

% Load recorded state record
[fileName, pathName] = uigetfile('*.mat','Select recorded state record file');
load(fileName);

%%
%create array of data
arrayLength = positionRecorder.length();
id       = zeros( 1, arrayLength );
for i = 1:arrayLength
    % Id number
    id(:, i)         = positionRecorder.jointStateList(i).id;
    % Save position
    position( :, i ) = positionRecorder.jointStateList(i).position;
    % Save velosity
    velocity( :, i ) = positionRecorder.jointStateList(i).velocity;
    % Save velosity
    effort( :, i )   = positionRecorder.jointStateList(i).effort;
end
%calculate lose frames
diffID = id( 2:end ) - id( 1:end-1 );
diffID = [0,diffID];
save('jointStateList02','diffID');
%%
%save position data in seperate array
pos_j01 = position(1,:);
pos_j02 = position(2,:);
pos_j03 = position(3,:);
pos_j04 = position(4,:);
pos_j05 = position(5,:);
pos_j06 = position(6,:);
pos_j07 = position(7,:);
save('jointStateList02','pos_j01','pos_j02','pos_j03','pos_j04','pos_j05','pos_j06','pos_j07','-append');
%%
%save position data in seperate array
vel_j01 = velocity(1,:);
vel_j02 = velocity(2,:);
vel_j03 = velocity(3,:);
vel_j04 = velocity(4,:);
vel_j05 = velocity(5,:);
vel_j06 = velocity(6,:);
vel_j07 = velocity(7,:);
save('jointStateList02','vel_j01','vel_j02','vel_j03','vel_j04','vel_j05','vel_j06','vel_j07','-append');
