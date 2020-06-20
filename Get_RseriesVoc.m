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
## @deftypefn {Function File} {@var{retval} =} Get_Rseries (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: user <user@HARRYORTHO>

## Created: 2016-01-22

function [Rs_upp, Rs_low, Res_Range] =...
Get_RseriesVoc(Volt, Curr, Voc,VocInd, points)
%Rs = -1/ (DI/DV) at Voc
%If current is positive to negative and voltage goes zero to positive
%Implement later on how to identify type of curv, Rs is taken from 
%beginning of curve and not the end.
%Eq_Part3( Eq_Part3 > 1.7e1 ) = 3e-2; 
%Volt(Volt < 0) =Volt*-1; 

% so that if the length of the array is only a scan to the Voc then there 
%is not out of bounds error after

if points + VocInd >length(Volt) 
	pointsAfter = 0;
	else
	pointsAfter = points;
end

if Curr(1) <0
  VocIndex= find(Curr>0)';
  VocIndex=VocIndex(1);
  else
  VocIndex= find(Curr<0)';
  VocIndex=VocIndex(1);
endif
equalVocs = isequal(Volt(VocInd),Volt(VocIndex))
DV_voc = Volt(VocIndex + pointsAfter )-Volt(VocIndex - points); %vtilde
DI_voc = Curr(VocIndex + pointsAfter )-Curr(VocIndex - points); %vtilde

if Volt (VocIndex)!=0 %in case the voltage is vtilde which is zero at V = Voc     
      if mean(diff(Curr)) < 0  % so as to figure out the direction of
				%%%%%%%%%%the current to get the correct resistatnce sign
				slope = (DI_voc/DV_voc);
				Rs_upp = -1/slope;
			
			else mean(diff(Curr)) > 0
		    slope = (DI_voc/DV_voc);
  	    Rs_upp = 1/slope; 
			endif
			
			if mean(diff(Curr)) < 0 % so as to figure out the direction of
		  %%%%%%%%%%%the current to get the correct resistatnce sign
		  	slope = (DI_voc/DV_voc);
  	  	Rs_upp = -1/slope;
			endif
			else
      	slope = (DI_voc/DV_voc);
      	Rs_upp = 1/slope; 
endif
Rs_low =1e-12;

Res_Range = linspace(Rs_low,Rs_upp,100)';
endfunction
%DV_voc = -Volt(CurveEnd-points)+Volt(CurveEnd); %vtilde
%DI_voc = -Curr(CurveEnd-points)+Curr(CurveEnd); %vtilde  
%DV_Voc = mean(diff(Volt(CurveEnd-points:CurveEnd)));
%%DI_Voc = mean(diff(Curr(CurveEnd-points:CurveEnd)));
%if Curr(1) >0 %if the current begins from positive and goes negative
%      DV_voc = Volt(VocIndex)-Volt(VocIndex-points); %regular
%      DI_voc = Curr(VocIndex)-Curr(VocIndex-points); %regular  
%      else%if the current begins from positive and goes negative
%      %I am not sure which one is suitable out of the three
%      DV_voc = Volt(VocIndex+points)-Volt(VocIndex); %regular
%      DI_voc = Curr(VocIndex+points)-Curr(VocIndex); %regular
%DV_voc = Volt(VocIndex+1)-Volt(VocIndex-1); %best??
%DI_voc = Curr(VocIndex+1)-Curr(VocIndex-1); %best??
%DV_voc = Volt(CurveEnd)-Volt(CurveEnd+points); %vtilde y flip
%DI_voc = Curr(CurveEnd)-Curr(CurveEnd+points); %vtilde y flip
%If it is meant to be for the beginning of the curve??
%DV_voc = Volt(points)-Volt(1); 
%DI_voc = Curr(points)-Curr(1); 


%this will allow proper analysis of upper and lower resistances depending
%on the sign of the slope for refinement later on.
%if (slope <0)
%  Rs_upp = 1 / slope;
%  Rs_low = 0.001;
%  else
%  Rs_upp = 1 / slope;
%  Rs_low = 0.001;
%endif

%Rs_upp(Rs_upp<0) =Rs_upp*-1; 
%Rs_upp = 1/slope;%vtilde or y going negative....positive

%if Volt(VocIndex)!=0 %to deal with vtilde if inputted
%       L = length(Volt);
%       DV_voc = Volt(VocIndex + points)-Volt(VocIndex - points); %vtilde
%       DI_voc = Curr(VocIndex + points)-Curr(VocIndex - points); %vtilde
%       slope = (DI_voc/DV_voc);
%       Rs_upp = 1/slope;
%      else%if the voltage is not Vtilde
%      DV_voc = Volt(VocIndex+points)-Volt(VocIndex); %regular
%      DI_voc = Curr(VocIndex+points)-Curr(VocIndex); %regular
%      slope = (DI_voc/DV_voc);
%      Rs_upp = -1/slope; 
%endif
%Rs_upp = -1/slope;
%Rs_upp = (DI_voc/DV_voc)


%Rs_upp = -1/ (DV_voc/DI_voc) ;
%I am not sure which Rs I should be using But should be according to the
%%paper where Rs =< 1/Di/Dv if Vtilde Vtilde=0 or if V V=VocPoint
%if Volt(1)==0 %regular v
%  Rs_upp = -1/slope;
%%  if Curr(1) <0 %if scanning from Positive V to negative V not if graph is in the y negative quadrants
%%    Rs_upp=Rs_upp*-1;
%%  endif
%else
%  Rs_upp = 1/slope; %vtilde
%%  if Curr(1) <0
%%    Rs_upp=Rs_upp*-1;
%%  endif
%endif
