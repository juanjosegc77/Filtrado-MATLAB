% Practica 5
% Filtrado analógico y digital
% Juan José Guzmán Cruz

clc
clear all

% ------------------------------------------------------------------------
% 1. Diseñar un filtro Butterworth pasa-bajas con las siguientes
% especificaciones: amax = -15 dB, amin = -1 dB, wp = 0.2pi, ws = 0.3pi,
% utiliza una T de 1, 5 y 10 seg. utiliza el método de invarancia al
% impulso y transformada bilineal, compara la respuesta en frecuencia de
% los filtros para los valores de T.
% ------------------------------------------------------------------------
% 2. Obten la grafica de polos y ceros para cada uno de los valores de T
% ------------------------------------------------------------------------

wp = 0.2*pi; % Banda de paso
ws = 0.3*pi; % Banda de rechazo
Rp = 1; % atenuacion en la banda de paso [dB]
Rs = 15; % atenuacion en la banda de rechazo [dB]

T = [1 5 10];

for i=1:length(T)
    Fs=1/T(i);
    Wp=wp/T(i);
    Ws=ws/T(i);
    
    % Estimación del orden y frecuencia de corte del filtro Butterworth
    % Wn = frecuencia de corte normalizada
    [N,Wn] = buttord(Wp,Ws,Rp,Rs,'s')
    
    % Filtro Butterworth pasa-bajas de orden N y frecuencia de corte wc
    [n,d] = butter(N,Wn,'s');
    H = tf(n,d)
    
    % Filtro digital por invarianza al impulso a partir del filtro Butterworth
    [bz,az] = impinvar(n,d);
    Himp = tf(bz,az)
    
    % Filtro digital por transformación bilineal
    [bd,ad] = bilinear(n,d,1/T(i));
    Hbil = tf(bd,ad)
    
    if (i==1)
            figure(1), freqs(n,d)
            title('Respuesta en frecuencia filtro analógico con T = 1');
            figure(2), freqz(bz,az)
            title('Respuesta en frecuencia filtro digital por invarianza al impulso con T = 1');
            figure(3), freqz(bd,ad);
            title('Respuesta en frecuencia filtro digital por transformacion bilineal con T = 1');
            
            figure(10)
            subplot 331, zplane(n,d)
            title('Polos y ceros filtro analógico T = 1');
            subplot 332, zplane(bz,az)
            title('Polos y ceros invarianza al impulso T = 1');
            subplot 333, zplane(bd,ad)
            title('Polos y ceros transformación bilineal T = 1');
            
    elseif (i==2)
            figure(4), freqs(n,d)
            title('Respuesta en frecuencia filtro analógico con T = 5');
            figure(5), freqz(bz,az)
            title('Respuesta en frecuencia filtro digital por invarianza al impulso con T = 5');
            figure(6), freqz(bd,ad);
            title('Respuesta en frecuencia filtro digital por transformación bilineal con T = 5');
            
            figure(10)
            subplot 334, zplane(n,d)
            title('Polos y ceros filtro analógico T = 5');
            subplot 335, zplane(bz,az)
            title('Polos y ceros invarianza al impulso T = 5');
            subplot 336, zplane(bd,ad)
            title('Polos y ceros transformación bilineal T = 5');
               
    else
            figure(7), freqs(n,d)
            title('Respuesta en frecuencia filtro analógico con T = 10');
            figure(8), freqz(bz,az)
            title('Respuesta en frecuencia filtro digital por invarianza al impulso con T = 10');
            figure(9), freqz(bd,ad);
            title('Respuesta en frecuencia filtro digital por transformación bilineal con T = 10');
            
            figure(10)
            subplot 337, zplane(n,d)
            title('Polos y ceros filtro analógico T = 10');
            subplot 338, zplane(bz,az)
            title('Polos y ceros invarianza al impulso T = 10');
            subplot 339, zplane(bd,ad)
            title('Polos y ceros transformación bilineal T = 10');
    end
        
end

% ------------------------------------------------------------------------
% 4. Ahora diseña un filtro Chebyshev de cualquier tipo, utilizando la 
% transformacion bilineal, para filtrar la señal ECG. 
% ------------------------------------------------------------------------

clear all

N = 4; % orden del filtro
Rp = 1; % rizo permitido en la banda de paso
T = .6; % Periodo de muestreo
Fs = 1/T; % Frecuencia de muestreo
wc = 21; % Frecuencia de corte analógica
Wc = wc*T/pi; % Frecuencia de corte digital normalizada
[n,d] = cheby1(N,Rp,Wc,'s');

[nb,db] = bilinear(n,d,Fs);

% ------------------------------------------------------------------------
% 5. Obten la gráfica de polos y ceros asi como la respuesta en frecuencia
% del filtro diseñado
% ------------------------------------------------------------------------

figure(11), zplane(nb,db)
figure(12), freqz(nb,db)

% ------------------------------------------------------------------------
% 6. Realiza el filtrado del ECG y grafica la señal obtenida mediante una
% serie de impulsos y compara tus resultados obtenidos con el filtrado del
% ECG de la practica anterior
% ------------------------------------------------------------------------

ecg=load('ECG.txt');

% ///// Filtro para la señal ECG de la práctica anterior
N = 4; % orden del filtro
fm = 100; % frecuencia de muestreo
fc = 21; % frecuencia de corte
fcn = 2*pi*fc/fm; % frecuencia de corte, normalizada
[z,p,k] = butter(N,fcn,'s'); % se crea el filtro Butterworth digital

% se obtinen 2 vectores, uno para el numerador y otro para el denominador
% de la función de transferencia
[n,d] = tfdata(zpk(z,p,k), 'v');

% se representa la función de trasferencia
H = tf(n,d);

% Se crea el filtro digital pasa-bajas con respuesta al impulso
[bz,az] = impinvar(n,d);

y=filter(bz,az,ecg);
y1=filter(nb,db,ecg);

figure(13)
subplot 211, plot(y), title('Señal ECG filtrada con el método de invarancia al impulso')
subplot 212, plot(y1), title('Señal ECG filtrada con el método de transformación bilineal')


