%four_machine_data
clear all 
system_base_mva = 100;
%bus no, voltage mag, voltage angle, Pgen, Qgen, Pload, Qload, Pshunt,
%Qshunt, bus type 

bus=[1  1 0 7 0 0.000 0 0 0.00 2
     2  1 0 7 0 0.000 0 0 0.00 2
     3  1 0 0 0 0.000 0 0 0.00 1
     4  1 0 7 0 0.000 0 0 0.00 2
     5  1 0 0 0 0.000 0 0 0.00 3
     6  1 0 0 0 0.000 0 0 0.00 3
     7  1 0 0 0 9.670 1 0 2.00 3
     8  1 0 0 0 0.000 0 0 0.00 3
     9  1 0 0 0 17.67 1 0 3.50 3
     10 1 0 0 0 0.000 0 0 0.00 3
     11 1 0 0 0 0.000 0 0 0.00 3];

%from bus, to bus, resistance, inductance, capacitance, tap-ratio,tap phase
line=[01 05 0.0000 0.0167 0.00000 1 0
      02 06 0.0000 0.0167 0.00000 1 0
      03 11 0.0000 0.0167 0.00000 1 0
      04 10 0.0000 0.0167 0.00000 1 0
      05 06 0.0025 0.0250 0.04375 1 0
      10 11 0.0025 0.0250 0.04375 1 0
      06 07 0.0010 0.0100 0.01750 1 0
      09 10 0.0010 0.0100 0.01750 1 0
      07 08 0.0110 0.1100 0.19250 1 0
      07 08 0.0110 0.1100 0.19250 1 0
      08 09 0.0110 0.1100 0.19250 1 0
      08 09 0.0110 0.1100 0.19250 1 0];
  [Y]= form_Ymatrix(bus,line);
 %calculation pre_fault power flow solution
 [bus_sol, line_flow]= power_flow(Y,bus, line);
 
 mac_con =[
1 900 0.2 0.0025 1.8 0.3 0.25 8 0.03 1.7 0.55 0.25 0.4 0.05 6.5 0; 
2 900 0.2 0.0025 1.8 0.3 0.25 8 0.03 1.7 0.55 0.25 0.4 0.05 6.5 0;
3 900 0.2 0.0025 1.8 0.3 0.25 8 0.03 1.7 0.55 0.25 0.4 0.05 6.5 0;
4 900 0.2 0.0025 1.8 0.3 0.25 8 0.03 1.7 0.55 0.25 0.4 0.05 6.5 0];

% *********************** EXCITATION SYSTEM DATA ******************
s_Ka=200;%Static excitation gain Padiyar p.328
s_Ta=0.02;%Static excitation time constant Padiyar p.328

% **** Governor Control SYSTEM DATA – not used *********
s_Tg=0.2;%Kundur p.598
s_Rgov=0.05;%Kundur p.598%governor control system data 

 %synchronous machine initialisation 
 Smachs=[1;2;3;4]  ;  %Buses with synchro,nous machines 
 Nbus= size (bus,1); %number of buses
 NSmachs=size(Smachs,1);%number of synch machines 
 
 %prog to initialize the synchro mach
 Synch_parameter_gen_base  %or_sys_base, depending on the base system we decide to work in
 generic_Sync_Init
 
 Yf = Y;
% Apply three phase fault at bus-8 by specifying very large 
%admittance at Yf(8,8)
Yf(8,8) = 10000;
% Find post-fault impedance matrix.
Zf = inv(Yf)
  %calculates the vector of apparent power S injected by the generators for
 %each system bus
 PQ= bus_sol(:,4)+1i*bus_sol(:,5);
 %Calculates the complex voltage value for all buses
 vol= bus_sol(:,2).*exp(1i*bus_sol(:,3)*pi/180)
 %calculates the complex value of the current injected by the generators at
 %each system bus 
 Icalc= conj(PQ./vol);
 %PL and QL are the real and reactive power drawn by load at all system
 %buses
 PL= bus_sol(:,6);
 QL= bus_sol(:,7);
 %V is the voltage magnitude at all system buses
 V=bus_sol(:,2);
 
 %load are assumed to be impedance type loas 
 YPL=PL./V.^2;
  YQL=QL./V.^2
  Y=Y+diag(YPL-j*YQL);
  Z=inv(Y);
