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
## @deftypefn {Function File} {@var{retval} =} PrepareIV_Matrix (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: user <user@HARRYORTHO>
## Created: 2016-01-07

function Phi = PrepareIV_Matrix (volts, cur , Endpoint,BigPhi,cycle);
%EndPoint is the end of the curve, in this case it is the Voc Point
BigPhi(:,1) = cur(1:Endpoint);
BigPhi(:,2) = -ones(1,Endpoint);%ones(Endpoint,1);%
BigPhi(:,3) = -volts(1:Endpoint);%cumtrapz(volts(1:Endpoint)',BigPhi(2,:, cycle ) ); %%-volts(1:Endpoint);%--cumtrapz(-B);% -cumtrapz(volts(1:Endpoint),ones(Endpoint,1));%
BigPhi(:,4) = -(1/2).*(volts(1:Endpoint).^2);%cumtrapz(volts(1:Endpoint)',BigPhi(3,:, cycle ) );%--(1/2).*(volts(1:Endpoint).^2);%-(1/2).*(volts(1:Endpoint).^2);%-cumtrapz(-C);%%power(volts(1:Endpoint),2);%-cumtrapz(volts(1:Endpoint),cumtrapz(volts(1:Endpoint),ones(Endpoint,1)));%
Phi = BigPhi;
%[A, -B,C, -D];
%Is the code below faster???? and cpu cheaper???/
%Phi = zeros(Endpoint,4);
%Phi(:,:) =...
%[cur(1:Endpoint),-ones(Endpoint,1), -volts(1:Endpoint),-(1/2).*volts(1:Endpoint).^2];
%I am thinking the last bit of code is slower but from what I read it shouldn't be.
return;
endfunction

%%%Preparing the matrix of values
%A = cur(1:Endpoint);
%B = -ones(Endpoint,1);
%C = cumtrapz(volts(1:Endpoint)); C is wrong, should be C = volts(1:Endpoint); or C = cumtrapz(volts(1:Endpoint), -B);
%D = -cumtrapz(volts(1:Endpoint)); D is wrong, should be D = 1/2*volts(1:Endpoint).^2; or D = cumtrapz(volts(1:Endpoint), C);
%Phi = [A, B, C, D];
