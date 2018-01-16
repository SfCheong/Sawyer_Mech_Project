%% Show simple 3D scene. Save and load Axes parameters

clc
close all
% clear all

% Includ packages
import Viewer3D.*;                  % Include this package
import Viewer3D.GUI.*;
import Viewer3D.Primitives.*;

% Testing axes
hFirst  = figure(1);
hScene  = Viewer3D.GUI.Scene3D( gca );

% Append axes for visualize
hAxes = Viewer3D.Primitives.Axes();
hAxes.setParent( gca );
