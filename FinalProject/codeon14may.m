 %% Clear all
clc
close all
clear all

%% Machine learn
vid = videoinput('winvideo', 1, 'MJPG_640x360');
set(vid, 'TriggerRepeat', Inf);
vid.FrameGrabInterval = 1;
Npix_resolution = get(vid, 'VideoResolution');
Nfrm_movie = 50;
start(vid)
Iref=getdata(vid, 1); %getsnapshot
[m n]=size(Iref);
Iref=double(Iref);

abnormalCounter = 0;
for i=1:1:10
Icurrent= getdata(vid, 1); %getsnapshot
Icurrent=double(Icurrent);
%pause(0.1);
for j=1:1:m
for k=1:1:n
Iref(j,k)=double((Iref(j,k)+Icurrent(j,k))/2);
end
end
end
Iref=uint8(Iref);
figure()
imshow(Iref)
title('Machine learning output')
drawnow
%% Stopping Video Camera
%%real time capture
pause(5); 
Iprev = getdata(vid, 1);%getsnapshot
for t=1:1:100
pause(0.1);


Icurrent = getsnapshot(vid);%getsnapshot
Ihuman=Icurrent-Iref;
size(Icurrent)
size(Iref)
Ihuman=rgb2gray(Ihuman);
Ihuman=im2bw(Ihuman,0.05);
PercentIhuma=(sum(sum(double(Ihuman)))*100/(m*n));
% figure()
% imshow(Ihuman)
% title('Differance with ML image')


newBoxPolygon1 = objectdetection(Icurrent);
if (newBoxPolygon1 ~= 100)
    tts('Harmfull object found')
    web('http://localhost/FcmExample/matlab3.php');
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
      web('http://localhost/FcmExample/matlab2.php');
    end
    end
    
    
    if(PercentIdiff>17)
        abnormalCounter = abnormalCounter + 1;
        if (abnormalCounter >= 2 )
        tts('Abnormality found in ATM.');
        web('http://localhost/FcmExample/matlab1.php');
        end
        
    else
        if(PercentIdiff<3)
            Iref=updateref(Icurrent,vid);
        else
            display('Normal motion found at ATM');
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