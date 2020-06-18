function varargout = v2x_new_decoration(varargin)
% V2X_NEW_DECORATION MATLAB code for v2x_new_decoration.fig
%      V2X_NEW_DECORATION, by itself, creates a new V2X_NEW_DECORATION or raises the existing
%      singleton*.
%
%      H = V2X_NEW_DECORATION returns the handle to a new V2X_NEW_DECORATION or the handle to
%      the existing singleton*.
%
%      V2X_NEW_DECORATION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in V2X_NEW_DECORATION.M with the given input arguments.
%
%      V2X_NEW_DECORATION('Property','Value',...) creates a new V2X_NEW_DECORATION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before v2x_new_decoration_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to v2x_new_decoration_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help v2x_new_decoration

% Last Modified by GUIDE v2.5 29-Aug-2018 14:32:18

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @v2x_new_decoration_OpeningFcn, ...
                   'gui_OutputFcn',  @v2x_new_decoration_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before v2x_new_decoration is made visible.
function v2x_new_decoration_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to v2x_new_decoration (see VARARGIN)

% Choose default command line output for v2x_new_decoration
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes v2x_new_decoration wait for user response (see UIRESUME)
% uiwait(handles.figure1);

global vard vartheta nveh vely vely2 vely3 vely4 varux varuy nlan tdelta velx niter in_vpos1 in_vpos2 in_vpos3 in_vpos4 in_vpos5 in_vpos6 in_vpos7 in_vpos8 in_vpos9 in_vpos10
arrayfun(@cla,findall(0, 'type','axes'))

numSteps = 20;
set(handles.slider3, 'Min', 0);
set(handles.slider3, 'Max', numSteps);
set(handles.slider3,'Value',1);  %1 %variance of distance estimation
set(handles.slider3, 'SliderStep', [1/(numSteps-1) , 1/(numSteps-1) ]);
vard=get(handles.slider3,'Value')^2;
set(handles.text12, 'String', [num2str(round(100*get(handles.slider3,'Value'))/100) 'm']);


numSteps = 20;
set(handles.slider4, 'Min', 0);
set(handles.slider4, 'Max', numSteps);
set(handles.slider4,'Value',3); %variance of aoa
vartheta=(pi/180*get(handles.slider4,'Value'))^2;
set(handles.text13, 'String', [num2str(round(10*get(handles.slider4,'Value'))/10) 'deg']);

numSteps = 30;
set(handles.slider2, 'Min', 1);
set(handles.slider2, 'Max', numSteps);
set(handles.slider2, 'Value', 10);
set(handles.slider2, 'SliderStep', [1/(numSteps-1) , 1/(numSteps-1)]);
nveh=round(get(handles.slider2,'Value')); % number of vehicles
set(handles.text8, 'String', num2str(nveh));

numSteps = 300;
set(handles.slider18, 'Min', 1);
set(handles.slider18, 'Max', numSteps);
set(handles.slider18, 'Value', 10);
set(handles.slider18, 'SliderStep', [1/(numSteps-1) ,10/(numSteps-1)]);
niter=round(get(handles.slider18,'Value')); % number of vehicles
set(handles.text105, 'String', num2str(niter));


numSteps=200;
set(handles.slider7,'Min',0);
set(handles.slider7,'Max',300);
set(handles.slider7,'Value',0);
set(handles.slider7,'SliderStep', [10/(numSteps-1) , 10/(numSteps-1)]);
in_vpos1= get(handles.slider7,'Value'); %initial vpos 1(왼쪽부터 1임)
set(handles.text60, 'String', num2str((round(in_vpos1))));

set(handles.slider8,'Min',0);
set(handles.slider8,'Max',300);
set(handles.slider8,'Value',0);
set(handles.slider8,'SliderStep', [10/(numSteps-1) , 10/(numSteps-1)]);
in_vpos2=get(handles.slider8,'Value');
set(handles.text62, 'String', num2str((round(in_vpos2))));

set(handles.slider15,'Min',0);
set(handles.slider15,'Max',300);
set(handles.slider15,'Value',0);
set(handles.slider15,'SliderStep', [10/(numSteps-1) , 10/(numSteps-1)]);
in_vpos3=get(handles.slider15,'Value');
set(handles.text64, 'String', num2str((round(in_vpos3))));

set(handles.slider14,'Min',0);
set(handles.slider14,'Max',300);
set(handles.slider14,'Value',0);
set(handles.slider14,'SliderStep', [10/(numSteps-1) , 10/(numSteps-1)]);
in_vpos4=get(handles.slider14,'Value');
set(handles.text66, 'String', num2str((round(in_vpos4))));

set(handles.slider13,'Min',0);
set(handles.slider13,'Max',300);
set(handles.slider13,'Value',0);
set(handles.slider13,'SliderStep', [1/(numSteps-1) , 1/(numSteps-1)]);
in_vpos5=get(handles.slider13,'Value');
set(handles.text70, 'String', num2str((round(in_vpos5))));

set(handles.slider9,'Min',0);
set(handles.slider9,'Max',300);
set(handles.slider9,'Value', 0);
set(handles.slider9,'SliderStep', [10/(numSteps-1) , 10/(numSteps-1)]);
in_vpos6=get(handles.slider7,'Value');
set(handles.text72, 'String', num2str((round(in_vpos6))));

set(handles.slider10,'Min',0);
set(handles.slider10,'Max',300);
set(handles.slider10,'Value',0);
set(handles.slider10,'SliderStep', [10/(numSteps-1) , 10/(numSteps-1)]);
in_vpos7=get(handles.slider10,'Value');
set(handles.text74, 'String', num2str((round(in_vpos7))));

set(handles.slider16,'Min',0);
set(handles.slider16,'Max',200);
set(handles.slider16,'Value',0);
set(handles.slider16,'SliderStep', [10/(numSteps-1) , 10/(numSteps-1)]);
in_vpos8=get(handles.slider16,'Value');
set(handles.text76, 'String', num2str((round(in_vpos8))));

set(handles.slider11,'Min',0);
set(handles.slider11,'Max',300);
set(handles.slider11,'Value',0);
set(handles.slider11,'SliderStep', [10/(numSteps-1) , 10/(numSteps-1)]);
in_vpos9=get(handles.slider11,'Value');
set(handles.text78, 'String', num2str((round(in_vpos9))));

set(handles.slider12,'Min',0);
set(handles.slider12,'Max',300);
set(handles.slider12,'Value',0);
set(handles.slider12,'SliderStep', [10/(numSteps-1) , 10/(numSteps-1)]);
in_vpos10=get(handles.slider12,'Value');
set(handles.text80, 'String', num2str(round(in_vpos10)));






varux=0.1; % x-axis vehicle movement variation
varuy=1; % y-axis vehicle movement variation
nlan=5; %number of lanes
tdelta=0.1; %time interval
velx=0; %average velocity along x-axis

numSteps = 36;
set(handles.slider1,'Value',20); %average velocity along y-axis (unit: m/s, to convert kph multiply 3.6)
set(handles.slider5,'Value',20);
set(handles.slider6,'Value',20);
set(handles.slider17,'Value',20); %Anchor
set(handles.slider1, 'Min', 0);
set(handles.slider5, 'Min', 0);
set(handles.slider6, 'Min', 0);
set(handles.slider17, 'Min', 0);
set(handles.slider1, 'Max', numSteps);
set(handles.slider5, 'Max', numSteps);
set(handles.slider6, 'Max', numSteps);
set(handles.slider17, 'Max', numSteps);
set(handles.slider1, 'SliderStep', [1/(numSteps) , 1/(numSteps-17) ]);
set(handles.slider5, 'SliderStep', [1/(numSteps) , 1/(numSteps-17) ]);
set(handles.slider6, 'SliderStep', [1/(numSteps) , 1/(numSteps-17) ]);
set(handles.slider17, 'SliderStep', [1/(numSteps) , 1/(numSteps-17) ]);
vely=get(handles.slider1,'Value');
vely2=get(handles.slider5,'value');
vely3=get(handles.slider6,'value');
vely4=get(handles.slider17,'value');

set(handles.text9, 'String', [num2str(round(3.6*vely)) 'km/h']);
set(handles.text21, 'String', [num2str(round(3.6*vely2)) 'km/h']);
set(handles.text24,'string',[num2str(round(3.6*vely3)) 'km/h']);
set(handles.text103,'string',[num2str(round(3.6*vely4)) 'km/h']);

niter=10; %number of iterations at each time instant

set(handles.text10, 'String', [num2str(0) 'm']);
set(handles.text11, 'String', [num2str(0) 's']);

set(handles.axes4,'XLim',[0 6]);
set(handles.axes4,'XTick',[1 2 3 4 5]);
set(handles.axes4,'XTickLabel',[1 2 3 4 5]);





% --- Outputs from this function are returned to the command line.
function varargout = v2x_new_decoration_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global vely

vely = round(get(hObject,'value'));
set(handles.text9,'string',[num2str(round(3.6*vely)) 'km/h'])



% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global nveh
nveh = round(get(hObject,'value'));
set(handles.text8,'string',num2str(nveh));


% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider3_Callback(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global vard
vd=get(hObject,'Value');
vard=vd^2;
set(handles.text12, 'String',[num2str(round(vd*100)/100) 'm']);



% --- Executes during object creation, after setting all properties.
function slider3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider4_Callback(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global vartheta
vt=get(hObject,'Value');
vartheta=(pi/180*vt)^2;
set(handles.text13, 'String', [num2str(round(10*vt)/10) 'deg']);


% --- Executes during object creation, after setting all properties.
function slider4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider5_Callback(hObject, eventdata, handles)
% hObject    handle to slider5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global vely2
vely2 = round(get(hObject,'value'));
set(handles.text21,'string',[num2str(round(3.6*vely2)) 'km/h'])


% --- Executes during object creation, after setting all properties.
function slider5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



% --- Executes on slider movement.
function slider6_Callback(hObject, eventdata, handles)
% hObject    handle to slider6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global vely3
vely3 = round(get(hObject,'value'));
set (handles.text24,'string',[num2str(round(3.6*vely3)) 'km/h'])


% --- Executes during object creation, after setting all properties.
function slider6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider17_Callback(hObject, eventdata, handles)
% hObject    handle to slider17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global vely4
vely4 = round(get(hObject,'value'));
set (handles.text103,'string',[num2str(round(3.6*vely4)) 'km/h'])


% --- Executes during object creation, after setting all properties.
function slider17_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end




%--------------------------- Iteration -------------------------------

% --- Executes on slider movement.
function slider18_Callback(hObject, eventdata, handles)
% hObject    handle to slider18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global niter
niter = round(get(hObject,'value'));
set(handles.text105,'string',num2str(niter));


% --- Executes during object creation, after setting all properties.
function slider18_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

%---------------------------Initial Position-------------------------------

% --- Executes on slider movement.
function slider7_Callback(hObject, eventdata, handles)
% hObject    handle to slider7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global in_vpos1
in_vpos1 = get(hObject,'Value');
set (handles.text60,'string',[num2str(round(in_vpos1)) 'm']);

% --- Executes during object creation, after setting all properties.
function slider7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider8_Callback(hObject, eventdata, handles)
% hObject    handle to slider8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global in_vpos2
in_vpos2 = get(hObject,'value');
set(handles.text62,'string',[num2str(round(in_vpos2)) 'm']);


% --- Executes during object creation, after setting all properties.
function slider8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider9_Callback(hObject, eventdata, handles)
% hObject    handle to slider9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global in_vpos6
in_vpos6 = get(hObject,'value');
set(handles.text72,'string',[num2str(round(in_vpos6)) 'm']);

% --- Executes during object creation, after setting all properties.
function slider9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider10_Callback(hObject, eventdata, handles)
% hObject    handle to slider10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global in_vpos7
in_vpos7 = get(hObject,'value');
set(handles.text74,'string',[num2str(round(in_vpos7)) 'm']);


% --- Executes during object creation, after setting all properties.
function slider10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on slider movement.
function slider11_Callback(hObject, eventdata, handles)
% hObject    handle to slider11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global in_vpos9
in_vpos9 = get(hObject,'value');
set(handles.text78,'string',[num2str(round(in_vpos9)) 'm']);

% --- Executes during object creation, after setting all properties.
function slider11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider12_Callback(hObject, eventdata, handles)
% hObject    handle to slider12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global in_vpos10
in_vpos10 = get(hObject,'value');
set(handles.text80,'string',[num2str(round(in_vpos10)) 'm']);

% --- Executes during object creation, after setting all properties.
function slider12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider13_Callback(hObject, eventdata, handles)
% hObject    handle to slider13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global in_vpos5
in_vpos5 = get(hObject,'value');
set (handles.text70,'string',[num2str(round(in_vpos5)) 'm']);

% --- Executes during object creation, after setting all properties.
function slider13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider14_Callback(hObject, eventdata, handles)
% hObject    handle to slider14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global in_vpos4
in_vpos4 = get(hObject,'value');
set (handles.text66,'string',[num2str(round(in_vpos4)) 'm']);

% --- Executes during object creation, after setting all properties.
function slider14_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider15_Callback(hObject, eventdata, handles)
% hObject    handle to slider15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global in_vpos3
in_vpos3 = get(hObject,'value');
set (handles.text64,'string',[num2str(round(in_vpos3)) 'm']);

% --- Executes during object creation, after setting all properties.
function slider15_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider16_Callback(hObject, eventdata, handles)
% hObject    handle to slider16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global in_vpos8
in_vpos8 = get(hObject,'value');
set (handles.text76,'string',[num2str(round(in_vpos8)) 'm']);

% --- Executes during object creation, after setting all properties.
function slider16_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end




% --- Executes on button press in togglebutton1.
function togglebutton1_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton1

% persistent count %local 변수지만, 함수값이 호출후에도 유지
% 
% if isempty(count) %count값이 비어있으면, 1이라한다.
%     count=1;
% end
% 
% 
% set(handles.text37,'string',floor(count));   
% count=count+0.5;









%!!!!!!!!!!!!!!!!!!!10대 한정 2/2/2/2/2코드!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!







global vard vartheta nveh vely vely2 vely3 vely4 varux varuy nlan tdelta velx niter...
    in_vpos1 in_vpos2 in_vpos3 in_vpos4 in_vpos5 in_vpos6 in_vpos7 in_vpos8 in_vpos9 in_vpos10 anchor


%set(handles.slider2,'Enable','off');

anchor=round(nveh/2);
vpos_y=[in_vpos1 in_vpos2 in_vpos3 in_vpos4 in_vpos5 in_vpos6 in_vpos7 in_vpos8 in_vpos9 in_vpos10]';
vpos_y=vpos_y+randn(nveh,1);
vpos_x=[1 1 2 2 3 3 4 4 5 5]';
vpos=[vpos_x vpos_y];

% anchor=round(nveh/2);
% vpos_y=[in_vpos1 in_vpos2 in_vpos3 in_vpos4 in_vpos5]';
% vpos_y=vpos_y+randn(nveh,1)   ;
% vpos_x=[1 2 3 4 5]';
% vpos=[vpos_x vpos_y];


 while ~isequal(sortrows(vpos),unique(vpos,'rows'))
    vpos_y=[in_vpos1 in_vpos2 in_vpos3 in_vpos4 in_vpos5 in_vpos6 in_vpos7 in_vpos8 in_vpos9 in_vpos10]'
    vpos_y=vpos_y+randn(nveh,1);
    vpos_x=[1 1 2 2 3 3 4 4 5 5]';
    vpos=[vpos_x vpos_y];
%     vpos_y=[in_vpos1 in_vpos2 in_vpos3 in_vpos4 in_vpos5]';
%     vpos_y=vpos_y+randn(nveh,1)   ;
%     vpos_x=[1 2 3 4 5]';
%     vpos=[vpos_x vpos_y];
 end


vpos=repmat([3.5 1],[size(vpos,1) 1]).*vpos;% initial positions of vehicles (3.5: width of lines in meter)


trdist=sqrt(sum((repmat(permute(vpos,[1 3 2]),[1 nveh])-repmat(permute(vpos,[3 1 2]),[nveh 1])).^2,3)); %true distance

zijn=trdist+sqrt(vard)*randn(size(trdist)); %observed distance
zijn(1:nveh+1:end)=0; %=zijn-diag(diag(zijn));

traoa=(repmat(permute(vpos,[1 3 2]),[1 nveh])-repmat(permute(vpos,[3 1 2]),[nveh 1]));
traoa=atan(traoa(:,:,2)./traoa(:,:,1))+(traoa(:,:,1)<0)*pi;
traoa(1:nveh+1:end)=0;

thetaijn=traoa+sqrt(vartheta)*randn(size(traoa));
thetaijn(1:nveh+1:end)=0;

colmap=colormap('lines');
mode1=1;


% Axes 4
vposhist(:,:,1)=vpos; % history of positions of vehicles
trdisthist(:,:,1)=trdist; % history of true distance
obdisthist(:,:,1)=zijn; % history of observed distance
traoahist(:,:,1)=traoa; % history of true aoa
obaoahist(:,:,1)=thetaijn; % history of observed aoa


%Gaussian approximation
% Line 4
fimean1=vpos+sqrt(vard)/2*randn(size(vpos)); %initial message parameter definition
belmean1=fimean1; %initial belief
belmeanhist1(:,:,1)=belmean1;


if mode1,
    %relative error
    disthist1(:,:,1)=(repmat(belmeanhist1(:,1,1),[1 nveh])-repmat(belmeanhist1(:,1,1).',[nveh 1])).^2; % 10대의 차량 x좌표 사이 거리

    disthist1(:,:,1)=sqrt(disthist1(:,:,1)+(repmat(belmeanhist1(:,2,1),[1 nveh])-repmat(belmeanhist1(:,2,1).',[nveh 1])).^2);
    %10대의 차량 (x,y) 좌표 거리 루트((x-x1).^2 +(y-y1).^2) =>(대각행렬) 중심대각선값은 당연히 0
    % 추정값

    trposhist(:,:,1)=sqrt((repmat(vposhist(:,1,1),[1 nveh])-repmat(vposhist(:,1,1).',[nveh 1])).^2 ...
    +(repmat(vposhist(:,2,1),[1 nveh])-repmat(vposhist(:,2,1).',[nveh 1])).^2);
    % disthist와 같은 원리 , trposhist는 실제 좌표로 거리차.

    relerror1(1)=mean(mean(abs(trposhist(:,:,1)-disthist1(:,:,1)),1),2);

    %absolute error
    abserror1(1)=mean(sqrt(sum((vposhist(:,:,1)-belmeanhist1(:,:,1)).^2,2)),1);
    % 좌표값으로 계산한 절대 오류 


else
    %relative error
    disthist1(:,:,1)=abs(repmat(belmeanhist1(:,1,1),[1 nveh])-repmat(belmeanhist1(:,1,1).',[nveh 1]));    
    trposhist(:,:,1)=abs(repmat(vposhist(:,1,1),[1 nveh])-repmat(vposhist(:,1,1).',[nveh 1]));


    relerror1(1)=mean(mean(abs(trposhist(:,:,1)-disthist1(:,:,1)),1),2);   

    %absolute error
    abserror1(1)=mean(abs(vposhist(:,1,1)-belmeanhist1(:,1,1)),1);    



end  
fivar1=vard*ones(size(vpos));  

belvar1=fivar1;   

belvarhist1(:,:,1)=belvar1;    






% Line 6

%time initialization
ii=0;

while get(hObject,'Value'), % && ii<ntime, % time iteration
    %get(hObject,'Value')
    ii=ii+1;
    set(handles.text11, 'String', [num2str(tdelta*ii) 's']);
    set(hObject, 'String', 'Stop');

    % For Axes 4
    % Line 8
    % factor to variable messge update (f_i --> x_{i,n})
   for j=1:nveh
       if j==round(nveh/2)
           fixinmean1(round(nveh/2),:)=belmean1(round(nveh/2),:)+[velx vely4]*tdelta;% + sqrt(0.25)*(randn(1,2));
       else    
            if vpos(j,1) < 8.5
                fixinmean1(j,:)=belmean1(j,:)+[velx vely]*tdelta; % + sqrt(0.25)*(randn(1,2));
            elseif vpos(j,1)>=8.5 && vpos(j,1)<13
                fixinmean1(j,:)=belmean1(j,:)+[velx vely3]*tdelta;% + sqrt(0.25)*(randn(1,2));              
            else
                fixinmean1=belmean1+repmat([velx vely2],[size(belmean1,1) 1])*tdelta;% + sqrt(0.25)*(randn(1,2));
            end
       end
   end
        fixinvar1=belvar1+repmat([varux varuy],[size(belvar1,1) 1]);
        intbelmean1=fixinmean1;
        intbelvar1=fixinvar1;
        xinfijmean1=intbelmean1;
        xinfijvar1=intbelvar1;
        fijxinmean1=zeros([size(zijn),2]);
        fijxinvar1=zeros([size(zijn),2]);


    % Line 9 % anchor=5
    for jj=1:niter, % cooperative positioning (intervehicular iteration)
        for kk=1:nveh,
            for ll=1:nveh,
                if kk~=ll,
                    if ll~=anchor %zijn(kk,ll)~=1,
                        if abs(zijn(kk,ll))>eps, %LOS

                            % Line 11
                            % factor to variable message update (f_{i,j} --> x_{i,n})
                            varx1=vard*cos(thetaijn(kk,ll))^2+zijn(kk,ll)^2*vartheta*sin(thetaijn(kk,ll))^2;
                            vary1=zijn(kk,ll)^2*vartheta*cos(thetaijn(kk,ll))^2+vard*sin(thetaijn(kk,ll))^2;
                            fijxinmean1(kk,ll,:)=zijn(kk,ll)*[cos(thetaijn(kk,ll)) sin(thetaijn(kk,ll))]+xinfijmean1(ll,:);
                            fijxinvar1(kk,ll,:)=xinfijvar1(ll,:)+[varx1 vary1];

                        end
                    else %if ll is a header
                        if abs(zijn(kk,ll))>eps, %LOS
                            % Line 11
                            % factor to variable message update (f_{i,j} --> x_{i,n})
                            varx1=vard*cos(thetaijn(kk,ll))^2+zijn(kk,ll)^2*vartheta*sin(thetaijn(kk,ll))^2;
                            vary1=zijn(kk,ll)^2*vartheta*cos(thetaijn(kk,ll))^2+vard*sin(thetaijn(kk,ll))^2;
                            fijxinmean1(kk,ll,:)=zijn(kk,ll)*[cos(thetaijn(kk,ll)) sin(thetaijn(kk,ll))]+vpos(ll,:);
                            fijxinvar1(kk,ll,:)=xinfijvar1(ll,:)+[varx1 vary1];

                        end
                    end
                end
            end
        end
        % Line 15

        %         intbelvar=1./(1./fixinvar+squeeze(sum(1./fijxinvar,2)));
        %         intbelmean=intbelvar.*(fixinmean./fixinvar+squeeze(sum(fijxinmean./fijxinvar,2)));
        for kk=1:nveh,
            sumfijxinvar1=[0 0];
            sumfijxinmean1=[0 0];
            for ll=1:nveh,
                if kk~=ll,
                    if abs(zijn(kk,ll))>eps,

                       sumfijxinvar1=sumfijxinvar1+squeeze(1./fijxinvar1(kk,ll,:)).';
                       sumfijxinmean1=sumfijxinmean1+squeeze(fijxinmean1(kk,ll,:)./fijxinvar1(kk,ll,:)).';

                    end
                end
            end

            intbelvar1(kk,:)=1./(1./fixinvar1(kk,:)+sumfijxinvar1);
            intbelmean1(kk,:)=intbelvar1(kk,:).*(fixinmean1(kk,:)./fixinvar1(kk,:)+sumfijxinmean1);
        end
        % Line 16
        % broadcast B


        xinfijmean1=intbelmean1;
        xinfijvar1=intbelvar1;

    end


     belmean1=intbelmean1;
     belvar1=intbelvar1;
     belmeanhist1(:,:,ii+1)=belmean1;
     belvarhist1(:,:,ii+1)=belvar1;





%627
    vposhist(:,:,ii+1)=vpos; % update true position history
    trdist=sqrt(sum((repmat(permute(vpos,[1 3 2]),[1 nveh])-repmat(permute(vpos,[3 1 2]),[nveh 1])).^2,3)); %true distance
    trdisthist(:,:,ii+1)=trdist; % history of true distance
    zijn=trdist+sqrt(vard)*randn(size(trdist)); %observed distance
    zijn=zijn-diag(diag(zijn));
    obdisthist(:,:,ii+1)=zijn;% history of observed distance
    traoa=(repmat(permute(vpos,[1 3 2]),[1 nveh])-repmat(permute(vpos,[3 1 2]),[nveh 1]));
    traoa=atan(traoa(:,:,2)./traoa(:,:,1))+(traoa(:,:,1)<0)*pi;
    traoa(1:nveh+1:end)=0;
    traoathist(:,:,ii+1)=traoa; % history of true aoa
    thetaijn=traoa+sqrt(vartheta)*randn(size(traoa));
    thetaijn(1:nveh+1:end)=0;
    obaoahist(:,:,ii+1)=thetaijn; % history of observed distance
    set(handles.text10,'String',[num2str(round(max(vpos(:,2)))) 'm']);
    for j=1:nveh
        if j==round(nveh/2)
            vpos(round(nveh/2),:)=vpos(round(nveh/2),:)+[velx vely4]*tdelta ;
        else
            if vpos(j,1) < 8.5
                vpos(j,:)=vpos(j,:)+[velx vely]*tdelta ;
            elseif vpos(j,1)>=8.5 && vpos(j,1)<13
                vpos(j,:)=vpos(j,:)+[velx vely3]*tdelta ;
            else
                vpos(j,:)=vpos(j,:)+[velx vely2]*tdelta ;
            end
        end
    end
   % vpos=vpos+repmat([velx vely],[size(vpos,1) 1])*tdelta; % update true positions



    if mode1,
        %relative error
        disthist1(:,:,ii+1)=(repmat(belmeanhist1(:,1,ii+1),[1 nveh])-repmat(belmeanhist1(:,1,ii+1).',[nveh 1])).^2;
        disthist1(:,:,ii+1)=sqrt(disthist1(:,:,ii+1)+(repmat(belmeanhist1(:,2,ii+1),[1 nveh])-repmat(belmeanhist1(:,2,ii+1).',[nveh 1])).^2);

        trposhist(:,:,ii+1)=sqrt((repmat(vposhist(:,1,ii+1),[1 nveh])-repmat(vposhist(:,1,ii+1).',[nveh 1])).^2+(repmat(vposhist(:,2,ii+1),[1 nveh])-...
                            repmat(vposhist(:,2,ii+1).',[nveh 1])).^2);
                               
        for_error=abs(trposhist(:,:,ii+1)-disthist1(:,:,ii+1))     
        for_error_agent=for_error(1,:);
        
      % for anchor and agent
        for j=2:nveh
            if j==anchor                
                for_error_anchor=for_error(anchor,:);
            else
                for_error_agent=horzcat(for_error_agent,for_error(j,:));
            end
        end
        
        relerror1_anchor(ii+1)=mean(for_error_anchor,2);
        relerror1_anchor_avg=sum(relerror1_anchor)/ii;
        
        relerror1_agent(ii+1)=mean(mean(for_error_agent,2),1);
        relerror1_agent_avg=sum(relerror1_agent)/ii;       
        
        set(handles.text91,'string',[num2str(round(relerror1_anchor_avg,3)) 'm'])
        set(handles.text94,'string',[num2str(max(round(relerror1_anchor,3))) 'm'])
        set(handles.text95,'string',[num2str(min(round(relerror1_anchor(2:ii+1),3))) 'm'])
            
        set(handles.text115,'string',[num2str(round(relerror1_agent_avg,3)) 'm'])
        set(handles.text118,'string',[num2str(max(round(relerror1_agent,3))) 'm'])
        set(handles.text119,'string',[num2str(min(round(relerror1_agent(2:ii+1),3))) 'm'])
            
            
            
       % for total error   
        relerror1(ii+1)=mean(mean(for_error,1),2);
        relerror1_avg=sum(relerror1)/ii;
        
        set(handles.text96,'String',[num2str(round(relerror1_avg,3)) 'm'])
        set(handles.text47,'string',[num2str(max(round(relerror1,3))) 'm'])
        set(handles.text48,'string',[num2str(min(round(relerror1,3))) 'm'])
        
        
        

        % absolute error

        for_abs_error=(vposhist(:,:,ii+1)-belmeanhist1(:,:,ii+1)).^2;      
 
        % for anchor and agent
        abserror1_anchor(ii+1)=(sqrt(sum(vposhist(anchor,:,ii+1)-belmeanhist1(anchor,:,ii+1)).^2));
        for_abs_error(anchor,:)=[];
        abserror1_agent(ii+1)= (sum(sqrt(sum(for_abs_error,2)),1))/(nveh-length(anchor));

        abserror1_anchor_avg=sum(abserror1_anchor)/ii;
        abserror1_agent_avg=sum(abserror1_agent)/ii;
        
        set(handles.text85,'String',[num2str(round(abserror1_anchor_avg,3)) 'm'])
        set(handles.text88,'string',[num2str(max(round(abserror1_anchor,3))) 'm'])
        set(handles.text89,'string',[num2str(min(round(abserror1_anchor(2:ii+1),3))) 'm'])  
        
        set(handles.text109,'String',[num2str(round(abserror1_agent_avg,3)) 'm'])
        set(handles.text112,'string',[num2str(max(round(abserror1_agent,3))) 'm'])
        set(handles.text113,'string',[num2str(min(round(abserror1_agent(2:ii+1),3))) 'm']) 

        %for total error
        abserror1(ii+1)=mean(sqrt(sum((vposhist(:,:,ii+1)-belmeanhist1(:,:,ii+1)).^2,2)),1);
        abserror1_avg=sum(abserror1)/ii;
        set(handles.text35,'String',[num2str(round(abserror1_avg,3)) 'm'])
        set(handles.text43,'string',[num2str(max(round(abserror1,3))) 'm'])
        set(handles.text44,'string',[num2str(min(round(abserror1,3))) 'm'])


        
        
        


    else
        %mode1 과 무엇을 다르게 두어야 하는지..*****************
        %relative error
        disthist1(:,:,ii+1)=abs(repmat(belmeanhist1(:,1,ii+1),[1 nveh])-repmat(belmeanhist1(:,1,ii+1).',[nveh 1]));
        trposhist(:,:,1)=abs(repmat(vposhist(:,1,1),[1 nveh])-repmat(vposhist(:,1,1).',[nveh 1]));
        
        for_error=abs(trposhist(:,:,ii+1)-disthist1(:,:,ii+1));     
        for_error_agent=for_error(1,:);
      % for anchor and agent
        for j=2:nveh
            if j==anchor                
                for_error_anchor=for_error(anchor,:);
            else
                for_error_agent=horzcat(for_error_agent,for_error(j,:));
            end
        end
        
        relerror1_anchor(ii+1)=mean(for_error_anchor,2);
        relerror1_anchor_avg=sum(relerror1_anchor)/ii;
        
        relerror1_agent(ii+1)=mean(mean(for_error_agent,2),1);
        relerror1_agent_avg=sum(relerror1_agent)/ii;        
        
        
        set(handles.text91,'string',[num2str(round(relerror1_anchor_avg,3)) 'm'])
        set(handles.text94,'string',[num2str(max(round(relerror1_anchor,3))) 'm'])
        set(handles.text95,'string',[num2str(min(round(relerror1_anchor(2:ii+1),3))) 'm'])
  
        
        set(handles.text115,'string',[num2str(round(relerror1_agent_avg,3)) 'm'])
        set(handles.text118,'string',[num2str(max(round(relerror1_agent,3))) 'm'])
        set(handles.text119,'string',[num2str(min(round(relerror1_agent(2:ii+1),3))) 'm'])
            
            
            
       % for total error   
        relerror1(ii+1)=mean(mean(for_error,1),2);
        relerror1_avg=sum(relerror1)/ii;
        
        set(handles.text96,'String',[num2str(round(relerror1_avg,3)) 'm'])
        set(handles.text47,'string',[num2str(max(round(relerror1,3))) 'm'])
        set(handles.text48,'string',[num2str(min(round(relerror1,3))) 'm'])
        
        
        
        
%------------------------------------------------------------------------------------------------------------
        %absolute error
        %abserror1(ii+1)=mean(abs(vposhist(:,1,ii+1)-belmeanhist1(:,1,ii+1)),1)
        %원래 위 식인데, mode 1 과 else 가 무슨차이인지 모르겠고, x축만 계산되어 있으므로 우선 mode 1 과 동일하게 둠.
        for_abs_error=(vposhist(:,:,ii+1)-belmeanhist1(:,:,ii+1)).^2;      
 
        % for anchor and agent
        abserror1_anchor(ii+1)=(sqrt(sum(vposhist(anchor,:,ii+1)-belmeanhist1(anchor,:,ii+1)).^2));
        for_abs_error(anchor,:)=[];
        abserror1_agent(ii+1)= (sum(sqrt(sum(for_abs_error,2)),1))/(nveh-length(anchor));

        abserror1_anchor_avg=sum(abserror1_anchor)/ii;
        abserror1_agent_avg=sum(abserror1_agent)/ii;
        
        set(handles.text85,'String',[num2str(round(abserror1_anchor_avg,3)) 'm'])
        set(handles.text88,'string',[num2str(max(round(abserror1_anchor,3))) 'm'])
        set(handles.text89,'string',[num2str(min(round(abserror1_anchor(2:ii+1),3))) 'm'])  
        
        set(handles.text109,'String',[num2str(round(abserror1_agent_avg,3)) 'm'])
        set(handles.text112,'string',[num2str(max(round(abserror1_agent,3))) 'm'])
        set(handles.text113,'string',[num2str(min(round(abserror1_agent(2:ii+1),3))) 'm']) 

        %for total error
        abserror1(ii+1)=mean(sqrt(sum((vposhist(:,:,ii+1)-belmeanhist1(:,:,ii+1)).^2,2)),1);
        abserror1_avg=sum(abserror1)/ii;
        set(handles.text35,'String',[num2str(round(abserror1_avg,3)) 'm'])
        set(handles.text43,'string',[num2str(max(round(abserror1,3))) 'm'])
        set(handles.text44,'string',[num2str(min(round(abserror1,3))) 'm'])

    end





%774    
   
    if ii==1,
        %axes 4
        comstr1=['gh1=plot(handles.axes4'];
        for jj=1:nveh,
            comstr1=strcat(comstr1,',squeeze(vposhist(',num2str(jj),',1,1:ii+1))/3.5,squeeze(vposhist(',num2str(jj),',2,1:ii+1)),''--'''); % 가운데 -----
        end
        for jj=1:nveh,
            if jj==anchor
                comstr1=strcat(comstr1,',squeeze(belmeanhist1(',num2str(jj),',1,1:ii+1))/3.5,squeeze(belmeanhist1(',num2str(jj),',2,1:ii+1)),''-*'''); %Anchor차량
            else
                comstr1=strcat(comstr1,',squeeze(belmeanhist1(',num2str(jj),',1,1:ii+1))/3.5,squeeze(belmeanhist1(',num2str(jj),',2,1:ii+1)),''-'''); %차량
            end
        end
        
        
        
        
        
        A=[vely,vely2,vely3,vely4]; % vely4 is anchor
        comstr1=strcat(comstr1,',[0.5 0.5]',',[0 max(vpos(:,2))+tdelta*max(A)]',',''w'''); %차선 (흰)
        for jj=1:nlan-1,
            comstr1=strcat(comstr1,',[0.5 0.5]+',num2str(jj),',[0 max(vpos(:,2))+tdelta*max(A)],''w''') ; %차선 (흰 검정:k)
        end
        comstr1=strcat(comstr1,',[0.5 0.5]+',num2str(nlan),',[0 max(vpos(:,2))+tdelta*max(A)],''w''') ; %차선 (흰)
        comstr1=strcat(comstr1,');');
        eval(comstr1);
        
        %차선 굵기 변경        
%         for jj=21:26
%                 set(gh1(jj),'linewidth',2)    
%         end
        
%         %차량 네모
%         for jj=1:2:nveh,
%             set(gh1(nveh+jj),'-s','MarkerSize',10,'MarkerEdgeColor','red''MarkerFaceColor',[1 .6 .6])             
%         end
             
        % 실제위치, 추정위치 색
        for jj=1:2:nveh,
            set(gh1(jj),'Color',colmap(jj,:));
            set(gh1(nveh+jj),'Color',colmap(jj,:));
        end
        




   %@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@     
        set(handles.axes4,'XLim',[0 6]);
        set(handles.axes4,'XTick',[1 2 3 4 5]);
        set(handles.axes4,'XTickLabel',[1 2 3 4 5]);
        set(handles.axes4,'YLim',[0 round(max(vpos(:,2)))]);%round(max(vpos(:,2)))-20
        ylabel(handles.axes4,'Mileage (meter)', 'FontSize', 8);
        xlabel(handles.axes4,[num2str(nlan) ' Lanes (lane width: 3.5 m)'], 'FontSize', 8);
        
        axes(handles.axes4);
        rectangle('position',[0 -100 35 90000000],'facecolor', [.7 .7 .7]);
        %FaceAlpha(r,.3)
        %plot(handles.axes4,[1 2 3 4 5]*3.5,inf,'--' )

        
        
% 상대오차/절대오차   
        
        %상대오류
        axes(handles.axes10);
        gh10=plot(max(A)*tdelta*[1:ii+1],relerror1(1:ii+1));    
        xlabel(handles.axes10,'dist(anchor)', 'FontSize', 8);
        ylabel(handles.axes10,'error (meter)', 'FontSize', 8);
        set(handles.axes10,'XLim',max(A)*tdelta*[1:ii+1]);
        
        %상대오류_Anchor
        axes(handles.axes12);
        gh12=plot(max(A)*tdelta*[1:ii+1],relerror1_anchor(1:ii+1));    
        xlabel(handles.axes12,'dist(anchor)', 'FontSize', 8);
        ylabel(handles.axes12,'error (meter)', 'FontSize', 8);
        set(handles.axes12,'XLim',max(A)*tdelta*[1:ii+1]);
        
        %상대오류_Agent
        axes(handles.axes14);
        gh14=plot(max(A)*tdelta*[1:ii+1],relerror1_agent(1:ii+1));    
        xlabel(handles.axes14,'dist(anchor)', 'FontSize', 8);
        ylabel(handles.axes14,'error (meter)', 'FontSize', 8);
        set(handles.axes14,'XLim',max(A)*tdelta*[1:ii+1]);


        %절대오류
        axes(handles.axes9);
        gh9=plot(max(A)*tdelta*[1:ii+1],abserror1(1:ii+1));       
        xlabel(handles.axes9,'dist(anchor)', 'FontSize', 8);      
        ylabel(handles.axes9,'error (meter)', 'FontSize', 8);       
        set(handles.axes9,'XLim',max(A)*tdelta*[1:ii+1]);
        
        
        %절대오류_Anchor
        axes(handles.axes11);
        gh11=plot(max(A)*tdelta*[1:ii+1],abserror1_anchor(1:ii+1));       
        xlabel(handles.axes11,'dist(anchor)', 'FontSize', 8);      
        ylabel(handles.axes11,'error (meter)', 'FontSize', 8);       
        set(handles.axes11,'XLim',max(A)*tdelta*[1:ii+1]);
        
        %절대오류_Anchor
        axes(handles.axes13);
        gh13=plot(max(A)*tdelta*[1:ii+1],abserror1_anchor(1:ii+1));       
        xlabel(handles.axes11,'dist(anchor)', 'FontSize', 8);      
        ylabel(handles.axes11,'error (meter)', 'FontSize', 8);       
        set(handles.axes13,'XLim',max(A)*tdelta*[1:ii+1]);

    else

        for jj=1:nveh,
            set(gh1(jj),'Xdata',squeeze(vposhist(jj,1,1:ii+1))/3.5,'Ydata',squeeze(vposhist(jj,2,1:ii+1)));
            set(gh1(nveh+jj),'Xdata',squeeze(belmeanhist1(jj,1,1:ii+1))/3.5,'Ydata',squeeze(belmeanhist1(jj,2,1:ii+1)));
        end
        for jj=0:nlan,
            set(gh1(2*nveh+jj+1),'Xdata',[0.5 0.5]+jj,'Ydata',[0 max(vpos(:,2))+tdelta*max(A)]); % vely2 를 더 높게할꺼라는 가정 하에
        end

        set(handles.axes4,'YLim',[round(min(vpos(:,2)))-50 round(max(vpos(:,2)))+20]); % 최저속도 node 와 최고속도 node 둘 다 나타나도록





%절대오류/상대오류
        %gh10=plot(handles.axes10,vely3*tdelta*[1:ii+1],relerror1(1:ii+1));       
        set(gh10,'Xdata',max(A)*tdelta*[1:ii+1],'Ydata',relerror1(1:ii+1));
        set(handles.axes10,'XLim',[0 round(max(vpos(:,2)))]);
        
        set(gh12,'Xdata',max(A)*tdelta*[1:ii+1],'Ydata',relerror1_anchor(1:ii+1));
        set(handles.axes12,'XLim',[0 round(max(vpos(:,2)))]);
        
        set(gh14,'Xdata',max(A)*tdelta*[1:ii+1],'Ydata',relerror1_agent(1:ii+1));
        set(handles.axes14,'XLim',[0 round(max(vpos(:,2)))]);
        

        %set(gh9,'Xdata',tdelta*[1:ii+1],'Ydata',abserror1(1:ii+1));
        set(gh9,'Xdata',max(A)*tdelta*[1:ii+1],'Ydata',abserror1(1:ii+1));
        set(handles.axes9,'XLim',[0 round(max(vpos(:,2)))]);
        
        set(gh11,'Xdata',max(A)*tdelta*[1:ii+1],'Ydata',abserror1_anchor(1:ii+1));
        set(handles.axes11,'XLim',[0 round(max(vpos(:,2)))]);

        set(gh13,'Xdata',max(A)*tdelta*[1:ii+1],'Ydata',abserror1_agent(1:ii+1));
        set(handles.axes13,'XLim',[0 round(max(vpos(:,2)))]);

    end
    drawnow
%     A=[];
%     d=2.5
%      for jj=1:2:nveh
%          if (belmean1(jj,1) > ((jj/2+0.5))*3.5+d) || belmean1(jj,1)< (jj/2+0.5)*3.5-d
%              set(handles.text32, 'String', [num2str(disthist1(jj,5,ii)) 'm'])
%              pause
%              A
% %              if nnz(A)<=3
% %                 A(1,ii)=disthist1(jj,5,ii)
% %              else
% %                  set(handles.text37,'String', [sum(A)/nnz(A) 'm'])
% %                  pause
% %              end
% 
%          end
%      end
% 
%      for jj=2:2:nveh
%          if (belmean1(jj,1) > (jj/2)*3.5+d) || belmean1(jj,1) < (jj/2)*3.5-d
%              set(handles.text32, 'String', [num2str(disthist1(jj,5,ii)) 'm']);
%              pause
% %              if nnz(A)<=3 
% %                 A(1,ii)=disthist1(jj,5,ii)
% %              else
% %                  set(handles.text37,'String', [sum(A)/nnz(A) 'm'])
% %                  pause
% %              end                           
%          end
%      end    

  




end
set(hObject,'string','start');
set(handles.slider2,'enable','on');

    
