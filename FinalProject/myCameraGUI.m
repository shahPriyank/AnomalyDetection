function varargout = myCameraGUI(varargin)
% MYCAMERAGUI MATLAB code for mycameragui.fig
%      MYCAMERAGUI, by itself, creates a new MYCAMERAGUI or raises the existing
%      singleton*.
%
%      H = MYCAMERAGUI returns the handle to a new MYCAMERAGUI or the handle to
%      the existing singleton*.
%
%      MYCAMERAGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MYCAMERAGUI.M with the given input arguments.
%
%      MYCAMERAGUI('Property','Value',...) creates a new MYCAMERAGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before myCameraGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to myCameraGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help mycameragui

% Last Modified by GUIDE v2.5 17-May-2017 22:12:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @myCameraGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @myCameraGUI_OutputFcn, ...
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


% --- Executes just before mycameragui is made visible.
function myCameraGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to mycameragui (see VARARGIN)

% Choose default command line output for mycameragui
handles.output = hObject;

% Create video object
% Putting the object into manual trigger mode and then
% starting the object will make GETSNAPSHOT return faster
% since the connection to the camera will already have
% been established.
handles.video = videoinput('winvideo', 1,'MJPG_640x360');
set(handles.video,'TimerPeriod', 0.05, ...
'TimerFcn',['if(~isempty(gco)),'...
'handles=guidata(gcf);'... % Update handles
'image(getsnapshot(handles.video));'... % Get picture using GETSNAPSHOT and put it into axes using IMAGE
'set(handles.cameraAxes,''ytick'',[],''xtick'',[]),'... % Remove tickmarks and labels that are inserted when using IMAGE
'else '...
'delete(imaqfind);'... % Clean up - delete any image acquisition objects
'end']);
triggerconfig(handles.video,'manual');
handles.video.FramesPerTrigger = Inf; % Capture frames until we manually stop it

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes mycameragui wait for user response (see UIRESUME)
uiwait(handles.myCameraGUI);


% --- Outputs from this function are returned to the command line.
function varargout = myCameraGUI_OutputFcn(hObject, eventdata, handles)
% varargout cell array for returning output args (see VARARGOUT);
% hObject handle to figure
% eventdata reserved - to be defined in a future version of MATLAB
% handles structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
handles.output = hObject;
varargout{1} = handles.output;


% --- Executes on button press in startStopCamera.
function startStopCamera_Callback(hObject, eventdata, handles)
% hObject handle to startStopCamera (see GCBO)
% eventdata reserved - to be defined in a future version of MATLAB
% handles structure with handles and user data (see GUIDATA)

% Start/Stop Camera
if strcmp(get(handles.startStopCamera,'String'),'Start Camera')
    % Camera is off. Change button string and start camera.
    set(handles.startStopCamera,'String','Stop Camera')
    start(handles.video)
%     set(handles.startAcquisition,'Enable','on');
%     set(handles.captureImage,'Enable','on');
%     codeon14may();


%% Machine learn
% 
% set(handles.video, 'TriggerRepeat', Inf);
% handles.video.FrameGrabInterval = 1;
% Npix_resolution = get(handles.video, 'VideoResolution');
% Nfrm_movie = 50;
% start(handles.video)
% while get(handles.video,'FramesAvailable')<1
% 
% end


%
%
%CODE!14
%
%



nTimes = 3;         % Number of times to blink
pauseTime = 0.05;    % Pause time
tag = 'text1';
% vid = videoinput('winvideo', 1, 'MJPG_640x360');
% set(vid, 'TriggerRepeat', Inf);
% vid.FrameGrabInterval = 1;
% Npix_resolution = get(vid, 'VideoResolution');
% Nfrm_movie = 50;
% start(vid)
Iref=get(get(handles.cameraAxes,'children'),'cdata');  %getsnapshot
[m n]=size(Iref);
Iref=double(Iref);

abnormalCounter = 0;
for i=1:1:10
Icurrent= get(get(handles.cameraAxes,'children'),'cdata');  %getsnapshot
Icurrent=double(Icurrent);
%pause(0.1);
for j=1:1:m
for k=1:1:n
Iref(j,k)=double((Iref(j,k)+Icurrent(j,k))/2);
end
end
end

Iref=uint8(Iref);

% figure()
% imshow(Iref)
% title('Machine learning output')
% drawnow
%% Stopping Video Camera
%%real time capture
BLINK_TEXT(handles,tag,pauseTime,nTimes,'Ready');
pause(5); 

Iprev = get(get(handles.cameraAxes,'children'),'cdata'); 
for t=1:1:100
pause(0.1);
Icurrent = get(get(handles.cameraAxes,'children'),'cdata');%getsnapshot
size(Icurrent)
size(Iref)
Ihuman=Icurrent-Iref;
Ihuman=rgb2gray(Ihuman);
Ihuman=im2bw(Ihuman,0.05);
PercentIhuma=(sum(sum(double(Ihuman)))*100/(m*n));
% figure()
% imshow(Ihuman)
% title('Differance with ML image')


newBoxPolygon1 = objectdetection(Icurrent);
if (newBoxPolygon1 ~= 100)
    tts('Harmfull object found')
    flag = PercentIhuma; 
end


Idiff=Icurrent-Iprev;
Idiff=rgb2gray(Idiff);
Idiff=im2bw(Idiff,0.05);
PercentIdiff=(sum(sum(double(Idiff)))*100/(m*n));
% figure()
% imshow(Idiff)
% title('Motion in ATM')

% if( t >= 10)
PercentIhuma
PercentIdiff

if(PercentIhuma>9)
    [out bin] = generate_skinmap(Icurrent);
    binskin=im2bw(bin);
    [m n]=size(binskin);
    Percentbinskin=(sum(sum(double(binskin)))*100/(m*n))*3
    
    
    % newBoxPolygon1 = objectdetection(Icurrent);
    % if (newBoxPolygon1 ~= 0)
    %     tts('Harmfull object found')
    % end
    
    if(Percentbinskin<3)
    if(abs(PercentIhuma-flag) > 20)     
      tts('Person with mask found.'); 
      BLINK_TEXT(handles,tag,pauseTime,nTimes,'Person with mask found.');
    end
    end
    
    
    if(PercentIdiff>17)
        abnormalCounter = abnormalCounter + 1;
        if (abnormalCounter >= 2 )
        tts('Abnormality found in ATM.');
        BLINK_TEXT(handles,tag,pauseTime,nTimes,'Abnormal');
        end
        
    else
        if(PercentIdiff<3)
            Iref=updateref(Icurrent,vid);
        else
            display('Normal motion found at ATM');
            BLINK_TEXT(handles,tag,pauseTime,nTimes,'Normal');
        end
        abnormalCounter = 0;
    end
    
    
 end
% end

%skin tone detection code
%object detection

flag = PercentIhuma
Iprev=Icurrent;
end
flushdata(vid);
stop(vid)
delete(vid)


%
%
%//END OF CODE14
%
%


    
else
    % Camera is on. Stop camera and change button string.
    set(handles.startStopCamera,'String','Start Camera')
    stop(handles.video)
   
end

% % --- Executes on button press in captureImage.
% function captureImage_Callback(hObject, eventdata, handles)
% % hObject    handle to captureImage (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% % frame = getsnapshot(handles.video);
% frame = get(get(handles.cameraAxes,'children'),'cdata'); % The current displayed frame
% save('testframe.mat', 'frame');
% disp('Frame saved to file ''testframe.mat''');


% --- Executes on button press in startAcquisition.
% function startAcquisition_Callback(hObject, eventdata, handles)
% % hObject    handle to startAcquisition (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% % Start/Stop acquisition
% if strcmp(get(handles.startAcquisition,'String'),'Start Acquisition')
%     % Camera is not acquiring. Change button string and start acquisition.
%     set(handles.startAcquisition,'String','Stop Acquisition');
%     trigger(handles.video);
% else
%     % Camera is acquiring. Stop acquisition, save video data,
%     % and change button string.
%     stop(handles.video);
%     disp('Saving captured video...');
%     
%     videodata = getdata(handles.video);
%     save('testvideo.mat', 'videodata');
%     disp('Video saved to file ''testvideo.mat''');
%     
%     start(handles.video); % Restart the camera
%     set(handles.startAcquisition,'String','Start Acquisition');
% end

% --- Executes when user attempts to close myCameraGUI.
function [] = BLINK_TEXT(handles,tag,pauseTime,nTimes,text)
% Set the text color to red
set(eval(strcat('handles.',tag)),'ForegroundColor',[1 0 0]);

% Initial message
set(eval(strcat('handles.',tag)),'String',text);
drawnow();

% Loop through for the number of times to blink
for i = 1:1:nTimes
    set(eval(strcat('handles.',tag)),'String','');
    drawnow();
    pause(pauseTime);

    set(eval(strcat('handles.',tag)),'String',text);
    drawnow();
    pause(pauseTime);
end



function myCameraGUI_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to myCameraGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject);
delete(imaqfind);
