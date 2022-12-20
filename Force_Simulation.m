%Inputs

%Cutting conditions
a=1.5; %axial depth of cut in mm
c=0.100; %feed rate in mm/th
n=2500; %spindle speed in rpm
phi_st=0.0; %radian
phi_ex=pi; %radian
%Tool geometry
D=20; %Diameter of end mill in mm
N=4; %Number of teeth on the cutter
beta=(30*pi)/180; %helix angle in radian
%Cutting constants
Ktc=751.63; %N/mm^2
Krc=221.09; %N/mm^2
Kac=-293.25; %N/mm^2
Kte=21.07; %N/mm
Kre=35.38; %N/mm
Kae=-15.48; %N/mm
%Integration angle
dphi=0.001; %radian
%Integration height
da=0.001; %mm

%Variables

phiP=(2*pi)/N; %Cutter pitch angle in radian
K=(phi_ex-phi_st)/dphi; %Number of angular integration steps
L=a/da; %Number of axial integration steps
sumFx=0.0; sumFy=0.0; sumFz=0.0; sumF=0.0;
for i=1:1:K
    PHI(i)=phi_st+(i*dphi);
    Fx(i)=0.0; Fy(i)=0.0; Fz(i)=0.0; Ft(i)=0.0;
    for k=1:N
        PHI1=PHI(i)+(k-1)*phiP;
        PHI2=PHI1;
        for j=1:1:L
            a(j)=j*da;
            PHI2=PHI1-(((2*tan(beta))/D)*a(j));
            if (phi_st<=PHI2)&&(PHI2<=phi_ex)
                h=c*sin(PHI2);
                dFt=da*((Ktc*h)+Kte);
                dFr=da*((Krc*h)+Kre);
                dFa=da*((Kac*h)+Kae);
                dFx=-(dFt*cos(PHI2))-(dFr*sin(PHI2));
                dFy=(dFt*sin(PHI2))-(dFr*cos(PHI2));
                dFz=dFa;
                Fx(i)=Fx(i)+dFx;
                Fy(i)=Fy(i)+dFy;
                Fz(i)=Fz(i)+dFz;
                Ft(i)=Ft(i)+dFt;
            end
        end
    end
    F(i)=sqrt((Fx(i))^2+(Fy(i))^2+(Fz(i))^2); %resultant force
    sumFx=sumFx+Fx(i);
    sumFy=sumFy+Fy(i);
    sumFz=sumFz+Fz(i);
    sumF=sumF+F(i);
    T(i)=(D/2)*Ft(i);
end

%Outputs

fprintf('Fx(avg) = %.2f N\n', sumFx/K);
fprintf('Fy(avg) = %.2f N\n', sumFy/K);
fprintf('Fz(avg) = %.2f N\n', sumFz/K);
fprintf('Fres(avg) = %.2f N\n', sumF/K);
plot(PHI,Fx,PHI,Fy,PHI,Fz,PHI,F)
yline([sumFx/K sumFy/K sumFz/K sumF/K],'--',{'Fx(avg)', 'Fy(avg)', 'Fz(avg)', 'Fres(avg)'});
legend('Fx','Fy','Fz','Fres')
title('Force (feed, normal & resultant) vs Immersion angle')
xlabel('Immersion angle (rad)')
ylabel('Force (N)')
figure;
plot(PHI,T)
title('Torque vs Immersion angle')
xlabel('Immersion angle (rad)')
ylabel('Torque (N.mm)')
