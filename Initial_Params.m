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
## @deftypefn {Function File} {@var{retval} =} Initial_Params (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: user <user@HARRYORTHO>
## Created: 2016-01-07

function [a, I_L, Io, Rsh]  = Initial_Params (Volt, Curr, ...
InitMatrix,VocVal, Set_Volt_Scan_Length) %Voltage, Current, Limit of scan, Initial Matrix values
%L = length(InitMatrix(:,1)); %L in this case is to the Voc Point
%Voc = VocVal; %to make it faster i will comment it out
%This was in the function, I don't fully understand the paper.
%Gamma = -cumtrapz(Curr(1:Set_Volt_Scan_Length));

Gamma = zeros(Set_Volt_Scan_Length,1);
Gamma = -cumtrapz(Volt(1:Set_Volt_Scan_Length), Curr(1:Set_Volt_Scan_Length));
%Gamma = -trapz(Volt(1:L), Curr(1:L)); ths is wrong
%Theta = zeros(4,1);
Theta = zeros(4,1);

%for g = 1:length(Gamma);
%Theta(:,:,g) = (((inverse(transpose(InitMatrix(:,g)) *InitMatrix(:,g))) *transpose(InitMatrix(:,g)))*Gamma(g));
%endfor
%Theta = Theta(:,:,length(Gamma));
%
Theta = (inverse(transpose(InitMatrix)*InitMatrix) ...
*transpose(InitMatrix))*Gamma;


%Theta = mtimes(mtimes(
%inverse(
%mtimes(    transpose(InitMatrix)   ,     InitMatrix)...
%), ...
%transpose(InitMatrix)),...
%Gamma);
%Th=Theta; %For short hand commented out to make it slightly faster

a =Theta(1);
%a(a<0)=a*-1;
%a(a<.01)=0.01;
%a = nKT/q q is eV
%Elec_Charge=-1.602e-19;
%K= 1.38064852e-23;
%Temp=298;
%n=5;%set value for n if it helps code
%n=atilde; %depends if I have understood the order of the paper correctly
%n = (a*Elec_Charge)/(K*Temp);
%atilde=-n;
%atilde=-a;
%a=atilde;
Io = ( ...
  (Theta(3) ...
  - ( Theta(2)/Theta(1) ) ...
  - ( Theta(1)*Theta(4) )...
  )/exp(VocVal/Theta(1))
);%.*-1; 0.3*
%Iotilde= Io*exp(VocVal/a);
%Io = Iotilde;

Rsh = (1 /Theta(4));%10*
%Rsh(Rsh<0)=Rsh*-1;
%Rshtilde = -Rsh;
%Rsh = Rshtilde;
I_L =...
( Theta(2)/Theta(1) ) ...
 + (... 
( Theta(3) - (Theta(2)/Theta(1)) - ( Theta(1)*Theta(4))) * (1-exp(-VocVal/Theta(1)) ) ...
) + (VocVal*Theta(4));
%I_Ltilde = I_L + Io*(1 -exp(VocVal/a)) - (VocVal/Rsh);
%I_L= I_Ltilde;

endfunction