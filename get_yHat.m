## -*- texinfo -*- 
## @deftypefn {Function File} {@var{retval} =} get_yHat (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: user <user@HARRYORTHO>
## Created: 2016-01-07

function [yHatArray,Eq_Part1 ,Eq_Part2,Eq_Part3] =...
get_yHat(Volt, Ini_Param,VocVal,endPoint)
%Build up yHatdd

%[Eq_Part1,Eq_Part2,Eq_Part3] = deal(zeros(endPoint,1));
Eq_Part1 = zeros(endPoint,1);
Eq_Part2 = zeros(endPoint,1);
Eq_Part3 = zeros(endPoint,1);

%a_tilde    =  Ini_Param(1);
%I_L_tilde  =  Ini_Param(2);
%Io_tilde   =  Ini_Param(3);
%Rsh_tilde =  Ini_Param(4);

a    =  Ini_Param(1);
I_L  =  Ini_Param(2);
Io   =  Ini_Param(3);
Rsh =  Ini_Param(4);
%a    =  -a_tilde;
%Io   = Io_tilde*exp(-VocVal/a);
%Rsh =  -Rsh_tilde;
%%Rsh(Rsh>200)=400;
%I_L =  I_L_tilde - ( Io*(1-exp(VocVal/a)) ) + ( VocVal/Rsh );

%Eq_Part1 = Io.*exp( Volt(1:endPoint)' / a );
%Eq_Part2 = Volt(1:endPoint)' / Rsh;
%Eq_Part3 = (I_L + Io) - ( Eq_Part1 ) - Eq_Part2;

%for Balancing function to work? when tilde is put in instead for V
%Unless in Initial Parametersfunction
%a = -a;
%Rsh = -Rsh;
%Io = Io*exp(-VocVal/a);
%I_L = I_L- Io*(1-exp(VocVal/a)) + (VocVal/Rsh);

%a = nKT/q q is eV
%Elec_Charge=-1.602e-19;
%K= 1.38064852e-23;
%Temp=298;
%%n=5;%set value for n if it helps code
%%n=atilde; %depends if I have understood the order of the paper correctly
%a = (a*Elec_Charge)/(K*Temp);
%YHatxtil = I_L .+ Io .- (VocVal./Rsh) .- (Io.*exp(VocVal./a).*exp(-Volt(1:endPoint)./a)).+(-Volt(1:endPoint)./Rsh);
%

Eq_Part1 = (I_L + Io - (VocVal./Rsh) +(Volt(1:endPoint)./Rsh) );
Eq_Part2 = Io*exp(VocVal/a).*exp( -Volt(1:endPoint)./ a );
Eq_Part3 = Eq_Part1 .- Eq_Part2;
%%Really only one of these is needed and the other is redundant, it was to
%%possibly have an array with multiple y values.

yHatArray = Eq_Part3;%YHatxtil;

%Eq_Part3( Eq_Part3 > 1.7e1 ) = 3e-2; %Isc at 1Sun
%Eq_Part3( Eq_Part3 < -1.7e1 ) = -3e-2; %Isc at 1Sun

endfunction
