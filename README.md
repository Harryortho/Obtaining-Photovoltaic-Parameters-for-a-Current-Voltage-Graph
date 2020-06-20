# Obtaining-Photovoltaic-Parameters-for-a-Current-Voltage-Graph

You need to have Octave which is a free to download matlab type software to run the file which can be found here: https://www.gnu.org/software/octave/

The file that you need to run is this: 
xtilde_yHat_All_Functions_V2lessComments.m
I have other versions but this one might be the tidiest to understand the code.

My data tries to scan the data from an IV-curve but is unsuccessful, I learnt a lot through it, you need to identify points on a graph through the octave editor with the graphs provided, basically it tries to read a file to get 2 parameters of input for current and voltage. I can't upload them because it might be confidential so maybe try to create your own current voltage graphs and adjust the read in file accordingly. I have to create a better user interface but no longer am working on this project. I might try and do it in another way in the future.

Even though it did not work, 
Thanks to  
%I may have forgotten, there are many others who have helped with this
%code, so please remind me so that I can add you to the list 
%Dr Vasilios Constantoudis, Dr Loukas Peristeras, Dr Evangelos Evangelou
%Professor L.H.I Lim, Michael Markoulides, Dr Jaw, Dr Vasilios Raptis
Eli Billauer, 3.4.05 (Explicitly not copyrighted).
%PEAKDET Detect peaks in a vector
%        [MAXTAB, MINTAB] = PEAKDET(V, DELTA) finds the local
%        maxima and minima ("peaks") in the vector V.
%        MAXTAB and MINTAB consists of two columns. Column 1
%        contains indices in V, and column 2 the found values.
%      
%        With [MAXTAB, MINTAB] = PEAKDET(V, DELTA, X) the indices
%        in MAXTAB and MINTAB are replaced with the corresponding
%        X-values.
%
%        A point is considered a maximum peak if it has the maximal
%        value, and was preceded (to the left) by a value lower by
%        DELTA.

% Eli Billauer, 3.4.05 (Explicitly not copyrighted).
% This function is released to the public domain; Any use is allowed.
%http://www.billauer.co.il/peakdet.html for refrence
