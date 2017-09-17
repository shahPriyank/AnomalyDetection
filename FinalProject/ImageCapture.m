vid = videoinput('winvideo', 1);
set(vid, 'TriggerRepeat', Inf);
vid.FrameGrabInterval = 1;
Npix_resolution = get(vid, 'VideoResolution');
Nfrm_movie = 50;
start(vid)
Iref=getdata(vid, 1);
figure()
imshow(Iref)
imwrite(Iref,'3_2.jpg')
title('Output')
drawnow
