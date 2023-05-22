Fs = 8192;
f_c = 1000;
bits_to_send = StringToBits('“Here’s how I try to look at it, and this is just me: this guy being the president, it’s like there’s a horse loose in a hospital,” Mulaney says. “I think eventually everything’s going to be okay, but I have no idea what’s going to happen next. And neither do any of you, and neither do your parents, because there’s a horse loose in the hospital!');
msg_length = length(bits_to_send)/8;
SymbolPeriod = 100;

% convert the vector of 1s and 0s to 1s and -1s
m = 2*bits_to_send-1;
% create a waveform that has a positive box to represent a 1
% and a negative box to represent a zero
m_us = upsample(m, SymbolPeriod);
m_boxy = conv(m_us, ones(SymbolPeriod, 1));
% figure()
% plot(m_boxy); % visualize the boxy signal
% title('m(t)')

% create a cosine with analog frequency f_c
c = cos(2*pi*f_c/Fs*[0:length(m_boxy)-1]');
% create the transmitted signal
x_tx = m_boxy.*c;
% figure()
% plot(x_tx)  % visualize the transmitted signal
% title('x(t)')
% figure()
% plot_ft_rad(x_tx, Fs)
% title('X(jw)')

% create  noise-like signal 
% to synchronize the transmission
% this same noise sequence will be used at
% the receiver to line up the received signal
% This approach is standard practice is real communications
% systems.
randn('seed', 1234);
x_sync = randn(Fs/4,1);
x_sync = x_sync/max(abs(x_sync))*0.5;
% stick it at the beginning of the transmission
x_tx = [x_sync;x_tx];
save data/horse.mat x_sync Fs msg_length
% write the data to a file
audiowrite('data/horse.wav', x_tx, Fs);


