%This is based on the paper and the program is to be used under the GNU license
%So that all researchers and others world wide may be able to freely extract
%IV Data, I would appreciate that it would not be used to harm another 
%human 	being so I am begging you not to use it for violence.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%L.H.I. Lim et al. / Renewable Energy 76 (2015) 135e142
%A linear method to extract diode model parameters 
%of solar panels from a single I-V curve
%While I did most of the work, I need to thank others who helped this
%to work.
%Thanks goes to the following people who have helped me and sadly, 
%I may have forgotten, there are many others who have helped with this
%code, so please remind me so that I can add you to the list 
%Dr Vasilios Constantoudis, Dr Loukas Peristeras, Dr Evangelos Evangelou
%Professor L.H.I Lim, Michael Markoulides, Dr Jaw, Dr Vasilios Raptis
% Eli Billauer, 3.4.05 (Explicitly not copyrighted). for his peakdet funtion

clc
clear all
more off
%graphics_toolkit ("gnuplot") %Until the later bug is fixed
graphics_toolkit ("qt") %this one has bugs and does not work properly
%This is based on the paper 
%L.H.I. Lim et al. / Renewable Energy 76 (2015) 135e142
%A linear method to extract diode model parameters 
%of solar panels from a single I-V curve

%______________INPUT FILE AND EXTRACT DATA__________
[FNAME, FPATH, FLTIDX] = ...
uigetfile ('Choose an ocw or txt file solar Intensity Sun');
addpath(FPATH); % this adds thehe paths to the working directory
Fid = fopen(FNAME);

[ListofFiles] = dir(FPATH);
skiplines = 2;
%This tells octave that I want two floating point numbers or doubles 
%I then import this array from the file
formatspec = '%f%f'; 
IVDATA = textscan (Fid, formatspec, 'HeaderLines', skiplines);

%PROGRAM BEGINS
%_________________________________________________
%____SETTING UP ARRAYS_____________________________

voltage = IVDATA{1,1};
current = IVDATA{1,2};

IVDATA = [voltage,current];

%get VoC_Index
Vocindex = Get_Voc(current);

%Insert the current and the function will work out the quadrant which
%the IV scan is going in and also it will work out the scan direction
%It outputs 4 values zero or 1 depending on whether the voltage 
%or current is positive (1) or negative (0), and also the scan direction
%positive flow (1) and negative flow(0)
Quad_DirOld = Quad_and_Direction(voltage(1:Vocindex),...
current(1:Vocindex),Vocindex);
%Defining the quadrants
OutputQuadrant(Quad_DirOld);
QuadrantList = ...
{'4th: Current Decreases (+ve...-ve), Voltage Decreases (0...-ve)';...
'4th: Current Increases (-ve...+ve), Voltage Increases (-ve...0)';...
'1st: Current Decreases (+ve...-ve), Voltage Increases (0...+ve)';...
'1st: Current Increases (-ve...+ve), Voltage Decreases (+ve...0)'; ...
'2nd: Current Decreases (+ve...-ve), Voltage Decreases (0...-ve)';...
'2nd: Current Increases (-ve...+ve), Voltage Increases (0...+ve)'; ...
'3rd: Current Decreases (+ve...-ve), Voltage Decreases (0...-ve)';...
'3rd: Current Increases(-ve...+ve), Voltage Decreases (0...-ve)'}; 

%If function to suggest what script to run depending on what quadrant
% the input data is in.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%GET END OF FIRST SCAN AND VocPOINT%%%%%%%%%%%%%%
%%%% SO FAR IT DOES NOT SEARCH FOR THE Reverse SCAN %%%
%Here I get the VocPoint and the end of the scan for my set of data%%
%%%%%%%%%%%%% considering I had multiple scans%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%Setting array scan of voltage & current  %%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if (current(1) <0) %Assuming the first value of the current is Isc 
	%and is always Illumination current
  current = current*-1;
endif 

negVoltfind = find(current<0)';

if ( (voltage(negVoltfind(end))  <= 0 ) )
  voltage = voltage*-1;
endif

[EndScanPoints, VocPoints] = ...
GetEndofScanGet_VocPoint(current,voltage);

Scancycles = length(EndScanPoints);

printf("\nWhich IV curve would you like to analyze there are %d in total ", Scancycles);
ScanNumber = input("If you choose a number outside the specified number the analysis will not work properly:")
%Currentcycles = input("How many IV cycles are on the graph:");
%the way the program is written below will make it select the peak after
%the VocIndex  so as not to find a false peak before due to noise.
[maxtab, mintab]=peakdet(current.*voltage,mean(current.*voltage))
find(mintab==0);%this is for later when I make the program detect other curves

FirstScan = length(current(1:EndScanPoints(ScanNumber)));
EndScanPoint = EndScanPoints(ScanNumber);
VocPoint = VocPoints(ScanNumber);
Voc = voltage(VocPoints(ScanNumber));
if ScanNumber <2 %this gets the scan range for the first curve
  y=current(1:FirstScan);
  v=voltage(1:FirstScan);
  vtilde = v(VocPoint).- v;
  else
  %this gets the scan range for the selected curve starting from 1 index after the endof the last scan
  %hence last (End point value +1):EndScanValue
  y=current(EndScanPoints(ScanNumber-1)+1:EndScanPoints(ScanNumber));
  v=voltage(EndScanPoints(ScanNumber-1)+1:EndScanPoints(ScanNumber));
  vtilde = voltage(VocPoint).- v; %digit (Voc in that scan) - voltageScan
endif
VocPoint = find(v==voltage(VocPoint));  %The Voc for the seperate array


%_________________________________________________
%_________________RESISTANCE 1 _ STEP 1______________
%Get the initial Series Resistance
%The number of points in the slope where the initial Rs is taken
Remain=EndScanPoint-VocPoint;

%Initial point for number of points about VocPoint to take resistance from
p=1;
%The loops below try to ensure the resistance is obtained from a slope
%which is +5 above and -5 below the VocIndex/VocPoint.
%It tries to make sure that if the length of the curve is outside of the 
%Vocpoint +5 then it reduces it so that there is a line only from that
%region. 
while VocPoint-p < 0
  p = p-1;
endwhile
while VocPoint+p > EndScanPoint
  p = p-1;
endwhile  
NumSlopePoints =p; 

%if putting xtilde in the initial Rsfunction 
%and not alternating the sign of v or y i think
Voc = vtilde(VocPoint); %should be zero This is to see whether the 
%Voc in the code needs to be different if 
%using a stable equation. or at normal V
Voc = v(VocPoint);
%voltvals = input('you can either type in v or vtilde, v is getting the 
%voltage using V=Voc, vtilde is getting the resistance at V=0:');

[RsMax, RsMin, RsRange] = Get_RseriesVoc...
(vtilde,  y, Voc,VocPoint,NumSlopePoints);
%Rs=RsRange(2);
printf("Choose what initial Series Resistance you want to work with, \nthe minimum is %f Ohms and the maximum is %f  Ohms", RsRange(1), RsRange(end));

Rs=input("\ntype in value of Series Resistance, Outside the recommended range will be accepted\nbut may not work properly:")%If Y and V are *-1
%To understand the graphs
xtilde = vtilde.-(Rs.*y);
x=Voc-xtilde;
slope = 1/Rs;

xtildeMax = vtilde.-(RsMax.*y);
slopeMax = 1/RsMax;

xtildeMin = vtilde.-(RsMin.*y);
slopeMin = 1/RsMin;
%forGraph for the point of the maximum power point
g = y.*v;
MaxPoInd = find(g == max(g));
figure
plot(vtilde,y, xtildeMin,y,xtilde,y,xtildeMax,y)
legend({'Data with Co-ordinate Transformation','Curve with Minimum Resistance','Curve with Maximum resistance','Curve with chosen Resistance'})
xlabel('Vtilde (V-Voc), Xtilde (Resistance Vtilde-Current*Resistance)')
ylabel('Current (Amps)')

figure
plot(vtilde(VocPoint-17:VocPoint), vtilde(VocPoint-17:VocPoint)/Rs,"linewidth",1,...
vtilde(VocPoint-50:VocPoint), vtilde(VocPoint-50:VocPoint)/RsMax,"linewidth",1,...
vtilde(VocPoint-4:VocPoint), (vtilde(VocPoint-4:VocPoint)/.25),"linewidth",1,...
vtilde(1:10:end), y(1:10:end),'o',"linewidth",1,...
xtilde, y,"linewidth",1,...
xtildeMax,y,"linewidth",1,...
xtildeMin,y, "linewidth",1);
legend({'slope','Maximum resistance slope',...
'quarter selcted resistance slope',...
'Vtilde Transformation zero resistance',...
'xtilde Rs vs y', ...
'xtilde Rsmax y',...
'xtilde Rsmin y' },
"location", 'south');  
xlabel('Voltage (V)')
ylabel('Current (Amps)')

%the difference between the length of curve and the position of the Voc
Remain = EndScanPoint-VocPoint;

t=xtilde;
%_________________________________________________

%_________________NEW VOLTAGE____________________
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%balanced Transform Voltage for Laplace transform%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%_________________________________________________
%_________________________________________________
%__________________Obtaining YHat STEP 2______________
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%Get the Phi Matrix%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Phi = zeros(length(v),4);
%To make the arrays smaller, if a large number of scans I split them up
%this reduces the memory and deals with each scan seperately so the 
%VocPoint in the large array won't fit in the array of the seperated 
%array after the first one, therefore it needs to be found when it is
%equal to the VocPoint of the voltage array

ylength = length(y);
vlength = length(v);
Ini_Matrix = PrepareIV_Matrix(t, y, ylength,Phi,1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%Theta Function%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%GET INITIAL PARAMATERS FROM Phi Matrix %%%%%%%%%%%%
%This function creates the Theta Function and then obtains the %%%%
%initial parameters from the Phi Function multiplied with Theta %%%%

[a, I_L, Io, Rsh] = Initial_Params(t, y(1:vlength), ....
Ini_Matrix,Voc,ylength);

% Put the initial Parameters in an array
Ini_Con = [a, I_L, Io, Rsh, Rs];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%Get initial Current simulation%%%%%%%%%%%%
[yHat1,Y1a,Y1b,Y1c] = get_yHat(t , Ini_Con(1:4), Voc, ylength);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%ERROR CHECKING Step 3%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

RMSE = sqrt(((sum(yHat1.-y).^2)/ylength))
ERR = sum(yHat1.-y);
y2length = length(yHat1);
tvlength = length(t);
%_________________________________________________

%This is where I see the first current.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%LOOP REFINEMENT STEP 4%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%error being less than the mean difference between each 
Tol = .004;%3.5e-6;%______(2% of the Isc value)
cycle =1;
CycleLimit= input("How many Iterations do you wish to run:");

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Building up ARRAYS as it is more efficient outside the loop
y2 = zeros(y2length,CycleLimit);
t2 = zeros(vlength,CycleLimit);

ERR2 = zeros(CycleLimit,1);
ERR2(cycle,1) = ERR;
RMSE2 = zeros(CycleLimit,1);
RMSE2(cycle,1) = RMSE;

RsUp2= zeros(CycleLimit,1); 
RsLow2= zeros(CycleLimit,1);

%3D Arrays
Ini_Matrix2 = zeros(length(y),4,CycleLimit);
Ini_Con2 = zeros(CycleLimit,4);
Rs_RMax_RMin = zeros(CycleLimit, 3);
Rs_RMax_RMin(cycle, :) = [Rs, RsMax, RsMin];

%New Initial Conditions
a2 = zeros(CycleLimit,1);
I_L2 = zeros(CycleLimit,1);
Io2 = zeros(CycleLimit,1);
Rsh2 = zeros(CycleLimit,1);
%w is =1; , number of parameters 5, number of points is length(y)
Rwp = sqrt(sum((y-yHat1).^2)/sum(y.^2))
Rexp = sqrt( ( length(y) - 5 ) / sum(y.^2))
Chi2 = Rwp/Rexp
EndScanPoint = length(y); %this is to allow the loop to work with
%this length because in the loop the EndScanPoint index number is just 
%the length of in yes_or_nothis analysis
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%LOOP %%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
profile on
while (RMSE2(cycle,1) >Tol )
    %RsRange= low to high resistance
    %Resistance start with half initial Rs_Upp, 
		%High Resistance = Rs_Upp
    if (cycle-1==0)
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      %RsUp2 etc. Editing the RsRefine and 
			%Resistance Range(Source of problem I think)
      [Rs_temp, Rs_Upp2temp, Rs_Low2temp] = ...
      Get_Refined_Rs(Rs,...
      RsMax, RsMin, ERR2(cycle,1));
      Rs_RMax_RMin(cycle,:) = [Rs_temp,Rs_Upp2temp,Rs_Low2temp];
      
      t2(:,cycle) = vtilde-Rs_temp*y;
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      
      else
      
      %New Resistances
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      %
      %This has to be cycle -1 because the new ones have not been created
      %Thus the values to deal with are from the previous cycle
      %RsRange= low to high resistance, High Resistance = Rs_Upp
      [Rs_temp, Rs_Upp2temp, Rs_Low2temp] = ...
      Get_Refined_Rs(Rs_temp, ...      
      Rs_Upp2temp,Rs_Low2temp,ERR2(cycle,1) );

      Rs_RMax_RMin(cycle,:) = ...
      [Rs_temp,Rs_Upp2temp,Rs_Low2temp];
      
      t2(:,cycle) = vtilde-Rs_temp*y;
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      %the current y2 is cycle-1 because I want the current in the previous 
      %cycle to be used to transorm the voltage, since the current cycle has
      %no new current.
      
    endif
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%NEW PHI%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%NEW Ini Conditions%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
   %New Matrix 
    if (cycle-1==0)
      Ini_Matrix2(:, :,cycle) = ...
      PrepareIV_Matrix(t2(:,cycle), yHat1,EndScanPoint,Ini_Matrix);
      
      [a2i, I_L2i, Io2i, Rsh2i] = Initial_Params(t2(:,cycle),...
      yHat1, Ini_Matrix2(:,:,cycle), Voc,EndScanPoint);
      
      else
      Ini_Matrix2(:,:,cycle) = ...
      PrepareIV_Matrix(t2(:,cycle), Ytemp2,EndScanPoint,Ini_Matrix2(:,:,cycle-1));
      
      [a2i, I_L2i, Io2i, Rsh2i] = Initial_Params(t2(:,cycle),...
      Ytemp2, Ini_Matrix2(:,:,cycle-1), Voc,EndScanPoint);
      
    endif
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%Parameters during loop %%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    a2(cycle,1)= a2i;
    I_L2(cycle,1) = I_L2i;
    Io2(cycle,1) = Io2i ;
    Rsh2(cycle,1) = Rsh2i;
    Rsh2i
    %placing them in an array hopefully simpler and cheaper on cpu
    Ini_Con2(cycle,:) = [a2i, I_L2i, Io2i, Rsh2i];
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %GET THE 2nd CURRENT AFTER CHANGING THE RESISTANCE%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
    %This IF section is to ensure that the right current is passed through 
    %and we do not get a repeat
    if (cycle-1==0)
      [Ytemp2 , Ytemp2eqA, Ytemp2eqB, Ytemp2eqC] =...
      get_yHat(t2(:,cycle), Ini_Con2(cycle,:), Voc, EndScanPoint);
      y2(:,cycle) = Ytemp2';
      else
      
      [Ytemp2 , Ytemp2eqA, Ytemp2eqB, Ytemp2eqC]= ...
      get_yHat(t2(:,cycle),Ini_Con2(cycle,:),Voc, EndScanPoint);
      y2(:,cycle) = Ytemp2';
      
    endif 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %______________________________________________
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%%%%%%    ERRROR CHECKING FOR LOOP     %%%%%%%%%%
    %%%%%%%        RMSE AND ERROR                  %%%%%%%%%%
    %%%%          RESISTANCE REFINEMENT         %%%%%%%%%%
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %This is the new current with the new resistance value from
    %from outside the loop
    
    %Error Checking new current and originial
    cycle = cycle+1
    RMSE2(cycle,1) = sqrt(((sum(minus(Ytemp2,y))^2)/ylength));
    ERR2(cycle,1) = sum(minus(Ytemp2,y));
    err = ERR2(cycle,1)
    %display_Cycle_ERR_RMSE = [cycle-1, ERR2(cycle-1), RMSE2(cycle-1)]
    %This is so that the error tolerances obtain their values for 
    %comparison otherwise the initial 2nd value at RMSE2(2,1) = 0 will
    %remain and the loop will end.
    if(cycle>CycleLimit)
    break
    endif
    %While the cycle number is greater than the Cycle limit here, in the 
    %real situation, if one starts from the beginning of the algorithm 
    %before the loop began, you can already consider that as the first
    %cycle from when the extreme series resistance was extracted from 
    %the slope of the IV curve
    %and thus the total cycles is the cycle value unless it has converged
    profile off
endwhile
%Removing the elements of the curve not calculated
if (cycle<CycleLimit)
  %RsRange2(:,cycle:CycleLimit)=[];
  y2(:, cycle:CycleLimit)=[];
  t2(:, cycle:CycleLimit)=[];
  Ini_Con2(cycle:CycleLimit, :)=[];
  Ini_Matrix2(:, :, cycle:CycleLimit)=[];
  Rs_RMax_RMin(cycle:CycleLimit, :) = [];
  ERR2(cycle+1:CycleLimit, :)=[];
  RMSE2(cycle+1:CycleLimit, :)=[];
  a2(cycle:CycleLimit, :)=[];
  I_L2(cycle:CycleLimit, :)=[];
  Io2(cycle:CycleLimit, :)=[];
  Rsh2(cycle:CycleLimit, :)=[];
endif
Ini_Con2(end,:) = [...
-a2i,...
I_L2i - ( Io*(1-exp(Voc/a)) ) + ( Voc/Rsh ),...
Io2i*exp(-Voc/a2i),...
-Rsh2i...
];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%PLOTS FOR THE DATA FOLLOW%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ORDER OF INITIAL CONDITIONS FOR DEBUGGING%%%%%%%
%%%%%%%%%%                                          %%%%%%%%%%%%%
%%%%%%%%%%       a, I_L, Io, Rsh               %%%%%%%%%%%%%
%%%%%%%%%%                                          %%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


graphics_toolkit
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%HOW ERR AND RMSE CHANGED DURING CYCLE%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%Root Mean Squared RMSE2%%%%%%%%%%%%%%%
figure
subplot(2,2,1:2)
plot(RMSE2)
title({'Value of Root Mean' ; 'Square During Iterations'})
%%%%%%%%%%ERROR%%%%%%%%%%%%%%%%%
subplot(2,2,3:4)
plot(ERR2)
title({'Value of ERR';' During Iterations'})
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
InCon2 = Ini_Con2;
figure
subplot(5,2,1:2)
plot(InCon2(:,1))
title({'Value of ';'Transformed ideality factor (a)';'During Iterations'})
%xlabel('Iteration Number in loop')
ylabel({'Transformed';' Ideality Factor'})

subplot(5,2,3:4)
plot(InCon2(:,2))
title({'Value of Illumination';'Current During Iterations'})
%xlabel('Iteration Number in loop')
ylabel({'Calculated ';'Illumination Current'})

subplot(5,2,5:6)
plot(InCon2(:,3))
title({'Value of Dark Current';' During Iterations'})
%xlabel('Iteration Number in loop')
ylabel({'Calculated';' Dark Current'})

subplot(5,2,7:8)
plot(InCon2(:,4))
title({'Value of Shunt Resistance';' During Iterations'})
%xlabel('Iteration Number in loop')
ylabel({'Calculated'; 'Shunt Resistance'})

subplot(5,2,9:10)
plot(Rs_RMax_RMin(:,1))
title({'Value of Series Resistance';' During Iterations'});
xlabel('Iteration Number in loop')
ylabel({'Binary Search'; 'Series Resistance';' Refinement'})
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%CHECKING THE Phi Matrix%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%Ideality factor n calculation
%a = nKT/q q is eV
Elec_Charge=1.602e-19;
K= 1.38064852e-23;
Temp=298;

%DOES THE PAPER CONVERT THE A or is this the problem too??????
n = (a2(end)*Elec_Charge)/(K*Temp);

%cycle(cycle<CycleLimit) = cycle+1;
IV_CircuitParameters =...
{'Final A', 'Calculated n', 'Final I_L', 'Final Io', 'Final Rsh', 'Final Rs' , 'Final RMSE','Final Error', 'Cycles';...
a2(end), n, I_L2(end), Io2(end), ...
Rsh2(end),Rs_RMax_RMin(end,1),RMSE2(end),ERR2(end),cycle}

%_________________________________________________

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%COMPARISON OF INITIAL AND TRANSFORMED VOLTAGEs%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure
plot(v,y,v,yHat1,v,y2(:,1),v,y2(:,2),v,y2(:,3))
title({'Original Current against Transformed Voltage';' with Balance function vs Iterations for fitting 1st,2nd and 3rd'})
legend({'Original Current and Voltage','First Iteration','2nd Iteration','3rd Iteration','4th Iteration'},...
"location",'south');
xlabel('Voltage (V)')
ylabel('Current (Amps)')

figure
plot(v,y,v,yHat1,v,y2(:,1),v,y2(:,10),v,y2(:,end))
title({'Original Current against Transformed Voltage';' with Balance function vs Iterations for fitting 1,10 and Final'})
legend({'Original Current and Voltage','First Iteration','2nd Iteration','10th Iteration','Final Current and Voltage'},...
"location",'south');
xlabel('Voltage (V)')
ylabel('Current (Amps)')

Quad_DirOld = Quad_and_Direction(voltage(1:Vocindex),...
current(1:Vocindex),Vocindex);


profshow
%profexplore
profile clear