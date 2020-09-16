% script to read in results of simulink/simscape run
% extracts data for plotting of trajectory within the simscape 3d viewer

poi_xyz = out.logsout{1}.Values;
poi_xyz_resample = resample(poi_xyz,linspace(0,2*pi,1e3));
poi_xyz_data = poi_xyz_resample.Data;