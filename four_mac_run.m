clear all
system_base_mva = 100.0;
four_mac_data
[Y] = form_Ymatrix(bus,line);
[bus_sol, line_flow] = power_flow(Y, bus, line);
% Synchronous machine initialisation

Smachs=[1;2;3;4];% buses with synchronous machines
Nbus=size(bus,1);% Number of buses
NSmachs=size(Smachs,1); %Number of synchronous machines

% program to initialise the synchronous machines
Synch_parameter_gen_base
generic_Sync_Init

% Copy the code in the Script 3.9
% Save this program as find_impedance_matrix.m
% Copy script from Script 2.5 here
% Calculate the vector of apparent power S injected by the generators for
% each system bus.
    PQ = bus_sol(:,4)+1i*bus_sol(:,5);
    
% Calculate the complex voltage value for all buses.
    vol = bus_sol(:,2).*exp(1i*bus_sol(:,3)*pi/180);
% Calculate the complex value of the current injected by the generators at
% each system bus
    Icalc = conj(PQ./vol);
    
% PL and QL are the real and reactive power drawn by loads at all system
% buses.

    PL = bus_sol(:,6);
    QL = bus_sol(:,7);
%V is the voltage magnitude at all system buses.

    V = bus_sol(:,2);
%The loads are assumed to be impedance type loads here and are included in
%the Y matrix. For more information on modelling loads, see chapter V. The
%Y matrix is then inverted to find the impedance matrix.
    YPL = PL./V.^2;
    YQL = QL./V.^2;
    Y = Y + diag(YPL-1i*YQL);
    Z = inv(Y);
% Finding post-fault impedance matrix
% Define post-fault admittance matrix
Yf = Y;
% Apply three phase fault at bus-8 by specifying very large admittance at
% Yf(8,8)
Yf(8,8) = 10000;
% Find post-fault impedance matrix
zf = inv(Yf);
