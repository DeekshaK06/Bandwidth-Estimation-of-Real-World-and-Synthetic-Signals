clear;
close all;
clc;

signal_type = 4;   % 1=Sine, 2=Square, 3=Rect, 4=Speech

switch signal_type

    case 1
        Fs = 2000;
        t = 0:1/Fs:2;
        x = sin(2*pi*50*t);
        name = 'Sine Wave';

    case 2
        Fs = 2000;
        t = 0:1/Fs:2;
        x = square(2*pi*50*t);
        name = 'Square Wave';

    case 3
        Fs = 2000;
        t = 0:1/Fs:2;
        x = rectpuls(t-1,0.3);
        name = 'Rectangular Pulse';

    case 4
        [x, Fs] = audioread('speech.wav.wav');
        if size(x,2) > 1
            x = mean(x,2);
        end

        name = 'Speech Signal';
end
x_time = x;
t = (0:length(x_time)-1)/Fs;

x_freq = x(:) - mean(x(:));     

w = hamming(length(x_freq));    

x_freq = x_freq .* w;           

N = length(x_freq);
Nfft = 2^nextpow2(N*8);

X = fftshift(fft(x_freq, Nfft));
f = linspace(-Fs/2, Fs/2, Nfft);

mag = abs(X);
mag = mag / max(mag);

figure('Position',[100 100 900 600]);

subplot(2,1,1)
plot(t, x_time, 'b');
title(['Time Domain - ' name]);
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

subplot(2,1,2)
plot(f, mag, 'r', 'LineWidth',1.2);
title(['Frequency Domain - ' name]);
xlabel('Frequency (Hz)');
ylabel('Normalized Magnitude');
grid on;
xlim([-4000 4000]);

pos_idx = f >= 0;
f_pos = f(pos_idx);
mag_pos = mag(pos_idx);

threshold = 0.1 * max(mag_pos);

indices = find(mag_pos > threshold);

if isempty(indices)
    f_low = 0;
    f_high = 0;
    bandwidth = 0;
else
    f_low = f_pos(indices(1));
    f_high = f_pos(indices(end));
    bandwidth = f_high - f_low;
end

fprintf('\n==== %s ====\n', name);
fprintf('Lowest Frequency  : %.2f Hz\n', f_low);
fprintf('Highest Frequency : %.2f Hz\n', f_high);
fprintf('Bandwidth         : %.2f Hz\n', bandwidth);
