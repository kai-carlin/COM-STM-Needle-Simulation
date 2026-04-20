% main.m
% Tip Probe Simulation
% Scanning Tunneling Microscope
% College of Marin Physics Club
% Kai Carlin - Spring 2026

clear
close all

% set high precision mode here!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

%----------------------------%
% INITIAL SETUP
%----%

% tube scanner parameter setup
tubeLength = 0.05; % meters (50mm)
tubeRadius = 0.003; % meters (6mm)
tubeWallThickness = 0.00065; % meters (.65mm)
tubeRadialResolution = 32; % for piezo tube scanner
tubeLateralResolution = 80; % for piezo tube scanner

% sample setup
% assuming HOPG sample material with interatomic distance of 0.14135 nm
sampleWidth = 0.01; % meters (10mm) used for preview
samplePointSpacingPreview = linspace(-sampleWidth,sampleWidth,2);
sampleZPos = -.01;
[sMeshPreviewX,sMeshPreviewY] = meshgrid(samplePointSpacingPreview,samplePointSpacingPreview);
sMeshPreviewZ = ones(size(sMeshPreviewX))*sampleZPos;
sampleAtomicDistance = 1.4135*10^(-10);
samplePointSpacing = (-sampleAtomicDistance*100:sampleAtomicDistance:sampleAtomicDistance*100);
% % sMesh = meshgrid(samplePointSpacing,samplePointSpacing); FIIIIIIIIIX THIIIIIIIISS

% tip setup
tipLength = 0.005; % meters (5mm)

% display parameter setup
exagerationFactor = 1;
macroWindowSize = 15; % multiplied by tube diameter

%----------------------------%
% PLOTTING
%----%

% generate piezo model
polyRadius = ones(1,tubeLateralResolution)*tubeRadius; % geometry describing tube
[pX,pY,pZ] = cylinder(polyRadius,tubeRadialResolution); % p = piezo
pZ = pZ * tubeLength;

% generate sample model









fig1 = figure('Name', 'Probe View', 'NumberTitle','off');
g = uigridlayout(fig1);
g.RowHeight = {'1x','1x'};
g.ColumnWidth = {'1x','1x','1x','1x'};

ax = uiaxes(g);
% set up 3D marco plot
% subplot(2,3,1);
probeSurf = surf(pX,pY,pZ); % probe
hold on
surf(sMeshPreviewX,sMeshPreviewY,sMeshPreviewZ); % surface preview
axis equal
xlim([-macroWindowSize*tubeRadius,macroWindowSize*tubeRadius]);
ylim([-macroWindowSize*tubeRadius,macroWindowSize*tubeRadius]);
zlim([-macroWindowSize*tubeRadius,macroWindowSize*tubeRadius]+0.015);
title('Tip Probe 3D Macro View');
xlabel('x-axis (m)');
ylabel('y-axis (m)');
zlabel('z-axis (m)');


pX
pY
pZ
plot3(pX(1,1),pY(1,1),pZ(1,1),'ro','MarkerSize', 5,'MarkerFaceColor','#FFFFFF')
plot3(pX(1,9),pY(1,9),pZ(1,9),'ro','MarkerSize', 5,'MarkerFaceColor','#FFFFFF')
plot3(pX(1,17),pY(1,17),pZ(1,17),'ro','MarkerSize', 5,'MarkerFaceColor','#FFFFFF')
plot3(pX(1,9),pY(1,25),pZ(1,25),'ro','MarkerSize', 5,'MarkerFaceColor','#FFFFFF')
%text(0, 0, 0, 'test')





hold off



az = uiaxes(g);
az2 = uiaxes(g);
az3 = uiaxes(g);
az4 = uiaxes(g);
az5 = uiaxes(g);



% set up 3D micro plot
% subplot(2,3,2);
title('Tip Probe 3D Micro View');

% set up XY plane micro view
% subplot(2,3,3);
title('Tip Probe XY Plane Micro View');

xlabel('x-axis (m)');
ylabel('y-axis (m)');
zlabel('z-axis (m)');

% set up XY top plane view
% subplot(2,3,6);
title('Tip Probe XY Top Plane View');

% set up XZ front plane view
% subplot(2,3,4);
title('Tip Probe XZ Front Plane View');

% set up YZ front plane view
% subplot(2,3,5);
title('Tip Probe YZ Front Plane View');



fig = uifigure;
b = uibutton(fig);