%Linear Regression using Least Square Method
%Reference => https://towardsdatascience.com/building-linear-regression-least-squares-with-linear-algebra-2adf071dd5dd
Nt=4; %Number of flutes
a=1.5; %Depth of cut in mm
c=[0.025 0.050 0.100 0.150 0.200]; %feed rates in [mm/th]
Fx=[-69.4665 -88.1012 -105.6237 -118.1107 -130.6807]; %Force in x direction in [N]
Fy=[64.3759 99.1383 155.7100 210.4644 263.4002]; %Force in y direction in [N]
Fz=[-10.2896 -20.5814 -33.9852 53.4833 73.1515]; %Force in z direction in [N]
A=[5 sum(c); sum(c) sum(c.^2)];
B=[sum(Fx); sum(c.*Fx)];
Fxec=A\B;
Krc=(-4*Fxec(2))/(Nt*a);
Kre=(-pi*Fxec(1))/(Nt*a);
B=[sum(Fy); sum(c.*Fy)];
Fyec=A\B;
Ktc=(4*Fyec(2))/(Nt*a);
Kte=(pi*Fyec(1))/(Nt*a);
B=[sum(Fz); sum(c.*Fz)];
Fzec=A\B;
Kac=(-pi*Fzec(2))/(Nt*a);
Kae=(2*Fzec(1))/(Nt*a);
fprintf('Ktc = %.2f N/mm^2\t\tKte = %.2f N/mm\n', Ktc, Kte);
fprintf('Krc = %.2f N/mm^2\t\tKre = %.2f N/mm\n', Krc, Kre);
fprintf('Kac = %.2f N/mm^2\t\tKae = %.2f N/mm\n', Kac, Kae);