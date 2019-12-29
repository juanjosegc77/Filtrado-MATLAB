% Práctica 6. 
% Filtrado analógico y digital
% Juan José Guzmán Cruz

clc
clear all;

% ------------------------------------------------------------------------
% 1. Grafica en el tiempo y en la frecuencia las siguientes ventanas.
% Utiliza una longitud de 64 muestras para cada una de ellas.
% Compara los resultados obtenidos de cada ventana.
% ------------------------------------------------------------------------

M = 64;

% Ventana Hamming
Ham = hamming(M);

% Ventana Blackman
Bla = blackman(M);

% Ventana Hanning
Han = hann(M);

% Ventana Chebyshev
Che = chebwin(M);

% Ventana Gaussiana
Gau = gausswin(M);

% Ventana Bartlett-Hanning
BHa = barthannwin(M);

% Respuesta en frecuencia
figure (1), freqz(Ham,1), title('Respuesta en frecuencia de la ventana Hamming')
figure (2), freqz(Bla,1), title('Respuesta en frecuencia de la ventana Blackman')
figure (3), freqz(Han,1), title('Respuesta en frecuencia de la ventana Hanming')
figure (4), freqz(Che,1), title('Respuesta en frecuencia de la ventana Chebyshev')
figure (5), freqz(Gau,1), title('Respuesta en frecuencia de la ventana Gaussiana')
figure (6), freqz(BHa,1), title('Respuesta en frecuencia de la ventana Bartlett-Hanning')

%Comparando en el dominio del tiempo
t = 0:M-1;
figure(7)

plot(t,Ham), hold on
plot(t,Bla, 'r'), hold on
plot(t,Han, 'y--', 'LineWidth', 2), hold on
plot(t,Che, 'g'), hold on
plot(t,Gau, 'c', 'LineWidth', 2), hold on
plot(t,BHa, 'k')
legend({'Hamming','Blackman','Hanning','Chebyshev','Gaussiana','Bartlett-Hanning'},'Location','Southeast')
title('Ventanas en el tiempo') ,xlabel('t [s]'), ylabel('V(n)')
       
% ------------------------------------------------------------------------
% 2. Diseña un filtro FIR pasa-banda de orden igual a 44, con una frecuencia
% de corte de 0.3*pi a 0.7*pi, utiliza todas las ventanas del ejercicio
% anterior. Se recomienda utilizar la función FIR1 de MATLAB.
% ------------------------------------------------------------------------

N = 44;
Wn = [0.3 0.7];

fHam  =  fir1 (N, Wn, 'DC-1', hamming(N+1));
fBla  =  fir1 (N, Wn,'DC-1', blackman(N+1));
fHan  =  fir1 (N, Wn, 'DC-1', hann(N+1));
fChe  =  fir1 (N, Wn, 'DC-1', chebwin(N+1));
fGau  =  fir1 (N, Wn, 'DC-1', gausswin(N+1));
fBHa  =  fir1 (N, Wn, 'DC-1', barthannwin(N+1));

% ------------------------------------------------------------------------
% 3. Ahora obten la respuesta en frecuencia del filtro diseñado para cada
% ventana, compara y comenta los resultados obtenidos.
% ------------------------------------------------------------------------

figure(8), freqz (fHam, 1)
title('Respuesta en frecuencia del filtro FIR pasa-banda con ventana Hamming')

figure(9), freqz (fBla, 1)
title('Respuesta en frecuencia del filtro FIR pasa-banda con ventana Blackman')

figure(10), freqz (fHan, 1)
title('Respuesta en frecuencia del filtro FIR pasa-banda con ventana Hanning')

figure(11), freqz (fChe, 1)
title('Respuesta en frecuencia del filtro FIR pasa-banda con ventana Chebyshev')

figure(12), freqz (fGau, 1)
title('Respuesta en frecuencia del filtro FIR pasa-banda con ventana Gaussiana')

figure(13), freqz (fBHa, 1)
title('Respuesta en frecuencia del filtro FIR pasa-banda con ventana Bartlett-Hanning')

% ------------------------------------------------------------------------
% 4. Ahora diseña un filtro FIR uilizando por lo menos 2 tipos de ventana
% diferente para filtrar la señal de ECG.
% ------------------------------------------------------------------------

N = 50; % orden del filtro
Fm = 100; % frecuencia de muestreo de la señal ECG
Fs = 21; % frecuencia de corte a filtrar
Wn = Fs/(Fm/2); % frecuencia de corte normalizada

% Filtro con ventana Hamming
Ham =  fir1(N, Wn, hamming(N+1)); 

% Filtro con ventana Bartlett-Hanning
BHa  = fir1 (N,Wn, barthannwin(N+1));

% ------------------------------------------------------------------------
% 5. Obten la respuesta en frecuencia de los filtros diseñados.
% ------------------------------------------------------------------------
figure(14)
freqz(Ham)
title('Respuesta en frecuencia del filtro FIR pasa-banda con ventana Hamming diseñado para filtrar la señal ECG')

figure(15)
freqz(BHa)
title('Respuesta en frecuencia del filtro FIR pasa-banda con ventana Bartlett-Hanning diseñado para filtrar la señal ECG')

% ------------------------------------------------------------------------
% 6. Realiza el filtrado del ECG y grafica la señal obtenida mediante una
% serie de impulsos, compara tus resultados obtenidos con cada una de las
% ventanas utilizadas y también con el filtrado del ECG de la práctica
% donde utilizaste la transformada bilineal y la respuesta invariante al
% impulso.
% ------------------------------------------------------------------------

ecg=load('ECG.txt');
x = 1:length(ecg);

% ///// Filtro para la señal ECG de la practica anterior
N = 4; % orden del filtro
Fm = 100; % frecuencia de muestreo
Fc = 21; % frecuencia de corte
Fcn = 2*pi*Fc/Fm; % frecuencia de corte, normalizada
[z,p,k] = butter(N,Fcn,'s'); % se crea el filtro Butterworth digital
[n,d] = tfdata(zpk(z,p,k), 'v');

[bz,az] = impinvar(n,d);
[nb,db] = bilinear(n,d,Fm);

y=filter(bz,az,ecg);
y1=filter(nb,db,ecg);
y2=filter(Ham, 1, ecg);
y3=filter(BHa, 1, ecg);

figure(16)
subplot 411, plot(y), title('Señal ECG filtrada con el metodo de invarancia al impulso')
subplot 412, plot(y1), title('Señal ECG filtrada con el metodo de transformacion bilineal')
subplot 413, plot(y2), title('Señal ECG filtrada usando una ventana Hamming')
subplot 414, plot(y3), title('Señal ECG filtrada usando una ventana Bartlett-Hanning')
