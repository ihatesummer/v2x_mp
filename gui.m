function varargout = v2x_new_decoration(varargin)
    % Begin initialization code - DO NOT EDIT
    gui_Singleton = 1;
    gui_State = struct('gui_Name', mfilename, ...
        'gui_Singleton', gui_Singleton, ...
        'gui_OpeningFcn', @v2x_new_decoration_OpeningFcn, ...
        'gui_OutputFcn', @v2x_new_decoration_OutputFcn, ...
        'gui_LayoutFcn', [], ...
        'gui_Callback', []);

    if nargin && ischar(varargin{1})
        gui_State.gui_Callback = str2func(varargin{1});
    end

    if nargout
        [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
    else
        gui_mainfcn(gui_State, varargin{:});
    end

    % End initialization code - DO NOT EDIT
end

% --- Executes just before v2x_new_decoration is made visible.
function v2x_new_decoration_OpeningFcn(hObject, eventdata, handles, varargin)

    handles.output = hObject;

    guidata(hObject, handles);

    global variance_d variance_theta nVehicles avgVelocity_y_vehicle1to2 ...
        avgVelocity_y_vehicle4to5 avgVelocity_y_vehicle3 avgVelocity_y_anchor ...
        variation_movement_xAxis variation_movement_yAxis nLanes ...
        timeInterval avgVelocity_x_all nIterations ...
        initialPosition_vehicle1 initialPosition_vehicle2 initialPosition_vehicle3 ...
        initialPosition_vehicle4 initialPosition_vehicle5 ...
        initialPosition_vehicle6 initialPosition_vehicle7 initialPosition_vehicle8 ...
        initialPosition_vehicle9 initialPosition_vehicle10

    arrayfun(@cla, findall(0, 'type', 'axes'))

    sliderMax = 20;
    set(handles.slider_error_distanceMeasurement, 'Min', 0);
    set(handles.slider_error_distanceMeasurement, 'Max', sliderMax);
    set(handles.slider_error_distanceMeasurement, 'Value', 1);
    set(handles.slider_error_distanceMeasurement, 'SliderStep', [1 / (sliderMax - 1), 1 / (sliderMax - 1)]);
    variance_d = get(handles.slider_error_distanceMeasurement, 'Value')^2;
    set(handles.text_error_distanceMeasurement, 'String', [num2str(round(100 * variance_d) / 100) 'm']);

    sliderMax = 20;
    set(handles.slider_error_angleMeasurement, 'Min', 0);
    set(handles.slider_error_angleMeasurement, 'Max', sliderMax);
    set(handles.slider_error_angleMeasurement, 'Value', 3);
    variance_theta = (pi / 180 * get(handles.slider_error_angleMeasurement, 'Value'))^2;
    set(handles.text_error_angleMeasurement, 'String', [num2str(round(10 * variance_theta) / 10) 'deg']);

    sliderMax = 30;
    set(handles.slider_nVehicles, 'Min', 1);
    set(handles.slider_nVehicles, 'Max', sliderMax);
    set(handles.slider_nVehicles, 'Value', 10);
    set(handles.slider_nVehicles, 'SliderStep', [1 / (sliderMax - 1), 1 / (sliderMax - 1)]);
    nVehicles = round(get(handles.slider_nVehicles, 'Value'));
    set(handles.text_nVehicles, 'String', num2str(nVehicles));

    sliderMax = 300;
    set(handles.slider_nIterations, 'Min', 1);
    set(handles.slider_nIterations, 'Max', sliderMax);
    set(handles.slider_nIterations, 'Value', 10);
    set(handles.slider_nIterations, 'SliderStep', [1 / (sliderMax - 1), 10 / (sliderMax - 1)]);
    nIterations = round(get(handles.slider_nIterations, 'Value'));
    set(handles.text_nIterations, 'String', num2str(nIterations));

    sliderMax = 200;
    set(handles.slider_initialPosition_vehicle1, 'Min', 0);
    set(handles.slider_initialPosition_vehicle1, 'Max', 300);
    set(handles.slider_initialPosition_vehicle1, 'Value', 0);
    set(handles.slider_initialPosition_vehicle1, 'SliderStep', [10 / (sliderMax - 1), 10 / (sliderMax - 1)]);
    initialPosition_vehicle1 = get(handles.slider_initialPosition_vehicle1, 'Value');
    set(handles.text_currentPosition_vehicle1, 'String', num2str((round(initialPosition_vehicle1))));

    set(handles.slider_initialPosition_vehicle2, 'Min', 0);
    set(handles.slider_initialPosition_vehicle2, 'Max', 300);
    set(handles.slider_initialPosition_vehicle2, 'Value', 0);
    set(handles.slider_initialPosition_vehicle2, 'SliderStep', [10 / (sliderMax - 1), 10 / (sliderMax - 1)]);
    initialPosition_vehicle2 = get(handles.slider_initialPosition_vehicle2, 'Value');
    set(handles.text_currentPosition_vehicle2, 'String', num2str((round(initialPosition_vehicle2))));

    set(handles.slider_initialPosition_vehicle3, 'Min', 0);
    set(handles.slider_initialPosition_vehicle3, 'Max', 300);
    set(handles.slider_initialPosition_vehicle3, 'Value', 0);
    set(handles.slider_initialPosition_vehicle3, 'SliderStep', [10 / (sliderMax - 1), 10 / (sliderMax - 1)]);
    initialPosition_vehicle3 = get(handles.slider_initialPosition_vehicle3, 'Value');
    set(handles.text_currentPosition_vehicle3, 'String', num2str((round(initialPosition_vehicle3))));

    set(handles.Slider_InitialPosition_4, 'Min', 0);
    set(handles.Slider_InitialPosition_4, 'Max', 300);
    set(handles.Slider_InitialPosition_4, 'Value', 0);
    set(handles.Slider_InitialPosition_4, 'SliderStep', [10 / (sliderMax - 1), 10 / (sliderMax - 1)]);
    initialPosition_vehicle4 = get(handles.Slider_InitialPosition_4, 'Value');
    set(handles.text_currentPosition_vehicle4, 'String', num2str((round(initialPosition_vehicle4))));

    set(handles.slider_initialPosition_vehicle5, 'Min', 0);
    set(handles.slider_initialPosition_vehicle5, 'Max', 300);
    set(handles.slider_initialPosition_vehicle5, 'Value', 0);
    set(handles.slider_initialPosition_vehicle5, 'SliderStep', [1 / (sliderMax - 1), 1 / (sliderMax - 1)]);
    initialPosition_vehicle5 = get(handles.slider_initialPosition_vehicle5, 'Value');
    set(handles.text_currentPosition_vehicle5, 'String', num2str((round(initialPosition_vehicle5))));

    set(handles.Slider_InitialPosition_6, 'Min', 0);
    set(handles.Slider_InitialPosition_6, 'Max', 300);
    set(handles.Slider_InitialPosition_6, 'Value', 0);
    set(handles.Slider_InitialPosition_6, 'SliderStep', [10 / (sliderMax - 1), 10 / (sliderMax - 1)]);
    initialPosition_vehicle6 = get(handles.slider_initialPosition_vehicle1, 'Value');
    set(handles.text_currentPosition_vehicle6, 'String', num2str((round(initialPosition_vehicle6))));

    set(handles.slider_initialPosition_vehicle7, 'Min', 0);
    set(handles.slider_initialPosition_vehicle7, 'Max', 300);
    set(handles.slider_initialPosition_vehicle7, 'Value', 0);
    set(handles.slider_initialPosition_vehicle7, 'SliderStep', [10 / (sliderMax - 1), 10 / (sliderMax - 1)]);
    initialPosition_vehicle7 = get(handles.slider_initialPosition_vehicle7, 'Value');
    set(handles.text_currentPosition_vehicle7, 'String', num2str((round(initialPosition_vehicle7))));

    set(handles.slider_initialPosition_vehicle8, 'Min', 0);
    set(handles.slider_initialPosition_vehicle8, 'Max', 200);
    set(handles.slider_initialPosition_vehicle8, 'Value', 0);
    set(handles.slider_initialPosition_vehicle8, 'SliderStep', [10 / (sliderMax - 1), 10 / (sliderMax - 1)]);
    initialPosition_vehicle8 = get(handles.slider_initialPosition_vehicle8, 'Value');
    set(handles.text_currentPosition_vehicle8, 'String', num2str((round(initialPosition_vehicle8))));

    set(handles.slider_initialPosition_vehicle9, 'Min', 0);
    set(handles.slider_initialPosition_vehicle9, 'Max', 300);
    set(handles.slider_initialPosition_vehicle9, 'Value', 0);
    set(handles.slider_initialPosition_vehicle9, 'SliderStep', [10 / (sliderMax - 1), 10 / (sliderMax - 1)]);
    initialPosition_vehicle9 = get(handles.slider_initialPosition_vehicle9, 'Value');
    set(handles.text_currentPosition_vehicle9, 'String', num2str((round(initialPosition_vehicle9))));

    set(handles.Slider_InitialPosition_10, 'Min', 0);
    set(handles.Slider_InitialPosition_10, 'Max', 300);
    set(handles.Slider_InitialPosition_10, 'Value', 0);
    set(handles.Slider_InitialPosition_10, 'SliderStep', [10 / (sliderMax - 1), 10 / (sliderMax - 1)]);
    initialPosition_vehicle10 = get(handles.Slider_InitialPosition_10, 'Value');
    set(handles.text_currentPosition_vehicle10, 'String', num2str(round(initialPosition_vehicle10)));

    variation_movement_xAxis = 0.1;
    variation_movement_yAxis = 1;
    nLanes = 5;
    timeInterval = 0.1;
    avgVelocity_x_all = 0;

    sliderMax = 36;
    %average velocities along y-axis (default unit is m/s. To convert to kph, multiply by 3.6)
    set(handles.slider_averageSpeed_vehicle1to2, 'Value', 20);
    set(handles.slider_averageSpeed_vehicle4to5, 'Value', 20);
    set(handles.slider_averageSpeed_vehicle3, 'Value', 20);
    set(handles.slider_averageSpeed_anchor, 'Value', 20);
    set(handles.slider_averageSpeed_vehicle1to2, 'Min', 0);
    set(handles.slider_averageSpeed_vehicle4to5, 'Min', 0);
    set(handles.slider_averageSpeed_vehicle3, 'Min', 0);
    set(handles.slider_averageSpeed_anchor, 'Min', 0);
    set(handles.slider_averageSpeed_vehicle1to2, 'Max', sliderMax);
    set(handles.slider_averageSpeed_vehicle4to5, 'Max', sliderMax);
    set(handles.slider_averageSpeed_vehicle3, 'Max', sliderMax);
    set(handles.slider_averageSpeed_anchor, 'Max', sliderMax);
    set(handles.slider_averageSpeed_vehicle1to2, 'SliderStep', [1 / (sliderMax), 1 / (sliderMax - 17)]);
    set(handles.slider_averageSpeed_vehicle4to5, 'SliderStep', [1 / (sliderMax), 1 / (sliderMax - 17)]);
    set(handles.slider_averageSpeed_vehicle3, 'SliderStep', [1 / (sliderMax), 1 / (sliderMax - 17)]);
    set(handles.slider_averageSpeed_anchor, 'SliderStep', [1 / (sliderMax), 1 / (sliderMax - 17)]);

    avgVelocity_y_vehicle1to2 = get(handles.slider_averageSpeed_vehicle1to2, 'Value');
    avgVelocity_y_vehicle4to5 = get(handles.slider_averageSpeed_vehicle4to5, 'value');
    avgVelocity_y_vehicle3 = get(handles.slider_averageSpeed_vehicle3, 'value');
    avgVelocity_y_anchor = get(handles.slider_averageSpeed_anchor, 'value');

    set(handles.text_averageSpeed_vehicle1to2, 'String', [num2str(round(3.6 * avgVelocity_y_vehicle1to2)) 'km/h']);
    set(handles.text_averageSpeed_vehicle4to5, 'String', [num2str(round(3.6 * avgVelocity_y_vehicle4to5)) 'km/h']);
    set(handles.text_averageSpeed_vehicle3, 'string', [num2str(round(3.6 * avgVelocity_y_vehicle3)) 'km/h']);
    set(handles.text_averageSpeed_anchor, 'string', [num2str(round(3.6 * avgVelocity_y_anchor)) 'km/h']);

    nIterations = 10; %number of iterations, at each time instant

    set(handles.text_drivingDistance, 'String', [num2str(0) 'm']);
    set(handles.text_elapsedTime, 'String', [num2str(0) 's']);

    set(handles.figure_road, 'XLim', [0 6]);
    set(handles.figure_road, 'XTick', [1 2 3 4 5]);
    set(handles.figure_road, 'XTickLabel', [1 2 3 4 5]);
end

function varargout = v2x_new_decoration_OutputFcn(hObject, eventdata, handles)
    varargout{1} = handles.output;
end

function slider_averageSpeed_vehicle1to2_Callback(hObject, eventdata, handles)
    global avgVelocity_y_vehicle1to2

    avgVelocity_y_vehicle1to2 = round(get(hObject, 'value'));
    set(handles.text_averageSpeed_vehicle1to2, 'string', [num2str(round(3.6 * avgVelocity_y_vehicle1to2)) 'km/h'])
end

function slider_averageSpeed_vehicle1to2_CreateFcn(hObject, eventdata, handles)

    if isequal(get(hObject, 'BackgroundColor'), get(0, 'defaultUicontrolBackgroundColor'))
        set(hObject, 'BackgroundColor', [.9 .9 .9]);
    end

end

function slider_nVehicles_Callback(hObject, eventdata, handles)
    global nVehicles
    nVehicles = round(get(hObject, 'value'));
    set(handles.text_nVehicles, 'string', num2str(nVehicles));

end

function slider_nVehicles_CreateFcn(hObject, eventdata, handles)

    if isequal(get(hObject, 'BackgroundColor'), get(0, 'defaultUicontrolBackgroundColor'))
        set(hObject, 'BackgroundColor', [.9 .9 .9]);
    end

end

function slider_error_distanceMeasurement_Callback(hObject, eventdata, handles)
    global variance_d
    sd_d = get(hObject, 'Value');
    variance_d = sd_d^2;
    set(handles.text_error_distanceMeasurement, 'String', [num2str(round(sd_d * 100) / 100) 'm (s.d.)']);
end

function slider_error_distanceMeasurement_CreateFcn(hObject, eventdata, handles)

    if isequal(get(hObject, 'BackgroundColor'), get(0, 'defaultUicontrolBackgroundColor'))
        set(hObject, 'BackgroundColor', [.9 .9 .9]);
    end

end

function slider_error_angleMeasurement_Callback(hObject, eventdata, handles)

    global variance_theta
    sd_theta = get(hObject, 'Value');
    variance_theta = (pi / 180 * sd_theta)^2;
    set(handles.text_error_angleMeasurement, 'String', [num2str(round(10 * sd_theta) / 10) 'degree (s.d.)']);
end

function slider_error_angleMeasurement_CreateFcn(hObject, eventdata, handles)

    if isequal(get(hObject, 'BackgroundColor'), get(0, 'defaultUicontrolBackgroundColor'))
        set(hObject, 'BackgroundColor', [.9 .9 .9]);
    end

end

function slider_averageSpeed_vehicle4to5_Callback(hObject, eventdata, handles)
    global avgVelocity_y_vehicle4to5
    avgVelocity_y_vehicle4to5 = round(get(hObject, 'value'));
    set(handles.text_averageSpeed_vehicle4to5, 'string', [num2str(round(3.6 * avgVelocity_y_vehicle4to5)) 'km/h'])
end

function slider_averageSpeed_vehicle4to5_CreateFcn(hObject, eventdata, handles)

    if isequal(get(hObject, 'BackgroundColor'), get(0, 'defaultUicontrolBackgroundColor'))
        set(hObject, 'BackgroundColor', [.9 .9 .9]);
    end

end

function slider_averageSpeed_vehicle3_Callback(hObject, eventdata, handles)
    global avgVelocity_y_vehicle3
    avgVelocity_y_vehicle3 = round(get(hObject, 'value'));
    set(handles.text_averageSpeed_vehicle3, 'string', [num2str(round(3.6 * avgVelocity_y_vehicle3)) 'km/h'])
end

function slider_averageSpeed_vehicle3_CreateFcn(hObject, eventdata, handles)

    if isequal(get(hObject, 'BackgroundColor'), get(0, 'defaultUicontrolBackgroundColor'))
        set(hObject, 'BackgroundColor', [.9 .9 .9]);
    end

end

function slider_averageSpeed_anchor_Callback(hObject, eventdata, handles)
    global avgVelocity_y_anchor
    avgVelocity_y_anchor = round(get(hObject, 'value'));
    set(handles.text_averageSpeed_anchor, 'string', [num2str(round(3.6 * avgVelocity_y_anchor)) 'km/h'])
end

function slider_averageSpeed_anchor_CreateFcn(hObject, eventdata, handles)

    if isequal(get(hObject, 'BackgroundColor'), get(0, 'defaultUicontrolBackgroundColor'))
        set(hObject, 'BackgroundColor', [.9 .9 .9]);
    end

end
%--------------------------- Iteration -------------------------------

function slider_nIterations_Callback(hObject, eventdata, handles)
    global nIterations
    nIterations = round(get(hObject, 'value'));
    set(handles.text_nIterations, 'string', num2str(nIterations));
end

function slider_nIterations_CreateFcn(hObject, eventdata, handles)

    if isequal(get(hObject, 'BackgroundColor'), get(0, 'defaultUicontrolBackgroundColor'))
        set(hObject, 'BackgroundColor', [.9 .9 .9]);
    end

end

%---------------------------Initial Position-------------------------------

function slider_initialPosition_vehicle1_Callback(hObject, eventdata, handles)
    global initialPosition_vehicle1
    initialPosition_vehicle1 = get(hObject, 'Value');
    set(handles.text_currentPosition_vehicle1, 'string', [num2str(round(initialPosition_vehicle1)) 'm']);
end

function slider_initialPosition_vehicle1_CreateFcn(hObject, eventdata, handles)

    if isequal(get(hObject, 'BackgroundColor'), get(0, 'defaultUicontrolBackgroundColor'))
        set(hObject, 'BackgroundColor', [.9 .9 .9]);
    end

end

function slider_initialPosition_vehicle2_Callback(hObject, eventdata, handles)

    global initialPosition_vehicle2
    initialPosition_vehicle2 = get(hObject, 'value');
    set(handles.text_currentPosition_vehicle2, 'string', [num2str(round(initialPosition_vehicle2)) 'm']);

end

function slider_initialPosition_vehicle2_CreateFcn(hObject, eventdata, handles)

    if isequal(get(hObject, 'BackgroundColor'), get(0, 'defaultUicontrolBackgroundColor'))
        set(hObject, 'BackgroundColor', [.9 .9 .9]);
    end

end

function Slider_InitialPosition_6_Callback(hObject, eventdata, handles)
    global initialPosition_vehicle6
    initialPosition_vehicle6 = get(hObject, 'value');
    set(handles.text_currentPosition_vehicle6, 'string', [num2str(round(initialPosition_vehicle6)) 'm']);
end

function Slider_InitialPosition_6_CreateFcn(hObject, eventdata, handles)

    if isequal(get(hObject, 'BackgroundColor'), get(0, 'defaultUicontrolBackgroundColor'))
        set(hObject, 'BackgroundColor', [.9 .9 .9]);
    end

end

function slider_initialPosition_vehicle7_Callback(hObject, eventdata, handles)
    global initialPosition_vehicle7
    initialPosition_vehicle7 = get(hObject, 'value');
    set(handles.text_currentPosition_vehicle7, 'string', [num2str(round(initialPosition_vehicle7)) 'm']);

end

function slider_initialPosition_vehicle7_CreateFcn(hObject, eventdata, handles)

    if isequal(get(hObject, 'BackgroundColor'), get(0, 'defaultUicontrolBackgroundColor'))
        set(hObject, 'BackgroundColor', [.9 .9 .9]);
    end

end

function slider_initialPosition_vehicle9_Callback(hObject, eventdata, handles)
    global initialPosition_vehicle9
    initialPosition_vehicle9 = get(hObject, 'value');
    set(handles.text_currentPosition_vehicle9, 'string', [num2str(round(initialPosition_vehicle9)) 'm']);
end

function slider_initialPosition_vehicle9_CreateFcn(hObject, eventdata, handles)

    if isequal(get(hObject, 'BackgroundColor'), get(0, 'defaultUicontrolBackgroundColor'))
        set(hObject, 'BackgroundColor', [.9 .9 .9]);
    end

end

function Slider_InitialPosition_10_Callback(hObject, eventdata, handles)
    global initialPosition_vehicle10
    initialPosition_vehicle10 = get(hObject, 'value');
    set(handles.text_currentPosition_vehicle10, 'string', [num2str(round(initialPosition_vehicle10)) 'm']);
end

function Slider_InitialPosition_10_CreateFcn(hObject, eventdata, handles)

    if isequal(get(hObject, 'BackgroundColor'), get(0, 'defaultUicontrolBackgroundColor'))
        set(hObject, 'BackgroundColor', [.9 .9 .9]);
    end

end

function slider_initialPosition_vehicle5_Callback(hObject, eventdata, handles)
    global initialPosition_vehicle5
    initialPosition_vehicle5 = get(hObject, 'value');
    set(handles.text_currentPosition_vehicle5, 'string', [num2str(round(initialPosition_vehicle5)) 'm']);
end

function slider_initialPosition_vehicle5_CreateFcn(hObject, eventdata, handles)

    if isequal(get(hObject, 'BackgroundColor'), get(0, 'defaultUicontrolBackgroundColor'))
        set(hObject, 'BackgroundColor', [.9 .9 .9]);
    end

end

function Slider_InitialPosition_4_Callback(hObject, eventdata, handles)
    global initialPosition_vehicle4
    initialPosition_vehicle4 = get(hObject, 'value');
    set(handles.text_currentPosition_vehicle4, 'string', [num2str(round(initialPosition_vehicle4)) 'm']);
end

function Slider_InitialPosition_4_CreateFcn(hObject, eventdata, handles)

    if isequal(get(hObject, 'BackgroundColor'), get(0, 'defaultUicontrolBackgroundColor'))
        set(hObject, 'BackgroundColor', [.9 .9 .9]);
    end

end

function slider_initialPosition_vehicle3_Callback(hObject, eventdata, handles)
    global initialPosition_vehicle3
    initialPosition_vehicle3 = get(hObject, 'value');
    set(handles.text_currentPosition_vehicle3, 'string', [num2str(round(initialPosition_vehicle3)) 'm']);
end

function slider_initialPosition_vehicle3_CreateFcn(hObject, eventdata, handles)

    if isequal(get(hObject, 'BackgroundColor'), get(0, 'defaultUicontrolBackgroundColor'))
        set(hObject, 'BackgroundColor', [.9 .9 .9]);
    end

end

function slider_initialPosition_vehicle8_Callback(hObject, eventdata, handles)
    global initialPosition_vehicle8
    initialPosition_vehicle8 = get(hObject, 'value');
    set(handles.text_currentPosition_vehicle8, 'string', [num2str(round(initialPosition_vehicle8)) 'm']);
end

function slider_initialPosition_vehicle8_CreateFcn(hObject, eventdata, handles)

    if isequal(get(hObject, 'BackgroundColor'), get(0, 'defaultUicontrolBackgroundColor'))
        set(hObject, 'BackgroundColor', [.9 .9 .9]);
    end

end

function Button_Start_Callback(hObject, eventdata, handles)
    %--------------------10 vehicles, 2/2/2/2/2--------------------------
    global variance_d variance_theta nVehicles avgVelocity_y_vehicle1to2 avgVelocity_y_vehicle4to5 ...
        avgVelocity_y_vehicle3 avgVelocity_y_anchor variation_movement_xAxis ...
        variation_movement_yAxis nLanes timeInterval avgVelocity_x_all ...
        nIterations initialPosition_vehicle1 initialPosition_vehicle2 ...
        initialPosition_vehicle3 initialPosition_vehicle4 initialPosition_vehicle5 ...
        initialPosition_vehicle6 initialPosition_vehicle7 initialPosition_vehicle8 ...
        initialPosition_vehicle9 initialPosition_vehicle10 anchor

    anchor = round(nVehicles / 2);

    currentPositions_x = [1 1 2 2 3 3 4 4 5 5]' * 3.5; %3.5: width of the lanes, in meter
    currentPositions_y = [initialPosition_vehicle1 initialPosition_vehicle2 ...
                            initialPosition_vehicle3 initialPosition_vehicle4 initialPosition_vehicle5 ...
                            initialPosition_vehicle6 initialPosition_vehicle7 initialPosition_vehicle8 ...
                            initialPosition_vehicle9 initialPosition_vehicle10]';
    currentPositions_y = currentPositions_y + randn(size(currentPositions_y));
    currentPositions = [currentPositions_x currentPositions_y];

    distances = squareform(pdist(currentPositions));

    distances_observed = distances + ...
        sqrt(variance_d) * randn(size(distances)); %z_ijn
    distances_observed(1:1 + size(distances_observed, 1):end) = 0; %eliminating diagonal entries

    coorinateDifferences = repmat(permute(currentPositions, [1 3 2]), [1 nVehicles]) ...
        - repmat(permute(currentPositions, [3 1 2]), [nVehicles 1]);
    %coorinateDifferences(:,:,1) for x-axis, coorinateDifferences(:,:,2) for y-axis
    aoa = atan(coorinateDifferences(:, :, 2) ./ coorinateDifferences(:, :, 1)) ...
        + (coorinateDifferences(:, :, 1) < 0) * pi;
    aoa(1:1 + size(aoa, 1):end) = 0; %eliminating diagonal entries

    aoa_observed = aoa + ...
        sqrt(variance_theta) * randn(size(aoa)); %theta_ijn
    aoa_observed(1:nVehicles + 1:end) = 0;

    colorMap = colormap('lines');

    currentPositions_history(:, :, 1) = currentPositions;

    distances_history(:, :, 1) = distances;
    distances_observed_history(:, :, 1) = distances_observed;

    aoa_history(:, :, 1) = aoa;
    aoa_observed_history(:, :, 1) = aoa_observed;

    %Gaussian approximation
    beliefMean = currentPositions + sqrt(variance_d) * randn(size(currentPositions)) / 2; %initial message parameter definition (initial belief)
    beliefMean_history(:, :, 1) = beliefMean;

    x = squareform(pdist(beliefMean_history(:, 1, 1)));
    y = squareform(pdist(beliefMean_history(:, 2, 1)));
    distances_belief_history(:, :, 1) = sqrt(x.^2 + y.^2);

    x = squareform(pdist(currentPositions_history(:, 1, 1)));
    y = squareform(pdist(currentPositions_history(:, 2, 1)));
    distances_actual_history(:, :, 1) = sqrt(x.^2 + y.^2);

    relativeDifferences = distances_actual_history(:, :, 1) - distances_belief_history(:, :, 1);
    relativeError(1) = mean(abs(relativeDifferences), 'all');

    absoluteDifferences = currentPositions_history(:, :, 1) - beliefMean_history(:, :, 1);
    absoluteDifferences_L2 = sqrt(sum(absoluteDifferences.^2, 2)); %L2 norm
    absoluteError(1) = mean(absoluteDifferences_L2);

    beliefVariance = variance_d * ones(size(currentPositions));
    beliefVariance_history(:, :, 1) = beliefVariance;

    timeStep = 0;

    while get(hObject, 'Value')
        timeStep = timeStep + 1;
        set(handles.text_elapsedTime, 'String', [num2str(timeInterval * timeStep) 's']);
        set(hObject, 'String', 'Stop');

        % factor to variable messge update (f_i --> x_{i,n})
        for j = 1:nVehicles

            if j == anchor
                fi2xin_mean(anchor, :) = beliefMean(anchor, :) ...
                    + [avgVelocity_x_all avgVelocity_y_anchor] * timeInterval;
            else

                if currentPositions(j, 1) < 8.5
                    fi2xin_mean(j, :) = beliefMean(j, :) ...
                        + [avgVelocity_x_all avgVelocity_y_vehicle1to2] * timeInterval;
                elseif currentPositions(j, 1) >= 8.5 && currentPositions(j, 1) < 13
                    fi2xin_mean(j, :) = beliefMean(j, :) ...
                        + [avgVelocity_x_all avgVelocity_y_vehicle3] * timeInterval;
                else
                    fi2xin_mean = beliefMean + ...
                        repmat([avgVelocity_x_all avgVelocity_y_vehicle4to5], [size(beliefMean, 1) 1]) * timeInterval;
                end

            end

        end

        fi2xin_variance = beliefVariance + ...
            repmat([variation_movement_xAxis variation_movement_yAxis], [size(beliefVariance, 1) 1]);

        intbelmean1 = fi2xin_mean;
        intbelvar1 = fi2xin_variance;

        xin2fij_mean = intbelmean1;
        xin2fij_variance = intbelvar1;

        fij2xin_mean = zeros([size(distances_observed), 2]);
        fij2xin_variance = zeros([size(distances_observed), 2]);
        % cooperative positioning (intervehicular iteration)
        for iter = 1:nIterations
            % factor to variable message update (f_{i,j} --> x_{i,n})
            for v1 = 1:nVehicles
                sum_fij2xin_mean = [0 0];
                sum_fij2xin_variance = [0 0];

                for v2 = 1:nVehicles

                    if v1 ~= v2 && abs(distances_observed(v1, v2)) > eps
                        x = variance_d * cos(aoa_observed(v1, v2))^2 + ...
                            distances_observed(v1, v2)^2 * variance_theta * ...
                            sin(aoa_observed(v1, v2))^2;
                        y = variance_d * sin(aoa_observed(v1, v2))^2 + ...
                            distances_observed(v1, v2)^2 * variance_theta * ...
                            cos(aoa_observed(v1, v2))^2;
                        fij2xin_variance(v1, v2, :) = xin2fij_variance(v2, :) + [x y];

                        sum_fij2xin_mean = sum_fij2xin_mean + squeeze(fij2xin_mean(v1, v2, :) ./ fij2xin_variance(v1, v2, :)).';
                        sum_fij2xin_variance = sum_fij2xin_variance + squeeze(1 ./ fij2xin_variance(v1, v2, :)).';

                        if v2 ~= anchor
                            fij2xin_mean(v1, v2, :) = xin2fij_mean(v2, :) + ...
                                distances_observed(v1, v2) * ...
                                [cos(aoa_observed(v1, v2)) sin(aoa_observed(v1, v2))];
                        else % i.e., v2 is anchor
                            fij2xin_mean(v1, v2, :) = currentPositions(v2, :) + ...
                                distances_observed(v1, v2) * ...
                                [cos(aoa_observed(v1, v2)) sin(aoa_observed(v1, v2))];
                        end

                    end %condition_ v1 ~= v2 && abs(distances_observed(v1,v2)) > eps

                end %loop_ v2 = 1:nVehicles

                intbelvar1(v1, :) = 1 ./ (1 ./ fi2xin_variance(v1, :) + sum_fij2xin_variance);
                intbelmean1(v1, :) = intbelvar1(v1, :) .* (fi2xin_mean(v1, :) ./ fi2xin_variance(v1, :) + sum_fij2xin_mean);
            end %loop_ v1 = 1:nVehicles

            xin2fij_mean = intbelmean1;
            xin2fij_variance = intbelvar1;
        end %loop_ iter = 1:nIterations

        beliefMean = intbelmean1;
        beliefVariance = intbelvar1;
        beliefMean_history(:, :, timeStep + 1) = beliefMean;
        beliefVariance_history(:, :, timeStep + 1) = beliefVariance;

        currentPositions_history(:, :, timeStep + 1) = currentPositions;

        distances = squareform(pdist(currentPositions));
        distances_history(:, :, timeStep + 1) = distances;

        distances_observed = distances + ...
            sqrt(variance_d) * randn(size(distances)); %z_ijn
        distances_observed(1:1 + size(distances_observed, 1):end) = 0; %eliminating diagonal entries
        distances_observed_history(:, :, timeStep + 1) = distances_observed; % history of observed distance

        coorinateDifferences = repmat(permute(currentPositions, [1 3 2]), [1 nVehicles]) ...
            - repmat(permute(currentPositions, [3 1 2]), [nVehicles 1]);
        %coorinateDifferences(:,:,1) for x-axis, coorinateDifferences(:,:,2) for y-axis
        aoa = atan(coorinateDifferences(:, :, 2) ./ coorinateDifferences(:, :, 1)) ...
            + (coorinateDifferences(:, :, 1) < 0) * pi;
        aoa(1:1 + size(aoa, 1):end) = 0; %eliminating diagonal entries
        aoa_history(:, :, timeStep + 1) = aoa;

        aoa_observed = aoa + ...
            sqrt(variance_theta) * randn(size(aoa)); %theta_ijn
        aoa_observed(1:nVehicles + 1:end) = 0; %eliminating diagonal entries
        aoa_observed_history(:, :, timeStep + 1) = aoa_observed;

        set(handles.text_drivingDistance, 'String', [num2str(round(max(currentPositions(:, 2)))) 'm']);

        for j = 1:nVehicles

            if j == anchor
                currentPositions(anchor, :) = currentPositions(anchor, :) + ...
                    [avgVelocity_x_all avgVelocity_y_anchor] * timeInterval;
            else

                if currentPositions(j, 1) < 8.5
                    currentPositions(j, :) = currentPositions(j, :) + ...
                        [avgVelocity_x_all avgVelocity_y_vehicle1to2] * timeInterval;
                elseif currentPositions(j, 1) >= 8.5 && currentPositions(j, 1) < 13
                    currentPositions(j, :) = currentPositions(j, :) + ...
                        [avgVelocity_x_all avgVelocity_y_vehicle3] * timeInterval;
                else
                    currentPositions(j, :) = currentPositions(j, :) + ...
                        [avgVelocity_x_all avgVelocity_y_vehicle4to5] * timeInterval;
                end

            end

        end

        %relative error
        x = repmat(beliefMean_history(:, 1, timeStep + 1), [1 nVehicles]) - repmat(beliefMean_history(:, 1, timeStep + 1).', [nVehicles 1]);
        y = repmat(beliefMean_history(:, 2, timeStep + 1), [1 nVehicles]) - repmat(beliefMean_history(:, 2, timeStep + 1).', [nVehicles 1]);
        distances_belief_history(:, :, timeStep + 1) = sqrt(x.^2 + y.^2);

        x = repmat(currentPositions_history(:, 1, timeStep + 1), [1 nVehicles]) - repmat(currentPositions_history(:, 1, timeStep + 1).', [nVehicles 1]);
        y = repmat(currentPositions_history(:, 2, timeStep + 1), [1 nVehicles]) - repmat(currentPositions_history(:, 2, timeStep + 1).', [nVehicles 1]);
        distances_actual_history(:, :, timeStep + 1) = sqrt(x.^2 + y.^2);

        for_error = abs(distances_actual_history(:, :, timeStep + 1) - distances_belief_history(:, :, timeStep + 1));
        for_error_agent = for_error(1, :);

        %for anchor and agent
        for j = 2:nVehicles

            if j == anchor
                for_error_anchor = for_error(anchor, :);
            else
                for_error_agent = horzcat(for_error_agent, for_error(j, :));
            end

        end

        relativeError_anchor(timeStep + 1) = mean(for_error_anchor, 2);
        relativeError_anchor_avg = sum(relativeError_anchor) / timeStep;

        relativeError_agent(timeStep + 1) = mean(mean(for_error_agent, 2), 1);
        relativeError_agent_avg = sum(relativeError_agent) / timeStep;

        set(handles.text_relError_anchor_avg, 'string', [num2str(round(relativeError_anchor_avg, 3)) 'm'])
        set(handles.text_relError_anchor_max, 'string', [num2str(max(round(relativeError_anchor, 3))) 'm'])
        set(handles.text_relError_anchor_min, 'string', [num2str(min(round(relativeError_anchor(2:timeStep + 1), 3))) 'm'])

        set(handles.text_relError_agent_avg, 'string', [num2str(round(relativeError_agent_avg, 3)) 'm'])
        set(handles.text_relError_agent_max, 'string', [num2str(max(round(relativeError_agent, 3))) 'm'])
        set(handles.text_relError_agent_min, 'string', [num2str(min(round(relativeError_agent(2:timeStep + 1), 3))) 'm'])

        % total error
        relativeError(timeStep + 1) = mean(mean(for_error, 1), 2);
        relativeError_average = sum(relativeError) / timeStep;

        set(handles.text_relError_total_avg, 'String', [num2str(round(relativeError_average, 3)) 'm'])
        set(handles.text_relError_total_max, 'string', [num2str(max(round(relativeError, 3))) 'm'])
        set(handles.text_relError_total_min, 'string', [num2str(min(round(relativeError, 3))) 'm'])

        % absolute error
        for_abs_error = (currentPositions_history(:, :, timeStep + 1) - beliefMean_history(:, :, timeStep + 1)).^2;

        % for anchor and agent
        absoluteError_anchor(timeStep + 1) = (sqrt(sum(currentPositions_history(anchor, :, timeStep + 1) - beliefMean_history(anchor, :, timeStep + 1)).^2));
        for_abs_error(anchor, :) = [];
        absoluteError_agent(timeStep + 1) = (sum(sqrt(sum(for_abs_error, 2)), 1)) / (nVehicles - length(anchor));

        absoluteError_anchor_avg = sum(absoluteError_anchor) / timeStep;
        absoluteError_agent_avg = sum(absoluteError_agent) / timeStep;

        set(handles.text_absError_anchor_avg, 'String', [num2str(round(absoluteError_anchor_avg, 3)) 'm'])
        set(handles.text_absError_anchor_max, 'string', [num2str(max(round(absoluteError_anchor, 3))) 'm'])
        set(handles.text_absError_anchor_min, 'string', [num2str(min(round(absoluteError_anchor(2:timeStep + 1), 3))) 'm'])

        set(handles.text_absError_agent_avg, 'String', [num2str(round(absoluteError_agent_avg, 3)) 'm'])
        set(handles.text_absError_agent_max, 'string', [num2str(max(round(absoluteError_agent, 3))) 'm'])
        set(handles.text_absError_agent_min, 'string', [num2str(min(round(absoluteError_agent(2:timeStep + 1), 3))) 'm'])

        %for total error
        absoluteError(timeStep + 1) = mean(sqrt(sum((currentPositions_history(:, :, timeStep + 1) - beliefMean_history(:, :, timeStep + 1)).^2, 2)), 1);
        absoluteError_avg = sum(absoluteError) / timeStep;
        set(handles.text_absError_total_avg, 'String', [num2str(round(absoluteError_avg, 3)) 'm'])
        set(handles.text_absError_total_max, 'string', [num2str(max(round(absoluteError, 3))) 'm'])
        set(handles.text_absError_total_min, 'string', [num2str(min(round(absoluteError, 3))) 'm'])

        if timeStep == 1
            comstr1 = ['gh1=plot(handles.figure_road'];

            for iter = 1:nVehicles
                comstr1 = strcat(comstr1, ',squeeze(currentPositions_history(', num2str(iter), ',1,1:timeStep+1))/3.5,squeeze(currentPositions_history(', num2str(iter), ',2,1:timeStep+1)),''--'''); % Middle
            end

            for iter = 1:nVehicles

                if iter == anchor
                    comstr1 = strcat(comstr1, ',squeeze(beliefMean_history(', num2str(iter), ',1,1:timeStep+1))/3.5,squeeze(beliefMean_history(', num2str(iter), ',2,1:timeStep+1)),''-*'''); %Anchor
                else
                    comstr1 = strcat(comstr1, ',squeeze(beliefMean_history(', num2str(iter), ',1,1:timeStep+1))/3.5,squeeze(beliefMean_history(', num2str(iter), ',2,1:timeStep+1)),''-'''); %Vehicle
                end

            end

            A = [avgVelocity_y_vehicle1to2, avgVelocity_y_vehicle4to5, avgVelocity_y_vehicle3, avgVelocity_y_anchor];
            comstr1 = strcat(comstr1, ',[0.5 0.5]', ',[0 max(currentPositions(:,2))+timeInterval*max(A)]', ',''w'''); % lane (white)

            for iter = 1:nLanes - 1
                comstr1 = strcat(comstr1, ',[0.5 0.5]+', num2str(iter), ',[0 max(currentPositions(:,2))+timeInterval*max(A)],''w'''); % lane (white black:k)
            end

            comstr1 = strcat(comstr1, ',[0.5 0.5]+', num2str(nLanes), ',[0 max(currentPositions(:,2))+timeInterval*max(A)],''w'''); % lane (white)
            comstr1 = strcat(comstr1, ');');
            eval(comstr1);

            % Colors of estimates and ground truths
            for iter = 1:2:nVehicles
                set(gh1(iter), 'Color', colorMap(iter, :));
                set(gh1(nVehicles + iter), 'Color', colorMap(iter, :));
            end

            set(handles.figure_road, 'XLim', [0 6]);
            set(handles.figure_road, 'XTick', [1 2 3 4 5]);
            set(handles.figure_road, 'XTickLabel', [1 2 3 4 5]);
            set(handles.figure_road, 'YLim', [0 round(max(currentPositions(:, 2)))]); %round(max(currentPositions(:,2)))-20
            ylabel(handles.figure_road, 'Mileage (meter)', 'FontSize', 8);
            xlabel(handles.figure_road, [num2str(nLanes) ' Lanes (lane width: 3.5 m)'], 'FontSize', 8);

            axes(handles.figure_road);
            rectangle('position', [0 -100 35 90000000], 'facecolor', [.7 .7 .7]);
            %FaceAlpha(r,.3)
            %plot(handles.figure_road,[1 2 3 4 5]*3.5,inf,'--' )

            %relative error
            axes(handles.axes_relError_total);
            gh10 = plot(max(A) * timeInterval * [1:timeStep + 1], relativeError(1:timeStep + 1));
            xlabel(handles.axes_relError_total, 'dist(anchor)', 'FontSize', 8);
            ylabel(handles.axes_relError_total, 'error (meter)', 'FontSize', 8);
            set(handles.axes_relError_total, 'XLim', max(A) * timeInterval * [1:timeStep + 1]);

            %relative error - anchor
            axes(handles.axes_relError_anchor);
            gh12 = plot(max(A) * timeInterval * [1:timeStep + 1], relativeError_anchor(1:timeStep + 1));
            xlabel(handles.axes_relError_anchor, 'dist(anchor)', 'FontSize', 8);
            ylabel(handles.axes_relError_anchor, 'error (meter)', 'FontSize', 8);
            set(handles.axes_relError_anchor, 'XLim', max(A) * timeInterval * [1:timeStep + 1]);

            %relative error - agents
            axes(handles.axes_relError_agent);
            gh14 = plot(max(A) * timeInterval * [1:timeStep + 1], relativeError_agent(1:timeStep + 1));
            xlabel(handles.axes_relError_agent, 'dist(anchor)', 'FontSize', 8);
            ylabel(handles.axes_relError_agent, 'error (meter)', 'FontSize', 8);
            set(handles.axes_relError_agent, 'XLim', max(A) * timeInterval * [1:timeStep + 1]);

            %absolute error
            axes(handles.axes_absError_total);
            gh9 = plot(max(A) * timeInterval * [1:timeStep + 1], absoluteError(1:timeStep + 1));
            xlabel(handles.axes_absError_total, 'dist(anchor)', 'FontSize', 8);
            ylabel(handles.axes_absError_total, 'error (meter)', 'FontSize', 8);
            set(handles.axes_absError_total, 'XLim', max(A) * timeInterval * [1:timeStep + 1]);

            %absolute error - anchor
            axes(handles.axes_absError_anchor);
            gh11 = plot(max(A) * timeInterval * [1:timeStep + 1], absoluteError_anchor(1:timeStep + 1));
            xlabel(handles.axes_absError_anchor, 'dist(anchor)', 'FontSize', 8);
            ylabel(handles.axes_absError_anchor, 'error (meter)', 'FontSize', 8);
            set(handles.axes_absError_anchor, 'XLim', max(A) * timeInterval * [1:timeStep + 1]);

            %absolute error - anchor
            axes(handles.axes_absError_agent);
            gh13 = plot(max(A) * timeInterval * [1:timeStep + 1], absoluteError_anchor(1:timeStep + 1));
            xlabel(handles.axes_absError_anchor, 'dist(anchor)', 'FontSize', 8);
            ylabel(handles.axes_absError_anchor, 'error (meter)', 'FontSize', 8);
            set(handles.axes_absError_agent, 'XLim', max(A) * timeInterval * [1:timeStep + 1]);

        else

            for iter = 1:nVehicles
                set(gh1(iter), 'Xdata', squeeze(currentPositions_history(iter, 1, 1:timeStep + 1)) / 3.5, 'Ydata', squeeze(currentPositions_history(iter, 2, 1:timeStep + 1)));
                set(gh1(nVehicles + iter), 'Xdata', squeeze(beliefMean_history(iter, 1, 1:timeStep + 1)) / 3.5, 'Ydata', squeeze(beliefMean_history(iter, 2, 1:timeStep + 1)));
            end

            for iter = 0:nLanes
                set(gh1(2 * nVehicles + iter + 1), 'Xdata', [0.5 0.5] + iter, 'Ydata', [0 max(currentPositions(:, 2)) + timeInterval * max(A)]); % assuming that avgVelocity_y_vehicle4to5 is higher
            end

            set(handles.figure_road, 'YLim', [round(min(currentPositions(:, 2))) - 50 round(max(currentPositions(:, 2))) + 20]); % to show both the least-speed node and greatest-speed node

            % absolute/relative errors
            %gh10=plot(handles.axes_relError_total,avgVelocity_y_vehicle3*timeInterval*[1:timeStep+1],relativeError(1:timeStep+1));
            set(gh10, 'Xdata', max(A) * timeInterval * [1:timeStep + 1], 'Ydata', relativeError(1:timeStep + 1));
            set(handles.axes_relError_total, 'XLim', [0 round(max(currentPositions(:, 2)))]);

            set(gh12, 'Xdata', max(A) * timeInterval * [1:timeStep + 1], 'Ydata', relativeError_anchor(1:timeStep + 1));
            set(handles.axes_relError_anchor, 'XLim', [0 round(max(currentPositions(:, 2)))]);

            set(gh14, 'Xdata', max(A) * timeInterval * [1:timeStep + 1], 'Ydata', relativeError_agent(1:timeStep + 1));
            set(handles.axes_relError_agent, 'XLim', [0 round(max(currentPositions(:, 2)))]);

            %set(gh9,'Xdata',timeInterval*[1:timeStep+1],'Ydata',absoluteError(1:timeStep+1));
            set(gh9, 'Xdata', max(A) * timeInterval * [1:timeStep + 1], 'Ydata', absoluteError(1:timeStep + 1));
            set(handles.axes_absError_total, 'XLim', [0 round(max(currentPositions(:, 2)))]);

            set(gh11, 'Xdata', max(A) * timeInterval * [1:timeStep + 1], 'Ydata', absoluteError_anchor(1:timeStep + 1));
            set(handles.axes_absError_anchor, 'XLim', [0 round(max(currentPositions(:, 2)))]);

            set(gh13, 'Xdata', max(A) * timeInterval * [1:timeStep + 1], 'Ydata', absoluteError_agent(1:timeStep + 1));
            set(handles.axes_absError_agent, 'XLim', [0 round(max(currentPositions(:, 2)))]);

        end

        drawnow
    end

    set(hObject, 'string', 'start');
    set(handles.slider_nVehicles, 'enable', 'on');
end
