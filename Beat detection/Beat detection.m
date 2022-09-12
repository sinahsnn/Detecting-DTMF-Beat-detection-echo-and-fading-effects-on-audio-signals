%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Beat detection %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc ; clear all ; close all;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
Tt1 = 20 ;                          % desired total time
fs1 = 8000 ;                        % sampling frequency 
tn1 = 0 : 1/fs1 : (Tt1-(1/fs1)) ;   % t1 vector
f1 = 650 ;                          % initialize f1
y1 = sin(2 * pi * f1 * tn1);        % y1 vector
Tt2 =1/8;                           % desired total time
fs2 = 8000;                         % sampling frequency
tn2 = 0 : 1/fs2 : (Tt2-(1/fs2)) ;   % t2 vector
f2 = 2000 ;                         % initialize f2
y2 = 20 * sin(2 * pi * f2 * tn2);   % y2 vector
%
for i = 5000 : 10000 : length(tn1)
    y1(i+1:i+length(tn2)) =y2 ;
end
figure(1);
plot(tn1 , y1)
xlabel("t");
ylabel("amplitude");
title("beat included signal")
%%%%%%%%%%%%%%%%%%%%%%%%%%% 
Buffer_length= 2000;                       % buffer length
chunk_length = 100 ;                        % chunk_length
num_chunk = Buffer_length / chunk_length;   % number of chunks
chunk1 = zeros(1,chunk_length);             % chunk
C = 1.8 ;                                   % Coefficient of sensivity
buffer1 = zeros(1,Buffer_length);           % buffer
bufferlen = length(buffer1);                % buffer length
X = y1;                                     % signal
lenX = length(X);                           % length of the signal
beat_detectionarr = zeros(1,lenX/chunk_length); % for beat detection in X
%%% starting algorythm
buffer_counter = 0 ; 
beat_detection_counter=1;
for i =1 : 1 : lenX
    % index is a kind of pointer for buffer indicies 
    index = mod(i,Buffer_length) ;
    if index == 0 
        index = Buffer_length ;
    end
    buffer1(index) = X(i);
    if index == Buffer_length                           % checking if the buffer is full or not
        buffer_counter=buffer_counter+1;
        E_buffer = sum((buffer1.*buffer1))/bufferlen ;    % power of the buffer
        for j = 1:1:num_chunk
            chunk1 = buffer1((j-1)*chunk_length+1: j*chunk_length);
            e_chunk = sum( (chunk1.*chunk1))/chunk_length;  % power of the chunk
            if e_chunk >= E_buffer*C
                fprintf('there is a beat in buffer %d and chunk %d between sample (%d , %d)  \n ',buffer_counter,j,(i-bufferlen)+(j-1)*chunk_length,(i-bufferlen)+(j)*chunk_length-1) ;
                beat_detectionarr(beat_detection_counter) = 1 ; 
                beat_detection_counter = beat_detection_counter+1;
            else
                beat_detectionarr(beat_detection_counter) = 0 ; 
                beat_detection_counter = beat_detection_counter+1;
            end
        end
    end    
end
% plotting beat detection array
figure(2)
stem(beat_detectionarr)
xlabel('chunk')
ylabel('y')
title( ' Beat in chunk with C=1.8 & Buffer_length=2000 ' )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% question 5 
%%
clc , clear all ; close all 
fs = 8000 ;
[beat_music , fs_music] = audioread('epic.mp3');
X2 = beat_music(:,2);
[P, Q] = rat(fs/fs_music);
X2_resampled = resample(X2, P, Q);
%sound(X2_resampled)
Buffer_length2= 4000;                       % buffer length
chunk_length2 = 100 ;                        % chunk_length
num_chunk2 = Buffer_length2 / chunk_length2;   % number of chunks
chunk2 = zeros(1,chunk_length2);             % chunk
C2 = 2 ;                                   % Coefficient of sensivity
buffer2 = zeros(1,Buffer_length2);           % buffer
bufferlen2 = length(buffer2);                % buffer length
X2 = X2_resampled(1:1:80000);                                     % signal
lenX2 = length(X2);                           % length of the signal
E_X2 = sum((X2.*X2))/lenX2 ;
beat_detectionarr2 = zeros(1,lenX2/chunk_length2); % for beat detection in X
%%% starting algorythm
buffer_counter2 = 0 ; 
beat_detection_counter2=1;
for i =1 : 1 : lenX2
    % index is a kind of pointer for buffer indicies 
    index2 = mod(i,Buffer_length2) ;
    if index2 == 0 
        index2 = Buffer_length2 ;
    end
    buffer2(index2) = X2(i);
    if index2 == Buffer_length2                           % checking if the buffer is full or not
        buffer_counter2=buffer_counter2+1;
        E_buffer2 = sum((buffer2.*buffer2))/bufferlen2 ;    % power of the buffer
        for j = 1:1:num_chunk2
            chunk2 = buffer2((j-1)*chunk_length2+1: j*chunk_length2);
            e_chunk2 = sum( (chunk2.*chunk2))/chunk_length2;
            if e_chunk2 >= E_buffer2*C2
                %fprintf('there is a beat in buffer %d and chunk %d between sample (%d , %d)  \n ',buffer_counter,j,(i-bufferlen)+(j-1)*chunk_length,(i-bufferlen)+(j)*chunk_length-1) ;
                beat_detectionarr2(beat_detection_counter2) = 1 ; 
                beat_detection_counter2 = beat_detection_counter2+1;
            else
                beat_detectionarr2(beat_detection_counter2) = 0 ; 
                beat_detection_counter2 = beat_detection_counter2+1;
            end
        end
    end 
    %buffer2 = zeros(1,Buffer_length2);
end
beat1= zeros(1,lenX2);
beat2= zeros(1,lenX2);
for i = 1 : 1 : length(beat_detectionarr2)
    if beat_detectionarr2(i)==1
        beat1((i-1)*chunk_length2+1 :1:i*chunk_length2) =1;
        beat2((i-1)*chunk_length2+1 :1:i*chunk_length2) =-1;
    end
end
figure(3)
xlabel('chunk')
ylabel('y')
title( ' Beat in chunk ' )
plot(X2,'r')
hold on
stem(beat1,'k')
hold on 
stem(beat2,'k')
title( "with C=2 & buffer_length=4000 & chunk_length = 100") 
%sound(X2)
figure(4)
stem(beat_detectionarr2)
xlabel('chunk')
ylabel('y')
title( ' Beat in chunks ' )


