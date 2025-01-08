s_f=60; %system frequency in HZ
s_wb=2*pi*s_f;% base value radial frequency in rad/sec
s_ws=1; %pu value of synchronous speed
Zg= s_Rs + 1i*s_xddd; %Zg for sub-transient model
Yg=1./Zg; %Yg for sub-transient model

s_volt = bus_sol(Smachs,2); %voltage magnitude generator bus
s_theta = bus_sol(Smachs,3)*pi/180; %voltage angle in rad/sec

s_Vg= s_volt.*(cos(s_theta)+1i*sin(s_theta));%generator terminal voltage in complex form  in DQ frame
s_Ig= conj((s_Pg+1i*s_Qg)./s_Vg);% current at generator terminal in complex form in DQ refrence

s_Eq = s_Vg + (s_Rs+1i.*s_xq).*s_Ig;%effective voltage 
s_delta = angle(s_Eq);%generator rotor angle 

s_id = -abs(s_Ig).*sin(s_delta - angle(s_Ig));
s_iq = abs(s_Ig).*cos(s_delta - angle(s_Ig));
s_vd = -abs(s_Vg).*sin(s_delta - angle(s_Vg));
s_vq = abs(s_Vg).*cos(s_delta - angle(s_Vg)); %Converting quantities from DQ FRAME  to dq frame (3.1)

s_Efd = abs(s_Eq)-(s_xd-s_xq).*s_id;%initial value for field voltage (padiyar K.R.2008)
s_Eqd= s_Efd+ (s_xd - s_xdd).*s_id; %derived from  3.24 & 3.27 
s_Edd= -(s_xq - s_xqd).*s_iq;% (3.26)
s_Psi1d= s_Eqd+(s_xdd - s_xls).*s_id;% (3.27)
s_Psi2q= -s_Edd+(s_xqd - s_xls).*s_iq;% (3.26)

s_Te= s_Eqd.*s_iq.*(s_xddd-s_xls)./(s_xdd-s_xls)+ s_Psi1d.*s_iq.*(s_xdd-s_xddd)./(s_xdd-s_xls) + s_Edd.*s_id.*(s_xqdd-s_xls)./(s_xqd-s_xls) - s_Psi2q.*s_id.*(s_xqd-s_xqdd)./(s_xqd-s_xls)- s_iq.*s_id.*(s_xqdd-s_xddd); %from  3.23

s_Tm = s_Te;%from  3.22

s_iQ = cos(s_delta).*s_iq-sin(s_delta).*s_id;
s_iD = sin(s_delta).*s_iq+ cos(s_delta).*s_id;
% conversion from dq_frame to DQ_frame (3.2°

s_Vref= s_volt+1./s_Ka.*s_Efd;%(3.31)
