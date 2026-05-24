clear;
close all;
clc;

% Signal Selection
% 1 = Sine
% 2 = Square
% 3 = Triangle
% 4 = Speech
% 5 = Music

signal_type = 3;

switch signal_type

    case 1
        Fs = 2000;
        t = 0:1/Fs:2;

        % Sine Wave
        x = sin(2*pi*50*t);

        name = 'Sine Wave';

    case 2
        Fs = 2000;
        t = 0:1/Fs:2;

        % Square Wave
        x = square(2*pi*50*t);

        name = 'Square Wave';

   

    case 3
        % Speech Signal
        [x, Fs] = audioread('speech.wav.wav');

        % Stereo to Mono
        if size(x,2) > 1
            x = mean(x,2);
        end

        name = 'Speech Signal';

    case 4
        % Music Signal
        [x, Fs] = audioread('music.wav');

        % Stereo to Mono
        if size(x,2) > 1
            x = mean(x,2);
        end

        name = 'Music Signal';

end

% Time Axis
t = (0:length(x)-1)/Fs;

% Remove DC Component
x_freq = x(:) - mean(x(:));

% Apply Hamming Window
w = hamming(length(x_freq));
x_freq = x_freq .* w;

% FFT Length
N = length(x_freq);

% Zero Padding for Better Resolution
Nfft = 2^nextpow2(N*8);

% FFT Calculation
X = fftshift(fft(x_freq,Nfft));

% Frequency Axis
f = linspace(-Fs/2,Fs/2,Nfft);

% Magnitude Spectrum
mag = abs(X);

% Normalize Magnitude
mag = mag/max(mag);

% Plotting
figure('Position',[100 100 900 600]);

% Time Domain Plot
subplot(2,1,1)
plot(t,x,'b','LineWidth',1.2);
title(['Time Domain - ' name]);
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

% Frequency Domain Plot
subplot(2,1,2)
plot(f,mag,'r','LineWidth',1.2);
title(['Frequency Domain - ' name]);
xlabel('Frequency (Hz)');
ylabel('Normalized Magnitude');
grid on;

xlim([-Fs/2 Fs/2]);

% Practical Bandwidth Calculation

% Threshold = 30% of Maximum Magnitude
threshold = 0.3 * max(mag);

% Frequencies Above Threshold
indices = find(mag > threshold);

if isempty(indices)

    f_low = 0;
    f_high = 0;
    bandwidth = 0;

else

    % Lowest and Highest Significant Frequencies
    f_low = f(indices(1));
    f_high = f(indices(end));

    % Two-Sided Bandwidth
    bandwidth = f_high - f_low;

end

% Display Results
fprintf('\n==== %s ====\n',name);
fprintf('Lowest Frequency  : %.2f Hz\n',f_low);
fprintf('Highest Frequency : %.2f Hz\n',f_high);
fprintf('Bandwidth         : %.2f Hz\n',bandwidth);
