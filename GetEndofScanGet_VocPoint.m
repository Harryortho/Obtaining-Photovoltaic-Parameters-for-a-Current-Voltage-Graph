## Copyright (C) 2016 user
## 
## This program is free software; you can redistribute it and/or modify it
## under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 3 of the License, or
## (at your option) any later version.
## 
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
## 
## You should have received a copy of the GNU General Public License
## along with this program.  If not, see <http://www.gnu.org/licenses/>.

## -*- texinfo -*- 
## @deftypefn {Function File} {@var{retval} =} GetEndofScanGet_VocPoint (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: user <user@HARRYORTHO>
## Created: 2016-01-07

%This function requires the input data array from the imported current first, otherwise you will get incorrect values
function [EndScanPoints, VocPoints] = GetEndofScanGet_VocPoint (yI,volts)
FromVocPointneg =1;%initialvalues to remove warning;
FromVocPointpos =1;
figure
plot(yI);
title({'Current flow to help user to identify how many scans'})
xlabel('Voltage (V) Index Number')
ylabel('Current (Amps)')
cycles = input('how many IV scans are there (Short Circut going past the Open Circuit? :');
dvds = diff(volts);
figure
plot(dvds)
title({sprintf('Voltage scan rate to help user to identify if voltage scan is constant\nfor each scan of the IV curve\nif not then user will select the index points manually ')})
xlabel('Voltage (V) Index number')
ylabel('Current (Amps)')
%below gives 1 or 0 for yes or no respectively
constantvolt = yes_or_no('Is the change in the voltage constant most of the time?');
if (constantvolt==1) 
  %if voltage scan is steady with same increment and v/s
  changeScanRate = diff(diff(volts));
  figure
  plot(abs(changeScanRate));
  tol = input("type in a value lower than the main peaks, \n this will tell the program when the scans end \n:");
  EndScan = find(abs(changeScanRate)>tol)';
  EndScanPoints = EndScan+1; %the double differential removes 2 indicies from initial data so replace 
  EndScanPoints = [ EndScanPoints(1:end) , length(volts)]
  
  %this tries to find the values above/below 0 along one or more IV curves
  
  FromVocPointDown = find(yI<=0)'; %for curves current going positive to negative
  FromVocPointUp = find(yI>=0)'; %for curves current going negative to positive
  %the first Current or yI index with a value past below or above 0 is the first Voc point 
  if yI(1)>0
    VocPoint1 = FromVocPointDown(1);
    else
    VocPoint1 =  FromVocPointUp(1);
  end
  %voltage scanning in the 0 to positive range
  %now I need to find the ones inbetween
  ADown = diff(FromVocPointDown); %this is the one for values less than 0
  DownVocs = find(ADown>1)';
  VocDown = [ FromVocPointDown(DownVocs+1)];
  
  AUp = diff(FromVocPointUp); %this is the one for values greater than 0
  UpVocs = find(AUp>1)';
  VocUp = FromVocPointUp(UpVocs+1);%because the differential loses an indici
  
  VocsIndexes = [ VocPoint1, VocDown,VocUp]; %+1 due to the differential removing an indici so making up for it
  
  VocPoints = sort(VocsIndexes)
  else %because I don't quite know the technique for a non constant voltage change I will let the user decide from the graph.
  VocIndexes = zeros(1,cycles);
  EndScanPoints = zeros(1,cycles);
  for j=1:cycles;
  VocPoints(j) = input("\nFrom the graph, In consecutive order type in the index number of the \nVoc (the index just after the current crosses zero (0) unless it is zero:");
  EndScanPoints(j) = input("\nFrom the graph, In consecutive order type in the index number of the \nlast point where each of the the scan(s) end(s):");
  endfor
endif
return;

endfunction