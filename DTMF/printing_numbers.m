%%%%%%%%%%%%%%%%%%  DTMF and printing the numbers %%%%%%%%%%
%%
clc ; clear all ; close all ;
%%
Tt = 1 ; 
fs = 8000 ;
N = 100 ; 
for f1 = [697 770 852 941]
    for f2 = [1209 1336 1477]
        DTMF = signal_generator( Tt , fs , f1 , f2 );
        soundsc(DTMF, fs);
        %% starting the detection algorithm that was introduced in the part before
        % W for row frquencies 
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
        % W for coloumn frequency
        W1209_sin = calculate_corr (Tt , fs, DTMF , 'sin' , 1209 , N ) ; 
        W1209_cos = calculate_corr (Tt , fs, DTMF , 'cos' , 1209 , N ) ; 

        W1336_sin = calculate_corr (Tt , fs, DTMF , 'sin' , 1336 , N ) ; 
        W1336_cos = calculate_corr (Tt , fs, DTMF , 'cos' , 1336 , N ) ; 

        W1477_sin = calculate_corr (Tt , fs, DTMF , 'sin' , 1477 , N ) ; 
        W1477_cos = calculate_corr (Tt , fs, DTMF , 'cos' , 1477 , N ) ; 
        
        % step 2 : max of W_sin & W_cos
        W697 = max( abs(W697_sin) , abs(W697_cos) ) ; 
        W770 = max( abs(W770_sin) , abs(W770_cos) ) ; 
        W852 = max( abs(W852_sin) , abs(W852_cos) ) ; 
        W941 = max( abs(W941_sin) , abs(W941_cos) ) ; 
        W1209 = max(abs(W1209_sin), abs(W1209_cos)) ; 
        W1336 = max( abs(W1336_sin) , abs(W1336_cos) ) ; 
        W1477 = max( abs(W1477_sin) , abs(W1477_cos) ) ; 
        % step 3 : calculate maximum of rows and maximum of coloumns
        W_rows = [ W697 , W770 , W852 , W941] ; 
        W_coloumns = [ W1209 , W1336 , W1477 ];
        [max_rows , max_rows_indx] = max( W_rows(:) ) ;
        [max_coloumns , max_coloumn_indx ] = max( W_coloumns(:) ) ;
        %% step 4 : concluding that which buttom was pressed 
        threshold = 25 ; 
        buttons = [ '1' , '2' , '3' ; '4' , '5' , '6' ; '7' , '8' , '9' ; '*' , '0' , '#'];
        a = buttons( max_rows_indx , max_coloumn_indx ) ;
        if ((max_rows > threshold) && ( max_coloumns > threshold))
            fprintf('the number that was pressed is :\t%s\n ', a ) ;
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
            fprintf('no botton was pressed !\n' ) ;
        end 
        % finishing the detection algorithm that was introduced in last part   
        pause(2.5)
    end
end
%% func for generating signal 
function y = signal_generator( Tt , fs , f_row , f_coloumn )
% Tt :    desired total time
% fs :    sample frequency 
% f_row : frequency of the row
% f_coloumn : frequency of the coloumn
tn = 0 : 1/fs : (Tt-(1/fs)) ;  % tn vector 
y = sin(2 * pi * f_row * tn) + sin(2 * pi * f_coloumn * tn) ; 
end
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