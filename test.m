clear;

% this file is used for testing the subfig_plot function and can be used as a template
% for exact information, check the documentation file

%% General Plot Parameters
% SIZES
subfig_general.size = [8 10]; %cm ; size of the final figure
subfig_general.x_begin = 0.25; %relative, the offset at which the axes begin
subfig_general.y_begin = 0.05; %relative, the offset at which the axes begin
subfig_general.x_length = 0.7; %relative, the length of the axes in x direction
subfig_general.subfig_y_sizes_rel = [0.15 0.4 0.2]; % relative, the length of the particular axes for each subfig in y direction, this also specifies the number of subfigs
subfig_general.subfig_y_gap = 0.02; % relative, the gap between the subfigs
% general settings
subfig_general.do_grids = 1;
subfig_general.xlimit = [0 2]; 
subfig_general.xlabel = 'Time (ms)';
subfig_general.fontsize = 12;
subfig_general.legend_fontsize = 12;
subfig_general.font = 'Times New Roman';
subfig_general.figure_number = 3; % figure number
subfig_general.align_y_labels = 1;
subfig_general.decimal_comma = 1;
% print settings
subfig_general.figure_name = 'fig3';
subfig_general.output_file_type = 'PDFemb2';
subfig_general.DPI = '-r400';
subfig_general.printer = '-painters';

subfig_general.use_log_axis_x = 0;

%% global legend
% subfig_general.global_legend.subfig_nr = 1;
% subfig_general.global_legend.names = {'data1'};
% subfig_general.global_legend.width = 0.8;
% subfig_general.global_legend.height = 0.03;
% subfig_general.global_legend.y_gap = 0.02;
% subfig_general.global_legend.box_on = 1;

%% the data which must be plotted
% first subfig
subfigs{1}.data{1}.x = linspace(0,2,100);
subfigs{1}.data{1}.y = sin(20*linspace(1,2,100));
subfigs{1}.ylabel = {'Y axis', '(kV)'};
subfigs{1}.yticks = [-0.6, 0, 0.6];
subfigs{1}.ylimit = [-1 1];
subfigs{1}.data{2}.x = 0.5;
subfigs{1}.data{2}.y = 0.5;
subfigs{1}.data{2}.text = 'oh yeah';
subfigs{1}.data{2}.plottype = 'text';
subfigs{1}.use_log_axis_y = 0;
% second subfig
subfigs{2}.data{1}.x = linspace(1,2,100);
subfigs{2}.data{1}.y = linspace(1,2,100);
subfigs{2}.data{1}.plotstyle = '-x';
subfigs{2}.data{1}.linewidth = 0.1;
subfigs{2}.data{1}.color = [1 0.4 0.4];
subfigs{2}.data{2}.x = linspace(0,2,10);
subfigs{2}.data{2}.y = linspace(1,3,10);
subfigs{2}.ylimit = [1.01 3.8];
subfigs{2}.ylabel = {'Y axis', '(kA)'};
subfigs{2}.legend.names = {'data1', 'data2'};
subfigs{2}.legend.height = 0.04;
% third subfig
subfigs{3}.data{1}.x = linspace(1,2,10);
subfigs{3}.data{1}.y = linspace(1,2,10);
subfigs{3}.ylabel = {'Y axis'};
subfigs{3}.legend.names = {'data1'};
subfigs{3}.legend.height = 0.04;
subfigs{3}.legend.legendstyle = 'HORIZONTAL_DOWN';
subfigs{3}.use_log_axis_y = 0;

%% execute plotting
subfig_plot( subfig_general, subfigs );