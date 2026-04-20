% main.m
% Tip Probe Simulation
% Scanning Tunneling Microscope
% College of Marin Physics Club
% Kai Carlin - Spring 2026

clear
close all

% INITIALIZE SAMPLE
% assuming HOPG sample material with interatomic distance of 0.14135 nm
samplePreviewWidth = 0.01; % meters (10mm) used for preview
sampleStageZPos = -.0125;
sampleWidth = 7*10^-3;
sampleLength = 18*10^-3;
sampleRange = 20*10^-6;


scanRange = 1*(10^(-6));
scanRangeMax = 51 * (10^(-6));
sampleAtomicDistance = 1.4135*10^(-10);
macroWindowSize = 6;
microWindowSize = 1.25;

pixelResolution = 256;
scan1 = ScanClass(pixelResolution);
sample = SampleClass(samplePreviewWidth, scanRange, scanRangeMax, sampleStageZPos, sampleAtomicDistance, pixelResolution, sampleWidth, sampleLength, sampleRange);

probe = ProbeClass(1);
screen = ScreenClass(probe, sample, scan1, macroWindowSize, microWindowSize);
probe.testVal = 2;
screen.speak();