% Filtrado Analógico y Digital T 13-I
% Práctica 3. Diseño de filtros con MATLAB
% Juan José Guzmán Cruz

clc
% --------------------------------------------------------------------
% 1. Diseña un filtro pasa-banda Butterworth de cuarto orden con
% frecuencias de corte de 40 y 80 Hz, y un filtro Chebychev del tipo I del
% mismo orden y frecuencias de corte, con un rizo permisible en la banda de
% pasp de 0.3 dB, ambos con ganancia unitaria.
% --------------------------------------------------------------------

% ///// Filtro rechaza-banda Butterworth de 4 orden
clear all
N = 4; % orden del filtro
fm = 500; % frecuencia de muestreo
fc1 = 40; % frecuencia de corte 1
fcn1 = 2*pi*fc1/fm; % frecuencia de corte 1, normalizada
fc2 = 80; % frecuencia de corte 2
fcn2 = 2*pi*fc2/fm; % frecuencia de corte 2, normalizada

[z1,p1,k1] = butter(N,[fcn1,fcn2],'stop','s') % se crea el filtro Butterworth

% se obtinen 2 vectores, uno para el numerador y otro para el denominador
% de la función de transferencia
[n1,d1] = tfdata(zpk(z1,p1,k1), 'v')

% se representa la función de trasferencia
H1 = tf(n1,d1)

% ///// Filtro rechaza-banda Chebyshev tipo I de 4 orden
% ///// Nota: se utilizan los mismos parámetros del filtro Butterworth
R = 0.3 % rizo permisible en la banda de paso
[z2,p2,k2] = cheby1(N,R,[fcn1,fcn2],'stop','s') % se crea el filtro Chebyshev

% se obtinen 2 vectores, uno para el numerador y otro para el denominador
% de la función de transferencia
[n2,d2] = tfdata(zpk(z2,p2,k2), 'v')

% se representa la función de trasferencia
H2 = tf(n2,d2)

% --------------------------------------------------------------------
% 2. Obten la gráfica de polos y ceros de la funciones de transferencia de
% cada filtro, además grafica y compara la respuesta en frecuencia de ambos
% filtros
% --------------------------------------------------------------------

% ///// Gráficas de polos y ceros
figure(1)
subplot 211
pzmap(H1),title('Gráfica de polos y ceros, filtro Butterworth'),xlabel('Eje real'),ylabel('Eje imaginario i')
subplot 212
pzmap(H2),title('Gráfica de polos y ceros, filtro Chebyshev'),xlabel('Eje real'),ylabel('Eje imaginario i')

% ///// Gráficas de respuesta en frecuencia
figure(2), bode(H1,'r',H2,'b+'),grid

% --------------------------------------------------------------------
% 3. Gráfica en el tiempo y la frecuencia la señal de ECG y FCG 
% --------------------------------------------------------------------
clear all
% ///// se carga la señal de ECG discretizada
ecg=load('ECG.txt');

f_ecg=fftshift(abs (fft(ecg).^2));
m1=length(f_ecg);
t1=1:m1;
frec =linspace(-pi,pi,m1);

figure (3)
subplot 221, plot(t1,ecg), title('Señal ECG en el tiempo');
subplot 222, plot(frec, f_ecg), title('Espectro de frecuencia de la señal ECG')

% ///// se carga la señal de FCG discretizada
fcg=load('FCG.txt');
f_fcg=fftshift(abs (fft(fcg).^2));
m2=length(f_fcg);
t2=1:m2;
frec =linspace(-pi,pi,m2);

subplot 223, plot(t2,fcg), title('Seal FCG en el tiempo');
subplot 224, plot(frec, f_fcg), title('Espectro de frecuencia de la señal FCG')

% --------------------------------------------------------------------
% 4. Diseña un filtro para la señal de ECG y FCG observando el espectro
% obtenido de cada señal
% --------------------------------------------------------------------

% ///// Filtro para la señal ECG
N = 4; % orden del filtro
fm1 = 100; % frecuencia de muestreo
fc1 = 21; % frecuencia de corte 1
fcn1 = 2*pi*fc1/fm1; % frecuencia de corte 1, normalizada
[z1,p1,k1] = butter(N,fcn1,'s'); % se crea el filtro Butterworth

% se obtinen 2 vectores, uno para el numerador y otro para el denominador
% de la función de transferencia
[n1,d1] = tfdata(zpk(z1,p1,k1), 'v');

% se representa la función de trasferencia
H1 = tf(n1,d1);


% ///// Filtro para la señal FCG
N = 6; % orden del filtro
fm2 = 100; % frecuencia de muestreo
fc2 = 3.2; % frecuencia de corte 2
fcn2 = 2*pi*fc2/fm2; % frecuencia de corte 2, normalizada
fc3 = 7.6; % frecuencia de corte 2
fcn3 = 2*pi*fc3/fm2; % frecuencia de corte 2, normalizada
[z2,p2,k2] = butter(N,[fcn2,fcn3],'s'); % se crea el filtro Butterworth

% se obtinen 2 vectores, uno para el numerador y otro para el denominador
% de la función de transferencia
[n2,d2] = tfdata(zpk(z2,p2,k2), 'v');

% se representa la función de trasferencia
H2 = tf(n2,d2);

% --------------------------------------------------------------------
% 5. Obten la respuesta en frecuencia del filtro diseado para la señal de
% ECG y FCG.
% --------------------------------------------------------------------

figure(4)
subplot 121, bode(H1),grid
subplot 122, bode(H2),grid

% --------------------------------------------------------------------
% 6. Realiza el filtrado del ECG y FCG, en ambos casos grafica los
% resultados obtenidos de la señal original y la filtrada
% --------------------------------------------------------------------

% se filtra la señal de ECG con el filtro pasa-bajas
figure(5)
subplot 411, plot(t1,ecg), title('Señal ECG en el tiempo');
[a1,b1] =lsim(H1, ecg,t1);
subplot 412, plot(t1,a1), title('Señal ECG filtrada');

% se filtra la señal de FCG con el filtro pasa-bajas
figure(7)
subplot 413, plot(t2,fcg), title('Señal FCG en el tiempo');
[a2,b2]=lsim(H2, fcg,t2);
subplot 414, plot(t2,a2), title('Señal FCG filtrada');