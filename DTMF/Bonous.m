%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% BONOUS PART %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc ; clear all ; close all ;
final_result = [] ;                % it is the output that we want to plot at last
Tt =1 ;                                           % Desired time
[X , fs] = audioread('DTMF_short.wav');           % reading audio file
N = 100 ;                                        % related to buffer 
lenX = length(X);                                 % length of audio file 
buffer1 = zeros(1,N);                             % buffer 
lenbuffer1 =length (buffer1);                     % length of the buffer 
sound(X)                                         
for i = 1 : 1 : lenX
    % index is a kind of pointer for buffer indicies 
    index = mod(i,N) ;
    if index == 0 
        index = N ;
    end
    buffer1(index) = X(i);
    if index == N                   % checking if the buffer is full or not 
        %% starting the algorithm that was introduced in the last part 
        %%% step 1 
        %N = 2000 ;
        % W for row frequency
        DTMF = buffer1;
        W697_sin = calculate_corr (Tt , fs, DTMF , 'sin' , 697 , N ) ; 
        W697_cos = calculate_corr (Tt , fs, DTMF , 'cos' , 697 , N ) ; 
        %
        W770_sin = calculate_corr (Tt , fs, DTMF , 'sin' , 770 , N ) ; 
        W770_cos = calculate_corr (Tt , fs, DTMF , 'cos' , 770 , N ) ; 
        %
        W852_sin = calculate_corr (Tt , fs, DTMF , 'sin' , 853 , N ) ; 
        W852_cos = calculate_corr (Tt , fs, DTMF , 'cos' , 852 , N ) ; 
        %
        W941_sin = calculate_corr (Tt , fs, DTMF , 'sin' , 941 , N ) ; 
        W941_cos = calculate_corr (Tt , fs, DTMF , 'cos' , 941 , N ) ; 
        % W for coloumn frequency
        W1209_sin = calculate_corr (Tt , fs, DTMF , 'sin' , 1209 , N ) ; 
        W1209_cos = calculate_corr (Tt , fs, DTMF , 'cos' , 1209 , N ) ; 

        W1336_sin = calculate_corr (Tt , fs, DTMF , 'sin' , 1336 , N ) ; 
        W1336_cos = calculate_corr (Tt , fs, DTMF , 'cos' , 1336 , N ) ; 

        W1477_sin = calculate_corr (Tt , fs, DTMF , 'sin' , 1477 , N ) ; 
        W1477_cos = calculate_corr (Tt , fs, DTMF , 'cos' , 1477 , N ) ; 
        
        %%% step 2 
        W697 = max( abs(W697_sin) , abs(W697_cos) ) ; 
        W770 = max( abs(W770_sin) , abs(W770_cos) ) ; 
        W852 = max( abs(W852_sin) , abs(W852_cos) ) ; 
        W941 = max( abs(W941_sin) , abs(W941_cos) ) ; 
        W1209 = max(abs(W1209_sin), abs(W1209_cos)) ; 
        W1336 = max( abs(W1336_sin) , abs(W1336_cos) ) ; 
        W1477 = max( abs(W1477_sin) , abs(W1477_cos) ) ; 
        %%% step 3
        %% step 3 : calculate maximum of rows and maximum of coloumns
        W_rows = [ W697 , W770 , W852 , W941] ; 
        W_coloumns = [ W1209 , W1336 , W1477 ];
        [max_rows , max_rows_indx] = max( W_rows(:) ) ;
        [max_coloumns , max_coloumn_indx ] = max( W_coloumns(:) ) ;
%% step 4 : concluding that which buttom was pressed 
        threshold = 13.5 ; 
        buttons = [ 1 , 2 , 3 ; 4 , 5 , 6 ; 7 , 8 , 9 ; 10 , 0 , 12];   % 10 for * & 12 for #
        a = buttons( max_rows_indx , max_coloumn_indx ) ;
        if ((max_rows > threshold) && ( max_coloumns > threshold))
            final_result = [ final_result , a ] ;
        else
            final_result = [ final_result , -1] ;
        end
        buffer1 = zeros(1,N);
    end 
end
%% finishing the algorithm that was introduced in part 1 
plot(final_result)
grid on
title ( " bottons that was pressed  with N =100 and threshold = 13.5 " ) 
ylabel( " bottons " ) 
%%%%
%% func for calculating correlation 
function W = calculate_corr (Tt , fs, y , name , frequency , N )
tn = 0 : 1/fs : (Tt-(1/fs)) ;                 % tn vector 
if ( name == 'sin')
    x = sin(2 * pi * frequency * tn) ; 
else
    x = cos(2 * pi * frequency * tn) ; 
end
result = 0 ;
for i =1:1:N 
    result = result + x(i)*y(i);
end
W = result ;    
end