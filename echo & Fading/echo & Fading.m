clc ; clear all ; close all;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% echo %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% initialization
[X , fs] = audioread('Raw_file.mp3');           % reading audio file
N = 8000;                                       % initializing N(in Hand book)
amp_echo = 0.5 ;                                % initializing amp_echo(in Hand book)
lenX = length(X);                               % length of audio file 
buffer1 = zeros(1 , N );                        % buffer vector for buffering
lenbuff1 = length (buffer1);                    % length of buffer 
%%%
X_echo = zeros(1,lenX);                         % initializing X_echo which is used for output signal 
for i =1 : 1 : lenX
    index = mod(i,N);                           % it used for working with buffer
    if index == 0 
        index = N;                              % according to echo algorithm
    end
    X_echo(i) = X(i) +  amp_echo* buffer1(index) ;   
    buffer1(index) = X(i) ;                     % changing buffer elements acording to echo algorithm
end
audiowrite('eco_0.5_8000.wav', X_echo , fs);
%%%%%%%%%%%%%%%%%%%%% left/Right channel%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sound files in MATLAB have two columns such that the left column is the first channel and the right column is the second channel. 
% Channel #1 (first column) is the left channel and Channel #2 (second column) is the right channel. 
left_channel = X(: , 1) ;
right_channel = X(: , 2 );
%%%%%%%%%%%%%%%%%%%%% fading  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
N2 = 8000;                                      % reading audio file
alpha = 0.5 ;                                   % alpha is an amp_echo parameter 
lenX2 = length(X);                              % length of audio file
buffer2 = zeros(1 , N2 );                       % buffer vector for buffering
lenbuff2 = length (buffer2);                    % length of buffer 
X_fading = zeros(1,lenX2);                      % initializing X_echo which is used for output signal
for i =1 : 1 : lenX2
    index_main = mod(i,N2);                     % it used for working with buffer
    if index_main == 0 
        index_main = N2;
    end
    if index_main == 1                          % according to fading algorithm
        index_main2 = N2;
    else
        index_main2 = index_main - 1 ;
    end
    X_fading(i) = X(i)+ (alpha * buffer2(index_main));
    buffer2(index_main2) = X(i)+ (alpha * buffer2(index_main));  % changing buffer elements acording to fading algorithm
    buffer2(index_main) = X(i) ;                                 % changing buffer elements acording to fading algorithm
    
end
audiowrite('fading_0.5_8000.wav', X_fading , fs);
%%%%%%%%%%%%%%% interrupted echo   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% for interrupting
lenX3 = length(X);
start_pnt = (lenX3+1)/2 ;                                       % start point for changing to 0 
X_stop = X ;                                                     % try to make intruppted sound
for i = start_pnt : 1 : lenX3
    X_stop(i) = 0 ; 
end
%%%%%%%%%
amp_echo3 = 1 ;
N3 = 8000 ;
buffer3 = zeros(1 , N3 );
X_echo3 = zeros(1,lenX3);                         % initializing X_echo which is used for output signal 
for i =1 : 1 : lenX3
    index3 = mod(i,N3);                           % it used for working with buffers
    if index3 == 0 
        index3 = N3;
    end
    X_echo3(i) = X_stop(i) +  amp_echo3* buffer3(index3) ;   
    buffer3(index3) = X_stop(i) ;                     % changing buffer elements acording to echo algorithm
end
audiowrite('interrupt_echo_1_8000.wav', X_echo3 , fs);
%%%%%%%%%%%%%%%%%%%%%%%%%  interupted Fading  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
lenX4 = length(X);
start_pnt = (lenX4+1)/2 ; 
X_stop4 = X ;  
for i = start_pnt : 1 : lenX4
     X_stop4(i , :) = 0 ; 
 end
%%%%%%
N4 = 8000;                                      % reading audio file
alpha4 = 0.5 ;                                   % alpha is an amp_echo parameter 
lenX4 = length(X);                              % length of audio file
buffer4 = zeros(1 , N4 );                       % buffer vector for buffering
lenbuff4 = length (buffer4);                    % length of buffer 
X_fading4 = zeros(1,lenX4);                      % initializing X_echo which is used for output signal
for i =1 : 1 : lenX4
    index_main4_1 = mod(i,N4); 
    if index_main4_1 == 0 
        index_main4_1 = N4;
    end
    if index_main4_1 == 1 
        index_main4_2 = N4;
    else
        index_main4_2 = index_main4_1 - 1 ;
    end
    X_fading4(i) = X_stop4(i)+ (alpha4 * buffer4(index_main4_1));
    buffer4(index_main4_2) = X_stop4(i)+ (alpha4 * buffer4(index_main4_1));  % changing buffer elements acording to fading algorithm
    buffer4(index_main4_1) = X_stop4(i) ;                                 % changing buffer elements acording to fading algorithm
    
end
audiowrite('interrupt_fading_0.5_8000.wav', X_fading4 , fs);




