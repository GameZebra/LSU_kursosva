% зад 1
% получаваме описание в пространство на състоянията от симулинк файла
[A, B, C, D] = linmod('blockshemaotvorena');
% получаване на еквивалентна предавателна функция
[num0, den0] = ss2tf(A, B, C, D)
sys_tf = tf(num0, den0)
sys_ss = ss(A, B, C, D);

% можем да получим еквивалентната предавателна функция като последователно
% свързани елементарни звена като намерим корените на числителя и
% знаменателя
% нули
nul=roots(num0)
% полюси
pol=roots(den0)

% Построяване на времеви характеристики на отворената система
figure(1)
step(sys_tf), grid on;
figure(2)
impulse(sys_tf), grid on;

% Построяване на честотните характеристики на отворената система
figure(3)
bode(sys_tf), grid on;
figure(4)
nyquist(sys_tf), grid on;  %TODO: да е само от едната страна



% зад 2 изследване на устойчивост
sys_tf_closed = feedback(sys_tf, 1, -1)
% критерий на Хурвиц
num_closed = sys_tf_closed.num{1}
den_closed = sys_tf_closed.den{1}
H = [den_closed(2) den_closed(4) den_closed(6) 0 0;
    den_closed(1) den_closed(3) den_closed(5) 0 0;
    0 den_closed(2) den_closed(4) den_closed(6) 0;
    0 den_closed(1) den_closed(3) den_closed(5) 0;
    0 0 den_closed(2) den_closed(4) den_closed(6);];
det(H(1:2,1:2))
det(H(1:3,1:3))
det(H(1:4,1:4))
det(H)
% критерият е изпълтен

% критерий на боде
figure(5)
margin(sys_tf)
allmargin(sys_tf)

% критерий на Найквист
[u, v] = nyquist(sys_tf);
u = squeeze(u); v= squeeze(v);
figure(6)
plot(u,v,'b', -1,0, 'ro'), grid, title('Nyquist plot'), xlabel('u'), ylabel('v');

% зад 3 
% ходограф на корените
figure(7)
rlocus(num0, den0)
figure(8)
rlocus(sys_tf)
[kpol, poles] = rlocfind(sys_tf)

% изследване на системата при различни коефициенти на усилване
% избират се няколко пъти различни стойности от ходографа на корените
sys_tf_1_closed = feedback(kpol*sys_tf, 1, -1)
figure(9)
step(sys_tf_1_closed), grid on;
rlocus(sys_tf_1_closed)


% зад 4 на ръка се сваля описанието в пространство на състоянията от
% структурната схема

% зад 5
% Изчисляване на елементите на матричната експонента
t = 0:0.1:800;
nt=length(t);
MeCol1=[]; MeCol2=[]; MeCol3=[]; MeCol4=[]; MeCol5=[];

for k = 1:nt
    me=expm(A*t(k));
    MeCol1=[MeCol1 me(:,1)];
    MeCol2=[MeCol2 me(:,2)];
    MeCol3=[MeCol3 me(:,3)];
    MeCol4=[MeCol4 me(:,4)];
    MeCol5=[MeCol5 me(:,5)];
end

figure(10)
plot(t, MeCol1(1,:), 'b', t, MeCol1(2,:),'g', t, MeCol1(3,:), 'r', t, MeCol1(4,:),'c', t, MeCol1(5,:), 'm'), grid on;

figure(11)
plot(t,MeCol2(1,:), 'b', t, MeCol2(2,:),'g', t, ...
     MeCol2(3,:), 'r', t, MeCol2(4,:),'c', t, ...
     MeCol2(5,:), 'm'), grid on;

figure(12)
plot(t,MeCol3(1,:), 'b', t, MeCol3(2,:),'g', t, ...
     MeCol3(3,:), 'r', t, MeCol3(4,:),'c', t, ...
     MeCol3(5,:), 'm'), grid on;

figure(13)
plot(t,MeCol4(1,:), 'b', t, MeCol4(2,:),'g', t, ...
     MeCol4(3,:), 'r', t, MeCol4(4,:),'c', t, ...
     MeCol4(5,:), 'm'), grid on;

figure(14)
plot(t,MeCol5(1,:), 'b', t, MeCol5(2,:),'g', t, ...
     MeCol5(3,:), 'r', t, MeCol5(4,:),'c', t, ...
     MeCol5(5,:), 'm'), grid on;

% зад 6
T0 = 0.0001;
[numd, dend] = c2dm(num0, den0, T0, 'zoh');
printsys(numd,dend,'z')

[F,G,Cd,Dd]=c2dm(A,B,C,D,T0,'zoh')
figure(15)
dstep(numd, dend, 40)


% зад 7
roots(dend)
dstep(dend)

% зад 8
sum(out.Y)/length(out.Y)
% дисперсия на изходния сигнал
[nump, denp] = feedback(num0*5,den0,1,1,-1)
Dy1=covar(nump,denp,1)

% спектрална плътност TODO

% зад 9
%разпределение 4 от таблицата на типовите разпределения
tp=15;
taup=3.5;
w0=taup/tp;
l1=-0.77*w0;
l2=-0.6*w0+j*w0;
l3 = l2';
l4=l1*10;
l5=l1*12;
polc=[l1 l2 l3 l4 l5];
Kp=place(A,B,polc);
L=inv(C*inv(-A+B*Kp)*B);
[eig(A-B*Kp) polc']

