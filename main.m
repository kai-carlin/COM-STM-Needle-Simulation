% main.m
% Tip Probe Simulation
% Scanning Tunneling Microscope
% College of Marin Physics Club
% Kai Carlin - Spring 2026

clear
close all

% INITIALIZE SAMPLE
% assuming HOPG sample material with interatomic distance of 0.14135 nm
sampleWidth = 0.01; % meters (10mm) used for preview
sampleZPos = -.0125;
scanRange = 51 * (10^(-6));
sampleAtomicDistance = 1.4135*10^(-10);
macroWindowSize = 11;
microWindowSize = 1.25;

pixelResolution = 256;
scan1 = ScanClass(pixelResolution);
sample = SampleClass(sampleWidth, scanRange, sampleZPos, sampleAtomicDistance);

probe = ProbeClass(1);
screen = ScreenClass(probe, sample, scan1, macroWindowSize, microWindowSize);
probe.testVal = 2;
screen.speak();