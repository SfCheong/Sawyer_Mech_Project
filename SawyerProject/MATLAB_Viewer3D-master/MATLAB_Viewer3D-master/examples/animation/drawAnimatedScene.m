%% Show simple 3D scene. Save and load Axes parameters

clc
close all
% clear all

% Includ packages
import Viewer3D.*;     % Include this package

% Testing axes
hFirst  = figure(1);
hScene  = Viewer3D.Scene3D( gca );

% Append axes for visualize
hScene.append( Viewer3D.Axes() );
