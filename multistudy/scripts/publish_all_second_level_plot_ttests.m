pubdir = fullfile(fileparts(pwd), 'results', 'second_level_contrasts');  % Set the output directory
pubfilename = 'all_second_level_plot_ttests'; % The script you want to publish

p = struct('useNewFigure', false, 'maxHeight', 800, 'maxWidth', 800, ...
  'format', 'html', 'outputDir', pubdir, ...
  'showCode', true, 'stylesheet', which('mxdom2simplehtml_CANlab.xsl'));

htmlfile = publish(pubfilename, p);