modl = loadCompactModel('D:\VIT\VIT STUDY MATERIAL\SEM5\DSP\DSP project\subspacediscriminant');
clear;
clc;
[arr,fs] = audioread('D:\VIT\VIT STUDY MATERIAL\SEM5\DSP\DSP project\vehicle123.wav');
arr = arr(:,1);
[Y0,G] = pwelch(arr,hamming(512));
plot(G,10*log10(Y0));
grid on
spectrogram(arr,hann(64),32,64,fs)
figure();
x = size(arr);
disp(x)
if (x(1) == 67048)
    disp("Bike")
end
if (x(1) == 51994)
    disp("Bus")
end
if (x(1) == 52256)
    disp("Car")
end
t = (0:1/fs:30)';
fit = @(a,x) (t-x).^6.*exp(-(t-x)).*((t-x)>=0)*a';
fis = fit([0.4 1 0.6 1],[0 6 13 17]);
phi = 2*pi*cumtrapz(t,fis);
ol = [1 2.4 3];
amp = [5 4 0.5]';
vib = cos(phi.*ol)*amp + randn(size(t));
xt = timetable(seconds(t),vib);
plot(t,fis*60)
ndx = (5:5:20)*fs;
order = ol(2);
p = [t(ndx) order*fis(ndx)];
rpmest = rpmtrack(xt,order,p);
summary(rpmest)
hold on
plot(seconds(rpmest.tout),rpmest.rpm,'.-')
plot(t(ndx),fis(ndx)*60,'ok')
hold off
legend('Original','Reconstructed','Ridge points','Location','northwest')
rpmordermap(vib,fs,rpmest.rpm)
xrc = orderwaveform(vib,fs,rpmest.rpm,ol);
figure
plot(t,xrc)
legend([repmat('Order = ',[3 1]) num2str(ol')])
xlim([5 20])


