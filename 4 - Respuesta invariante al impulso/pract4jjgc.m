clc
clear all

% Filtrado analógico y digital
% Práctica 4. Respuesta invariante al impulso
% Juan José Guzmán Cruz

% ------------------------------------------------------------------------
% 1. Dada la señal x[n]=u[n]-u[n-15] correspondiente a una entrada escalón,
% grafica dicha señal utilizando 30 muestras; además utiliza un filtro
% Butterworth digital de quinto orden pasa-altas con una frecuencia de
% corte de 1/6 rad/seg; obten la función de transferencia, y la gráfica de
% polos y ceros en el plano Z del filtro y por último obten la señal
% filtrada.
% ------------------------------------------------------------------------

i=1;
for t=1:30
  if t<0 u1(i)=0;
  else u1(i)=1;
  end
  i=i+1;
end

j=1;
for t=1:30
  if t<15 u2(j)=0;
  else u2(j)=1;
  end
  j=j+1;
end

x=u1-u2; % Función x[n]=u[n]-u[n-15]
t=1:30;

figure(1)
stem(t,x),xlabel('t (seg)'),ylabel('x(t)'),
title('x[n]=u[n]-u[n-15]')

[z,p,k] = butter(5,1/6,'high'); % crear filtro Butterworth analógico

% obtener un vector para el numerador y otro para el denominador con los
% coeficientes de los polinomios
[n,d] = tfdata(zpk(z,p,k), 'v');

% se representa la función de trasferencia
H = tf(n,d)

% Se filtra la señal x[n] con el filtro pasaaltas 
y = filter (n,d,x); 

figure (2)
subplot 121, zplane(n,d)
title('Gráfica de polos y ceros, filtro Butterworth'),xlabel('Eje real'),ylabel('Eje imaginario i')
subplot 122, stem (y), title('Señal escalón filtrada')

% ------------------------------------------------------------------------
% 2. Grafica mediante una serie de impulsos la señal de ECG utilizando
% únicamente 250 muestras, la señal fue adquirida a 100 muestras/seg; ahora
% submuestreada la señal a 50, 25 y 10 muestras/seg. Grafica cada una de
% las señales obtenidas y observa el efecto del muestreo.
% ------------------------------------------------------------------------
clear all
s_ecg = load('ECG.txt');
t = [s_ecg(1:250)];

sub50= resample (t,1,100/50);
sub25= resample (t,1,100/25);
sub10= resample (t,1,100/10);

figure (3)
subplot(411), stem(t), title('Señal ECG utilizando 250 muestras')
subplot(412), stem(sub50), title('Señal ECG submuestreada a 50 muestras/seg')
subplot(413), stem(sub25), title('Señal ECG submuestreada a 25 muestras/seg')
subplot(414), stem(sub10), title('Señal ECG submuestreada a 10 muestras/seg')

% ------------------------------------------------------------------------
% 3. Propón un filtro digital para el ECG original observando el espectro
% de la señal.
% ------------------------------------------------------------------------

f_ecg=fftshift(abs (fft(s_ecg).^2));
m=length(f_ecg);
t=1:m;
frec =linspace(-pi,pi,m);

figure (4)
subplot 211, plot(t, s_ecg), title('Señal ECG en el tiempo');
subplot 212, plot(frec, f_ecg), title('Espectro de frecuencia de la señal ECG')

% ///// Filtro para la señal ECG
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

% ------------------------------------------------------------------------
% 4. Del filtro que diseñaste obten la función de trasferencia en el plano
% Z, su respectiva grafica de polos y ceros y su respuesta en frecuencia
% ------------------------------------------------------------------------

figure (5)
zplane(bz,az)
title('Gráfica de polos y ceros, filtro Butterworth'),xlabel('Eje real'),ylabel('Eje imaginario i')
figure (6)
freqz(bz,az), title('Respuesta en frecuencia del filtro')

% ------------------------------------------------------------------------
% 5. Realiza el filtrado del ECG y grafica la señal obtenida mediante una
% serie de impulsos.
% ------------------------------------------------------------------------

y1=filter(bz,az,s_ecg);

figure (7)
stem(y1)

% ------------------------------------------------------------------------
% 6. Compara tus resultados obtenidos, con el filtrado del ECG de la
% practica anterior 
% ------------------------------------------------------------------------

% se filtra la señal de ECG con el filtro pasa-bajas de la practica 3
[a,b] =lsim(H, s_ecg,t);

% Gráficas comparativas entre seal de ECG filtrada con un filtro analógico
% y otro digital
figure(8)
subplot 311, plot(y1,'r'), title('Señal ECG filtrada con filtro digital');
subplot 312, plot(t,a), title('Señal ECG filtrada con filtro analógico');
subplot 313, plot(y1,'r')
hold on
subplot 313, plot(t,a,'--'), title('Gráfico comparativo'),legend({'Filtro digital','Filtro analógico'}, 'Location', 'northwest');