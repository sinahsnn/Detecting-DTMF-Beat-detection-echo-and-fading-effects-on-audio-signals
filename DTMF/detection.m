%%%%%%%%%%%%%%%%%%%%%%%%%%%%% DTMF Detection  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
clc ; clear all ; close all ; 
%% 1 : producing all 12 signals 
Tt = 1 ;                        % desired total time
fs = 8000 ;                     % sampling frequency 
num_one = signal_generator( Tt , fs ,  697 , 1209 ) ;  % DTMF of number 1
num_two = signal_generator( Tt , fs ,  697 , 1336 );   % DTMF of number 2
num_three = signal_generator( Tt , fs ,  697 ,1477 );  % DTMF of number 3
num_four = signal_generator( Tt , fs ,  770 , 1209 ) ; % DTMF of number 4
num_five = signal_generator( Tt , fs ,  770 , 1336 ) ; % DTMF of number 5
num_six =  signal_generator( Tt , fs ,  770 , 1477 ) ; % DTMF of number 6
num_seven = signal_generator( Tt , fs ,  852 , 1209 ) ;% DTMF of number 7
num_eight = signal_generator( Tt , fs ,  852 , 1336 ) ;% DTMF of number 8
num_nine =  signal_generator( Tt , fs ,  852 , 1477 ) ;% DTMF of number 9
num_star = signal_generator( Tt , fs ,  941 , 1209 ) ; % DTMF of * button
num_zero = signal_generator( Tt , fs ,  941 , 1336 ) ; % DTMF of number 0
num_hash = signal_generator( Tt , fs ,  941 , 1477 ) ; % DTMF of # botton
%% 2 : step 1 : calculating corellation between input signal and sin(2pifit),cos(2pif1t)
N = 250 ; 
DTMF = num_hash;                            % initializing the input signal 
% now lets to start to identify this signal 
% W for row frequencies for sin & cos according to lab instruction 
W697_sin = calculate_corr (Tt , fs, DTMF , 'sin' , 697 , N ) ; 
W697_cos = calculate_corr (Tt , fs, DTMF , 'cos' , 697 , N ) ; 
%
W770_sin = calculate_corr (Tt , fs, DTMF , 'sin' , 770 , N ) ; 
W770_cos = calculate_corr (Tt , fs, DTMF , 'cos' , 770 , N ) ; 
%
W852_sin = calculate_corr (Tt , fs, DTMF , 'sin' , 852 , N ) ; 
W852_cos = calculate_corr (Tt , fs, DTMF , 'cos' , 852 , N ) ; 
%
W941_sin = calculate_corr (Tt , fs, DTMF , 'sin' , 941 , N ) ; 
W941_cos = calculate_corr (Tt , fs, DTMF , 'cos' , 941 , N ) ;

% W for coloumn frequencies for sin & cos according to lab instruction
W1209_sin = calculate_corr (Tt , fs, DTMF , 'sin' , 1209 , N ) ; 
W1209_cos = calculate_corr (Tt , fs, DTMF , 'cos' , 1209 , N ) ; 

W1336_sin = calculate_corr (Tt , fs, DTMF , 'sin' , 1336 , N ) ; 
W1336_cos = calculate_corr (Tt , fs, DTMF , 'cos' , 1336 , N ) ; 

W1477_sin = calculate_corr (Tt , fs, DTMF , 'sin' , 1477 , N ) ; 
W1477_cos = calculate_corr (Tt , fs, DTMF , 'cos' , 1477 , N ) ; 

%% step 2 : max of W_sin & W_cos
W697 = max( abs(W697_sin) , abs(W697_cos) ) ;       % max for 697 Hz
W770 = max( abs(W770_sin) , abs(W770_cos) ) ;       % max for 770 Hz 
W852 = max( abs(W852_sin) , abs(W852_cos) ) ;       % max for 852 Hz 
W941 = max( abs(W941_sin) , abs(W941_cos) ) ;       % max for 941 Hz 
W1209 = max(abs(W1209_sin), abs(W1209_cos)) ;       % max for 1209 Hz 
W1336 = max( abs(W1336_sin) , abs(W1336_cos) ) ;    % max for 1336 Hz  
W1477 = max( abs(W1477_sin) , abs(W1477_cos) ) ;    % max for 1477 Hz 
%% step 3 : calculate maximum of rows and maximum of coloumns
W_rows = [ W697 , W770 , W852 , W941] ;       % making array with W of rows 
W_coloumns = [ W1209 , W1336 , W1477 ];       % making aarya with W of colomns
[max_rows , max_rows_indx] = max( W_rows(:) ) ;  % calculate max and indicies of max for W rows 
[max_coloumns , max_coloumn_indx ] = max( W_coloumns(:) ) ; % calculate max and indicies of max for W colomns 
%% step 4 : concluding that which buttom was pressed 
threshold = 100 ; 
% making matrix of bottons for identifying that which botton was pressed 
buttons = [ '1' , '2' , '3' ; '4' , '5' , '6' ; '7' , '8' , '9' ; '*' , '0' , '#'];
a = buttons( max_rows_indx , max_coloumn_indx ) ; % identifying botton
if ((max_rows > threshold) && ( max_coloumns > threshold)) % checking with threshold
    fprintf('the number that was pressed is :\t%s\n ', a ) ;
    % checking for binary numbers according to lab instruction
    if max_rows_indx == 1 
        switch max_coloumn_indx
            case 1
                s='0001';
            case 2
                s='0010';
            case 3
                s='0011';
        end
    end
    if max_rows_indx == 2
        switch max_coloumn_indx
            case 1
                s='0100';
            case 2
                s='0101';
            case 3
                s='0110';
        end
    end
    if max_rows_indx == 3 
        switch max_coloumn_indx
            case 1
                s='0111';
            case 2
                s='1000';
            case 3
                s='1001';
        end
    end
    if max_rows_indx == 4 
        switch max_coloumn_indx
            case 1
                s='1010';
            case 2
                s='1011';
            case 3
                s='1100';
        end
    end
    fprintf('the code of the number is :\t %s \n ',s ) ;
else
    fprintf('no botton was pressed !' ) ;     % if threshold is more than condition numbers 
end 

%% func for generating signal 
function y = signal_generator( Tt , fs , f_row , f_coloumn )
% Tt :    desired total time
% fs :    sampling frequency 
% f_row : frequency of the row
% f_coloumn : frequency of the coloumn
tn = 0 : 1/fs : (Tt-(1/fs)) ;                                   % tn vector 
y = sin(2 * pi * f_row * tn) + sin(2 * pi * f_coloumn * tn) ;   % output  
end
%% func for calculating correlation 
function W = calculate_corr (Tt , fs, y , name , frequency , N )
% Tt :       desired total time
% fs :       sampling frequency 
% name :     determines if we want to use sin or cos
% fequency : determine the sin or cos singnal frequency
% N  :     : N is related to buffer      
tn = 0 : 1/fs : (Tt-(1/fs)) ;                 % tn vector
% checking name to determin that which type of signal(sin or cos) we want.
if ( name == 'sin')
    x = sin(2 * pi * frequency * tn) ; 
else
    x = cos(2 * pi * frequency * tn) ; 
end
result = 0 ;
% now clculate the correlation which was introduce in Lab instruction 
for i =1:1:N 
    result = result + x(i)*y(i);
end
W = result ;          % output of the function  
end