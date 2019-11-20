function subfig_plot( subfig_general, subfigs )
%SUBFIG_PLOT( subfig_general, subfigs ) plots a file with multiple 
%  subfigures in nice formatting useful for scientific presentation.
%
%   For documentation see 'subfig_plot_doc.pdf'.
%
%   Created by Jakub Kucka
%   Leibiniz University Hannover
%   Institute for Drive Systems and Power Electronics
%
%   ver 1.0

%% Set font and fontsize (this will change the current settings of the system)
if isfield(subfig_general, 'font') == 1
    set(0,'defaultAxesFontName', subfig_general.font)
    set(0,'defaultTextFontName', subfig_general.font)
end
if isfield(subfig_general, 'fontsize') == 1
    set(0,'DefaultAxesFontSize', subfig_general.fontsize)
    set(0,'DefaultTextFontSize', subfig_general.fontsize)
end

%% Set axes and fonts to black
set(groot,{'DefaultAxesXColor','DefaultAxesYColor','DefaultAxesZColor'},{'k','k','k'})

%% Remove multipliers
set(groot,{'DefaultAxesLabelFontSizeMultiplier'},{1})

%% default settings for decimal point/comma, if not defined by user
if isfield(subfig_general, 'decimal_comma') == 0
    subfig_general.decimal_comma = 0; % by default decimal_comma is not used
end

%% set label interpreter, if this was not defined by user
if isfield(subfig_general, 'interpreter') == 0
    subfig_general.interpreter = 'tex'; % default matlab text interpreter
end

%% Generate Figure
if isfield(subfig_general, 'figure_number') == 0
    subfig_general.figure_number = 96;
    warning('default figure number selected');
end

fig = figure(subfig_general.figure_number);

%%  Set size
fig.Units = 'centimeters';
fig.Position = [subfig_general.size(1) subfig_general.size(2) subfig_general.size(1) subfig_general.size(2)];
fig.PaperUnits = 'centimeters';
fig.PaperSize = subfig_general.size;
fig.PaperPositionMode = 'manual';
fig.PaperPosition = [0 0 subfig_general.size(1) subfig_general.size(2)];


%% Plot the thing
y_actual = 1-subfig_general.y_begin;
for j = 1:length(subfig_general.subfig_y_sizes_rel)
    % calculate the new y position
    y_actual = y_actual - subfig_general.subfig_y_sizes_rel(j);
    % generate the axis
    sub{j} = axes;
    sub{j}.Position = [subfig_general.x_begin, y_actual, subfig_general.x_length, subfig_general.subfig_y_sizes_rel(j)];
    % do plotting
    for k = 1:length(subfigs{j}.data)
        % check whether the plot type has been specified
        if isfield(subfigs{j}.data{k},'plottype') == 0
            subfigs{j}.data{k}.plottype = 'plot'; %default plot function is 'plot'
        end
        % check if the line width is specified
        if isfield(subfigs{j}.data{k}, 'linewidth') == 0
            if isfield(subfig_general,'default_linewidth') == 1
                subfigs{j}.data{k}.linewidth = subfig_general.default_linewidth;
            else
                subfigs{j}.data{k}.linewidth = 1; % default linewidth
            end
        end
        % check if the marker size is specified
        if isfield(subfigs{j}.data{k}, 'markersize') == 0
            if isfield(subfig_general,'default_markersize') == 1
                subfigs{j}.data{k}.markersize = subfig_general.default_markersize;
            else
                subfigs{j}.data{k}.markersize = 4; % default markersize
            end
        end
        % check if the plotstyle is specified
        if isfield(subfigs{j}.data{k}, 'plotstyle') == 0
            subfigs{j}.data{k}.plotstyle = '-';
        end
        % plot the data according to settings
        if strcmp(subfigs{j}.data{k}.plottype,'plot') == 1
            if isfield(subfigs{j}.data{k}, 'color') == 0
                pl = plot(subfigs{j}.data{k}.x,subfigs{j}.data{k}.y,subfigs{j}.data{k}.plotstyle,'Linewidth',subfigs{j}.data{k}.linewidth);
            else
                pl = plot(subfigs{j}.data{k}.x,subfigs{j}.data{k}.y,subfigs{j}.data{k}.plotstyle,'Linewidth',subfigs{j}.data{k}.linewidth, 'Color',subfigs{j}.data{k}.color, 'MarkerEdgeColor',subfigs{j}.data{k}.color );
            end
            pl.MarkerSize = subfigs{j}.data{k}.markersize;
            hold on
        elseif strcmp(subfigs{j}.data{k}.plottype,'stairs') == 1
            if isfield(subfigs{j}.data{k}, 'color') == 0
                pl = stairs(subfigs{j}.data{k}.x,subfigs{j}.data{k}.y,subfigs{j}.data{k}.plotstyle,'Linewidth',subfigs{j}.data{k}.linewidth);
            else
                pl = stairs(subfigs{j}.data{k}.x,subfigs{j}.data{k}.y,subfigs{j}.data{k}.plotstyle,'Linewidth',subfigs{j}.data{k}.linewidth, 'Color',subfigs{j}.data{k}.color, 'MarkerEdgeColor',subfigs{j}.data{k}.color );
            end
            pl.MarkerSize = subfigs{j}.data{k}.markersize;
            hold on            
        elseif strcmp(subfigs{j}.data{k}.plottype,'text') == 1
            if isfield(subfigs{j}.data{k}, 'color') == 0
                subfigs{j}.data{k}.color = [0 0 0];
            end
            if isfield(subfigs{j}.data{k}, 'text_fontsize') == 0
                subfigs{j}.data{k}.text_fontsize = subfig_general.fontsize;
            end
            pl = text(subfigs{j}.data{k}.x, subfigs{j}.data{k}.y, subfigs{j}.data{k}.text, 'FontSize', subfigs{j}.data{k}.text_fontsize, 'Color', subfigs{j}.data{k}.color);
        elseif strcmp(subfigs{j}.data{k}.plottype,'bar') == 1
            if isfield(subfigs{j}.data{k}, 'color') == 0
                pl = bar(subfigs{j}.data{k}.x,subfigs{j}.data{k}.y,subfigs{j}.data{k}.plotstyle,'Linewidth',subfigs{j}.data{k}.linewidth);
            else
                pl = bar(subfigs{j}.data{k}.x,subfigs{j}.data{k}.y, 'BarWidth', subfigs{j}.data{k}.barwidth, 'FaceColor',subfigs{j}.data{k}.color, 'EdgeColor',subfigs{j}.data{k}.color );
            end
            hold on             
        else
            warning('specified plottype currently not supported');
        end
    end
    % turn the box on
    box on;
    
    % do the log scale for the x axis (if required)
    if isfield(subfig_general,'use_log_axis_x') == 1
        if subfig_general.use_log_axis_x == 1
            sub{j}.XScale = 'log';
            sub{j}.XMinorGrid = 'on';
            if subfig_general.xlimit(1) <= 0 || subfig_general.xlimit(2) <= 0
                warning('For logarithmic axis the xlim values must be positive values, selected default [1e-2 1e2]');
                subfig_general.xlimit = [1e-2 1e2];
            end
            sub{j}.XLim = subfig_general.xlimit;
        end
    else
        subfig_general.use_log_axis_x = 0;
    end
    
    % do the log scale for the y axis (if required)
    if isfield(subfigs{j},'use_log_axis_y') == 1
        if subfigs{j}.use_log_axis_y == 1
            sub{j}.YScale = 'log';
            sub{j}.YMinorGrid = 'on';
            % check whether ylimit is set correctly
            if isfield(subfigs{j},'ylimit') == 1
                if subfigs{j}.ylimit(1) <= 0 || subfigs{j}.ylimit(2) <= 0
                    warning('For logarithmic axis the ylim values must be positive values, selected default [1e-2 1e2]');
                    subfigs{j}.ylimit = [1e-2 1e2];
                end
                sub{j}.YLim = subfigs{j}.ylimit;
            end
        end
    else
        subfigs{j}.use_log_axis_y = 0;
    end
    
    % do the x limitation (this is non-optional!, otherwise we cannot be
    % sure that the particular subfigs are displayed correctly)
    xlim(subfig_general.xlimit);
    % do the y limitation
    if isfield(subfigs{j},'ylimit') == 1
        ylim(subfigs{j}.ylimit);
    else
        ylim(sub{j}.YLim*0.9995);
    end
    % do the y axis label
    if isfield(subfigs{j},'ylabel') == 1
        ylabel(subfigs{j}.ylabel, 'Interpreter', subfig_general.interpreter);
    end
    
    % do the grid
    if isfield(subfig_general,'do_grids') == 1
        if subfig_general.do_grids == 1
            grid on;
        else
            grid off;
        end
    end
    
    
    
    % set the interpreter for x and y ticks
    sub{j}.TickLabelInterpreter = subfig_general.interpreter;
    
    %if x ticks are defined, use them
    if isfield(subfig_general,'xticks') == 1
        sub{j}.XTick = subfig_general.xticks;
    end    
    %if it is not the last subfig, remove the x tick labels, else add x axis label
    if j ~= length(subfig_general.subfig_y_sizes_rel)
        sub{j}.XTickLabel = {};
    else
        if isfield(subfig_general,'xlabel') == 1
            xlabel(subfig_general.xlabel, 'Interpreter', subfig_general.interpreter);
        end
        if isfield(subfig_general,'xticklabel') == 1
            sub{j}.XTickLabel = subfig_general.xticklabel;
        elseif subfig_general.decimal_comma == 1 && subfig_general.use_log_axis_x ~= 1
            for c = 1:length(sub{j}.XTick)
                labels{c} = strrep(num2str(sub{j}.XTick(c)), '.', ',');
            end
            sub{j}.XTickLabel = labels;
            clear labels;
        end
    end
    
    %if y ticks are defined, use them
    if isfield(subfigs{j},'yticks') == 1
        sub{j}.YTick = subfigs{j}.yticks;
    end
    %if y tick labels are defined, use them
    if isfield(subfigs{j},'yticklabel') == 1
        sub{j}.YTickLabel = subfigs{j}.yticklabel;
    elseif subfig_general.decimal_comma == 1 && subfigs{j}.use_log_axis_y ~= 1
        for c = 1:length(sub{j}.YTick)
            labels{c} = strrep(num2str(sub{j}.YTick(c)), '.', ',');
        end
        sub{j}.YTickLabel = labels;
        clear labels;
    end
    
    % look if global legend should be generated
    if isfield(subfig_general,'global_legend') == 1
        if j == subfig_general.global_legend.subfig_nr
            if isfield(subfig_general.global_legend, 'legendstyle') == 0
                subfig_general.global_legend.legendstyle = 'HORIZONTAL';
            end
            if strcmp(subfig_general.global_legend.legendstyle, 'HORIZONTAL')
                lgd = legend(subfig_general.global_legend.names,'Orientation','horizontal');
            elseif strcmp(subfig_general.global_legend.legendstyle, 'VERTICAL')
                lgd = legend(subfig_general.global_legend.names,'Orientation','vertical');
            else
                error('unknown global legend style');
            end
            lgd.Position = [subfig_general.x_begin+(1-subfig_general.global_legend.width)/2*subfig_general.x_length, 1-subfig_general.y_begin+subfig_general.global_legend.y_gap,...
                subfig_general.global_legend.width*subfig_general.x_length, subfig_general.global_legend.height];
            if subfig_general.global_legend.box_on == 1
                lgd.Box = 'on';
            else
                lgd.Box = 'off';
            end
            if isfield(subfig_general,'legend_fontsize') == 1
                lgd.FontSize = subfig_general.legend_fontsize;
            end
            % set interpreter
            lgd.Interpreter = subfig_general.interpreter;
        end
    end
    
    % look if local legend should be generated
    if isfield(subfigs{j},'legend') == 1
        % apply defaults if not specified
        if isfield(subfigs{j}.legend,'legendstyle') == 0
            subfigs{j}.legend.legendstyle = 'HORIZONTAL_UP';
        end
        if isfield(subfigs{j}.legend,'box_on') == 0
            subfigs{j}.legend.box_on = 0;
        end
        if isfield(subfigs{j}.legend,'width') == 0
            subfigs{j}.legend.width = 1;
        end
        %
        if strcmp(subfigs{j}.legend.legendstyle, 'HORIZONTAL_UP')
            sub_lgd{j} = legend(subfigs{j}.legend.names,'Orientation','horizontal');
            sub_lgd{j}.Position = [subfig_general.x_begin+(1-subfigs{j}.legend.width)/2*subfig_general.x_length, y_actual+subfig_general.subfig_y_sizes_rel(j)-subfigs{j}.legend.height,...
                subfigs{j}.legend.width*subfig_general.x_length, subfigs{j}.legend.height];
        elseif strcmp(subfigs{j}.legend.legendstyle, 'HORIZONTAL_DOWN')
            sub_lgd{j} = legend(subfigs{j}.legend.names,'Orientation','horizontal');
            sub_lgd{j}.Position = [subfig_general.x_begin+(1-subfigs{j}.legend.width)/2*subfig_general.x_length, y_actual,...
                subfigs{j}.legend.width*subfig_general.x_length, subfigs{j}.legend.height];
        end
        if subfigs{j}.legend.box_on == 1
            sub_lgd{j}.Box = 'on';
        else
            sub_lgd{j}.Box = 'off';
        end
        if isfield(subfig_general,'legend_fontsize') == 1
            sub_lgd{j}.FontSize = subfig_general.legend_fontsize;
        end
        % set interpreter
        lgd.Interpreter = subfig_general.interpreter;        
    end
    
    % do the gap between the subfigs
    y_actual = y_actual - subfig_general.subfig_y_gap;
end

%% Align the Y axis labels
% check if the settings was defined
if isfield(subfig_general,'align_y_labels') == 0
    subfig_general.align_y_labels = 1;
end
% do the aligning
if subfig_general.align_y_labels == 1
    min = sub{1}.YLabel.Position(1);
    for j = 1:length(subfig_general.subfig_y_sizes_rel)
        if sub{j}.YLabel.Position(1) < min
            min = sub{j}.YLabel.Position(1);
        end
    end
    for j = 1:length(subfig_general.subfig_y_sizes_rel)
        sub{j}.YLabel.Position(1) = min;
    end
end

%% Print Figure
% check if printer defined
if isfield(subfig_general, 'printer') == 0
    subfig_general.printer = '-opengl';
    warning('default printer selected: opengl');
end
% check if DPI defined
if isfield(subfig_general, 'DPI') == 0
    subfig_general.DPI = '-r300';
    warning('default DPI selected: -r300');
end
% check if figure name defined
if isfield(subfig_general, 'figure_name') == 0
    subfig_general.figure_name = 'fig';
    warning('default figure name selected: fig');
end
% generate file
if isfield(subfig_general, 'output_file_type') == 0
    subfig_general.output_file_type = 'PNG';
end
%export PDF
if strcmp(subfig_general.output_file_type,'PDF')
    print(subfig_general.printer,[subfig_general.figure_name,'.pdf'],'-dpdf',subfig_general.DPI);
%export PDF with embedded fonts
elseif strcmp(subfig_general.output_file_type,'PDFemb')
    print(subfig_general.printer,[subfig_general.figure_name,'.eps'],'-depsc',subfig_general.DPI);
    system(sprintf('epstopdf --gsopt="-sFONTPATH=C:/Windows/Fonts -dSubsetFonts=true -dEmbedAllFonts=true -dPDFSETTINGS=/prepress" "%s"',[subfig_general.figure_name,'.eps']));
    system(sprintf('del %s', [subfig_general.figure_name,'.eps']));
%export PDF with embedded fonts (version 2) - necessary when newer MikTex
%is installed
elseif strcmp(subfig_general.output_file_type,'PDFemb2')
    print(subfig_general.printer,[subfig_general.figure_name,'xx.eps'],'-depsc',subfig_general.DPI);
    input_file_convert=fopen([subfig_general.figure_name,'xx.eps'],'r');
    output_file_convert=fopen([subfig_general.figure_name,'.eps'],'w');
    while ~feof(input_file_convert)
        %read line
        l=fgetl(input_file_convert); 
        % correct the fonts to something recognizable by the new miktex
        l=strrep(l, 'Times-Roman', 'Times');
        l=strrep(l, 'Times-Italic', 'Times-Roman-Italic');
        l=strrep(l, 'Times-Bold', 'Times-Roman-Bold');
        fprintf(output_file_convert,'%s\n',l);
    end
    fclose(input_file_convert);
    fclose(output_file_convert);
    system(sprintf('epstopdf --gsopt="-dEmbedAllFonts=true -dPDFSETTINGS=/prepress" "%s"',[subfig_general.figure_name,'.eps']));
    system(sprintf('del %s', [subfig_general.figure_name,'.eps']));    
    system(sprintf('del %s', [subfig_general.figure_name,'xx.eps']));
%export PNG
elseif strcmp(subfig_general.output_file_type,'PNG')
    print(subfig_general.printer,[subfig_general.figure_name,'.png'],'-dpng',subfig_general.DPI);
else
    warning('Specified output data type not supported');
end

%% close figure
close(fig)

end

