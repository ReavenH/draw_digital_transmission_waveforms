% COPYRIGHT Reaven Huang
% Nov. 3rd 2021 0:43
% Change Log: 2022-03-07,删减了set(gca,...,...)语句，所有gca有关的语句都会导致显示不出图像。
clc;
clear;
close all;
%输入原始数字信号
%32K 15位M序列：111101011001000
%digital_signal = [0 0 0 1 1 0 0 1 1 1];
digital_signal = [1 0 1 1];
%digital_signal = [0 0 0 0 0 0 0 0];
dsl = length(digital_signal);

% 单极性不归零码
timeline_NRZ = 0:length(digital_signal) - 1;
disp("输入的数字信号长度：");
disp(timeline_NRZ(end) + 1);
time_SPNRZ = [timeline_NRZ;timeline_NRZ(2:end),timeline_NRZ(end)+1];
time_SPNRZ = time_SPNRZ(:);
level_SPNRZ = [digital_signal;digital_signal];
level_SPNRZ = level_SPNRZ(:);
figure(1);
plot(time_SPNRZ,level_SPNRZ);
grid on;
ylim([-0.25,1.25]);
set(gcf,'position',[500,500,800,200]);
set(gca,'XTick',0:1:length(digital_signal));
set(gca,'YTick',0:1:1);
title('单极性不归零码');

%单极性归零码
timeline_RZ = 0:0.5:length(digital_signal) - 0.5;
time_SPRZ = [timeline_RZ;timeline_RZ(2:end),timeline_RZ(end)+0.5];
time_SPRZ = time_SPRZ(:);
level_SPRZ = [digital_signal;zeros(1,length(digital_signal))];
level_SPRZ = level_SPRZ(:);
% disp(level_SPRZ);
level_SPRZ = [level_SPRZ';level_SPRZ'];
% disp(level_SPRZ);
level_SPRZ = level_SPRZ(:);
% disp(level_SPRZ);
figure(2);
plot(time_SPRZ,level_SPRZ);
grid on;
ylim([-0.25,1.25]);
set(gcf,'position',[500,500,800,200]);
set(gca,'XTick',0:1:length(digital_signal));
set(gca,'YTick',0:1:1);
title('单极性归零码');

% 双极性不归零码
time_DPNRZ = [timeline_NRZ;timeline_NRZ(2:end),timeline_NRZ(end)+1];
time_DPNRZ = time_DPNRZ(:);
level_DPNRZ_raw = 2*(digital_signal - 0.5);
level_DPNRZ = [digital_signal;digital_signal];
level_DPNRZ = level_DPNRZ(:);
level_DPNRZ = 2.*(level_DPNRZ - 0.5);
figure(3);
plot(time_DPNRZ,level_DPNRZ);
grid on;
ylim([-1.25,1.25]);
set(gcf,'position',[500,500,800,200]);
set(gca,'XTick',0:1:length(digital_signal));
set(gca,'YTick',-1:1:1);
title('双极性不归零码');

% 双极性归零码
time_DPRZ = [timeline_RZ;timeline_RZ(2:end),timeline_RZ(end)+0.5];
time_DPRZ = time_DPRZ(:);
level_DPRZ = [2.*(digital_signal-0.5);zeros(1,length(digital_signal))];
level_DPRZ = level_DPRZ(:);
level_DPRZ = [level_DPRZ';level_DPRZ'];
level_DPRZ = level_DPRZ(:);
figure(4);
plot(time_DPRZ,level_DPRZ);
grid on;
ylim([-1.25,1.25]);
set(gcf,'position',[500,500,800,200]);
set(gca,'XTick',0:1:length(digital_signal));
set(gca,'YTick',-1:1:1);
title('双极性归零码');

% 差分码
time_DPD = time_DPNRZ;
level_DPD_temp = [1,zeros(1,length(digital_signal))]; % 初始化
for i = 1:length(digital_signal)
   level_DPD_temp(i+1) = level_DPD_temp(i)*((-1)^digital_signal(i));
end
level_DPD = level_DPD_temp(2:end);
level_DPD_raw = level_DPD;
level_DPD = [level_DPD;level_DPD];
level_DPD = level_DPD(:);
disp("差分相对码（DPD）:");
disp((level_DPD_raw + 1)*0.5);
figure(5);
plot(time_DPD,level_DPD);
grid on;
ylim([-1.25,1.25]);
set(gcf,'position',[500,500,800,200]);
set(gca,'XTick',0:1:length(digital_signal));
set(gca,'YTick',-1:1:1);
title('差分码（设原信号初始为高电平）');

% 数字双相码
time_DDP = time_DPRZ;
level_DDP_temp = [0; 0; level_DPRZ];
level_DDP = level_DPRZ - level_DDP_temp(1:end-2);
figure(6);
plot(time_DDP,level_DDP);
grid on;
ylim([-1.25,1.25]);
set(gcf,'position',[500,500,800,200]);
set(gca,'XTick',0:1:length(digital_signal));
set(gca,'YTick',-1:1:1);
title('数字双相码（Manchester）');

% AMI码
time_AMI = time_DPRZ;
% level_AMI = level_SPRZ; % 初始化
level_AMI = digital_signal; %初始化
for i = 1:length(digital_signal) %得到原始AMI码
    level_AMI(i) = level_AMI(i)*(-1)^(sum(digital_signal(1:i)) - 1);
end
level_AMI_raw = level_AMI; % 储存原始编码
level_AMI = [level_AMI;zeros(1,length(digital_signal))];
level_AMI = level_AMI(:);
level_AMI = [level_AMI';level_AMI'];
level_AMI = level_AMI(:);
figure(7);
plot(time_AMI,level_AMI);
grid on;
ylim([-1.25,1.25]);
set(gcf,'position',[500,500,800,200]);
set(gca,'XTick',0:1:length(digital_signal));
set(gca,'YTick',-1:1:1);
title('AMI码');

% HDB3码
time_HDB3 = time_DPRZ;
level_HDB3 = digital_signal; % 先初始化为原数码
level_VBit = zeros(1,length(digital_signal)); % 初始化V码存储空间
count_V = 0; %初始化计0变量
for i = 2:length(digital_signal) % 创建独立的无符号V码
    if (level_HDB3(i) == 0 && level_HDB3(i - 1) == 0) || (level_HDB3(i) == 0 && level_HDB3(i - 1) == 1) % 记录连续0的个数
        count_V = count_V + 1;
        if count_V == 4
            count_V = 0; % 计数清零
            level_VBit(i) = 1; % 增加初始无符号V码
        end
    else
        count_V = 0; % 遇到非零的就重新计数
    end
end

for i = 1:length(digital_signal) % 将V码交替符号处理
   level_VBit(i) = level_VBit(i)*((-1)^(sum(level_VBit(1:i))-1)); 
end

index_VBit = find(level_VBit); % 返回V码所在的索引

if length(index_VBit) >= 2 % V码的个数能构成所夹部分，即大于等于2时
    for i = 1:length(index_VBit)-1 % 得到加了B码的HDB3码
        if mod(sum(level_HDB3(index_VBit(i):index_VBit(i+1))),2) == 0
            level_HDB3(index_VBit(i+1)-3) = 1;
        end
    end
end

for i = 1:length(digital_signal) % 将B码交替符号处理
   level_HDB3(i) = level_HDB3(i)*((-1)^(sum(level_HDB3(1:i))-1)); 
end

level_HDB3 = level_HDB3 + level_VBit; % 得到完成的HDB3原始编码
level_HDB3_raw = level_HDB3; % 储存原始编码
disp("HDB3码：");
disp(level_HDB3);
level_HDB3 = [level_HDB3;zeros(1,length(digital_signal))];
level_HDB3 = level_HDB3(:);
level_HDB3 = [level_HDB3';level_HDB3'];
level_HDB3 = level_HDB3(:);
figure(8);
plot(time_HDB3,level_HDB3);
grid on;
ylim([-1.25,1.25]);
set(gcf,'position',[500,500,800,200]);
set(gca,'XTick',0:1:length(digital_signal));
set(gca,'YTick',-1:1:1);
title('HDB3码');

% 2PSK调制信号绘图
amp = 1;
resolution = 10000; %可调分辨率，即表示每个码元用的绘图点数
period = 3; %可调每码元宽度的载波周期数
time_unit = 0:resolution - 1; %每一个码元的时间段初始化
time_modulation = zeros(1,resolution*dsl); % 初始化绘图时间轴
level_2PSK = zeros(1,resolution*dsl); % 初始化绘图时间轴对应的码元电平
for i = 1:dsl
    time_modulation((i - 1)*resolution + 1:(i - 1)*resolution + resolution) = (i - 1)*(resolution - 1):(i - 1)*(resolution - 1) + (resolution - 1);
end

carrier = amp*sin(((2*period*pi)/resolution)*time_modulation); % 初始化载波

for i = 1:dsl
    level_2PSK((i - 1)*resolution + 1:(i - 1)*resolution + resolution) = level_DPNRZ_raw(i);
end

level_2PSK = level_2PSK.*carrier;

figure(9);
plot(time_modulation,level_2PSK,'linewidth',1);
grid on;
% set(gcf,'position',[1000,1000,1000,200]);
ylim([-1.25,1.25]);
set(gca,'gridalpha',0.7);
set(gca,'GridColor',[1 0 0]);
x_tag = 0:dsl;
xticks(0:resolution:resolution*(dsl + 1));
xticklabels(x_tag);
set(gca,'YTick',-1:1:1);
title('2PSK调制波形');

% 2DPSK 调制绘图
level_2DPSK = zeros(1,resolution*dsl); % 初始化2DPSK信号
for i = 1:dsl
    level_2DPSK((i - 1)*resolution + 1:(i - 1)*resolution + resolution) = level_DPD_raw(i);
end
level_2DPSK = level_2DPSK.*carrier;

figure(10);
plot(time_modulation,level_2DPSK,'linewidth',1);
grid on;
% set(gcf,'position',[1000,1000,1000,200]);
ylim([-1.25,1.25]);
set(gca,'gridalpha',0.7);
set(gca,'GridColor',[1 0 0]);
xticks(0:resolution:resolution*(dsl + 1));
xticklabels(x_tag); % x_tag 在2PSK中定义了
set(gca,'YTick',-1:1:1);
title('2DPSK调制波形');

% 2DPSK的相干解调绘制

% 绘制原2DPSK调制后波形
figure(11);
subplot(411);
plot(time_modulation,level_2DPSK,'linewidth',1);
grid on;
ylim([-1.25,1.25]);
set(gca,'gridalpha',0.7);
set(gca,'GridColor',[1 0 0]);
xticks(0:resolution:resolution*(dsl + 1));
xticklabels(x_tag); % x_tag 在2PSK中定义了
set(gca,'YTick',-1:1:1);
title('A处：2DPSK调制波形');

% 绘制本地余弦载波
subplot(412);
plot(time_modulation,carrier);
grid on;
ylim([-1.25,1.25]);
set(gca,'gridalpha',0.7);
set(gca,'GridColor',[1 0 0]);
xticks(0:resolution:resolution*(dsl + 1));
xticklabels(x_tag); % x_tag 在2PSK中定义了
set(gca,'YTick',-1:1:1);
title('B处：本地余弦振荡');

%进行相干解调
level_2DPSK_CD = level_2DPSK.*carrier; % CD = coherent demodulation

%绘制相干后的波形
subplot(413);
plot(time_modulation,level_2DPSK_CD);
grid on;
ylim([-1.25,1.25]);
set(gca,'gridalpha',0.7); % 网格不透明度0.7
set(gca,'GridColor',[1 0 0]); % 网格颜色：红色
xticks(0:resolution:resolution*(dsl + 1));
xticklabels(x_tag); % x_tag 在2PSK中定义了
set(gca,'YTick',-2:1:2);
title('C处：2DPSK信号与本振的相干波形');

%进行理想低通滤波并绘制低通滤波之后的波形
frq_2DPSK_CD = fft(level_2DPSK_CD);
amp_2DPSK_CD = abs(frq_2DPSK_CD);
LPF_width = 10; % 设定LPF通带宽度
LPF = [ones(1,LPF_width),zeros(1,dsl*resolution - LPF_width)];
frq_2DPSK_CD = LPF.*frq_2DPSK_CD;
level_2DPSK_CD_LPF = ifft(frq_2DPSK_CD);
amp_2DPSK_CD_LPF = abs(level_2DPSK_CD_LPF);
subplot(414);
plot(time_modulation,level_2DPSK_CD_LPF);
grid on;
ylim([-0.5,0.5]);
set(gca,'gridalpha',0.7); % 网格不透明度0.7
set(gca,'GridColor',[1 0 0]); % 网格颜色：红色
xticks(0:resolution:resolution*(dsl + 1));
xticklabels(x_tag); % x_tag 在2PSK中定义了
set(gca,'YTick',-0.5:0.5:0.5);
title('D处：2DPSK与本振的相干信号通过低通滤波器后波形(相对码)');

% 差分相干解调（DCD）的绘制

%产生时间轴
time_2DPSK_DCD = zeros(1,(dsl + 1)*resolution);
for i = 1:dsl + 1
        time_2DPSK_DCD((i - 1)*resolution + 1:(i - 1)*resolution + resolution) = (i - 1)*(resolution - 1):(i - 1)*(resolution - 1) + (resolution - 1);
end

%对原信号进行延时，设初始为0相位
level_2DPSK_Delayed = [carrier(1:resolution),level_2DPSK];
x_tag_DCD = 1:dsl + 1; % 产生绘图用的横坐标
figure(12);
subplot(411);
plot(time_2DPSK_DCD(1:dsl*resolution),level_2DPSK,'linewidth',1);
grid on;
ylim([-1.25,1.25]);
xlim([0,dsl*resolution + resolution]);
set(gca,'gridalpha',0.7);
set(gca,'GridColor',[1 0 0]);
xticks(0:resolution:resolution*(dsl + 2));
xticklabels(x_tag_DCD); % x_tag 在2PSK中定义了
set(gca,'YTick',-1:1:1);
title('A处：2DPSK调制波形');

% 绘制差分延迟信号
subplot(412);
plot(time_2DPSK_DCD,level_2DPSK_Delayed);
grid on;
ylim([-1.25,1.25]);
set(gca,'gridalpha',0.7);
set(gca,'GridColor',[1 0 0]);
xticks(0:resolution:resolution*(dsl + 2));
xticklabels(x_tag_DCD); % x_tag 在2PSK中定义了
set(gca,'YTick',-1:1:1);
title('B处：原信号进行差分延迟1个码元持续时间后的信号');

%进行相干解调
level_2DPSK_DCD = [level_2DPSK,zeros(1,resolution)].*level_2DPSK_Delayed; % CD = coherent demodulation

%绘制相干后的波形
subplot(413);
plot(time_2DPSK_DCD,level_2DPSK_DCD);
grid on;
ylim([-1.25,1.25]);
set(gca,'gridalpha',0.7); % 网格不透明度0.7
set(gca,'GridColor',[1 0 0]); % 网格颜色：红色
xticks(0:resolution:resolution*(dsl + 2));
xticklabels(x_tag_DCD); % x_tag 在2PSK中定义了
set(gca,'YTick',-2:1:2);
title('C处：2DPSK信号与自身差分信号的相干波形');

%进行理想低通滤波并绘制低通滤波之后的波形
frq_2DPSK_DCD = fft(level_2DPSK_DCD);
amp_2DPSK_DCD = abs(frq_2DPSK_DCD);
LPF_DCD_width = 10; % 设定LPF通带宽度
LPF_DCD = [ones(1,LPF_DCD_width),zeros(1,(dsl + 1)*resolution - LPF_DCD_width)];
frq_2DPSK_DCD = LPF_DCD.*frq_2DPSK_DCD;
level_2DPSK_DCD_LPF = ifft(frq_2DPSK_DCD);
amp_2DPSK_DCD_LPF = abs(level_2DPSK_DCD_LPF);
subplot(414);
plot(time_2DPSK_DCD(1:dsl*resolution),level_2DPSK_DCD_LPF(1:dsl*resolution));
grid on;
xlim([0,(dsl + 1)*resolution]);
ylim([-0.5,0.5]);
set(gca,'gridalpha',0.7); % 网格不透明度0.7
set(gca,'GridColor',[1 0 0]); % 网格颜色：红色
xticks(0:resolution:resolution*(dsl + 2));
xticklabels(x_tag_DCD); % x_tag 在2PSK中定义了
set(gca,'YTick',-0.5:0.5:0.5);
title('D处：2DPSK与自身差分信号的相干信号通过低通滤波器后波形（绝对码）');


% 4PSK 调制的绘制

% 进制转换（普适性）
scale = 4;
division = log2(scale);
level_nPSK_bin = reshape(digital_signal,[int8(division),dsl / int8(division)])'; % n进制API保留
level_nDPSK_bin = reshape(level_DPD_raw,[int8(division),dsl / int8(division)])';
% 产生时间轴
time_4PSK = zeros(1,resolution*dsl/division);
for i = 1:dsl / division
        time_4PSK((i - 1)*resolution + 1:(i - 1)*resolution + resolution) = (i - 1)*(resolution - 1):(i - 1)*(resolution - 1) + (resolution - 1);
end

level_4PSK_bin = level_nPSK_bin; % n进制形式，每行用二进制表示n进制里的一个数
exponent = zeros(dsl / division, division); % 初始化指数矩阵
exponent_temp = zeros(1,division);
for i = 1:division
    exponent_temp(i) = division - i;
end
for i = 1:dsl / division
    exponent(i,1:division) = exponent_temp; % 给指数矩阵赋值
end
level_4PSK_dec = level_4PSK_bin.*(2.^exponent); % 都转换为十进制，第一步：求指数
level_4PSK_dec = sum(level_4PSK_dec , 2); % 都转换为十进制，第二部：按行求和

level_4PSK = zeros(1,dsl*resolution / division); % 初始化绘图用的4PSK向量

for i = 1:dsl/division
    level_4PSK((i - 1)*resolution + 1:(i - 1)*resolution + resolution) = level_4PSK_dec(i); % 十进制
end

% 计算相位因子
radian_unit = (2*pi)/scale ;
coeff = 0:scale - 1;
coeff = (-1).^(coeff + 1);
radian_divide = 0:radian_unit:2*pi - radian_unit;
switch_table = coeff .*(radian_divide);
phase_switch = zeros(1,dsl*resolution/division);
for i = 1:dsl*resolution/division
    phase_switch(i) = sum(switch_table(1:level_4PSK(i)+1));
end

% for i = 1 : dsl/division
%    level_4PSK((i - 1)*resolution + 1:(i - 1)*resolution + resolution) = cos((2*pi + sum(switch_table(1:level_4PSK_dec(i)+1))).*time_modulation(1:resolution));
% end

for i = 1:dsl/division
   level_4PSK((i - 1)*resolution + 1:(i - 1)*resolution + resolution) = cos((2*pi).*time_4PSK(1:resolution)/(resolution - 1) + phase_switch(i*resolution)); 
end
% level_4PSK = cos((2*pi + phase_switch).*(time_4PSK / resolution));

figure(13);
plot(time_4PSK,level_4PSK);
grid on;
% set(gcf,'position',[1000,1000,1000,200]);
ylim([-1.25,1.25]);
set(gca,'gridalpha',0.7);
set(gca,'GridColor',[1 0 0]);
xticks(0:resolution:resolution*(dsl/division + 1));
xticklabels(x_tag); % x_tag 在2PSK中定义了
set(gca,'YTick',-1:1:1);
title('4PSK调制波形');

% 4DPSK 调制波形的绘制
level_4DPSK_bin = level_nDPSK_bin;
level_4DPSK_dec = level_4DPSK_bin.*(2.^exponent); % 都转换为十进制，第一步：求指数
level_4DPSK_dec = sum(level_4DPSK_dec , 2); % 都转换为十进制，第二部：按行求和
level_4DPSK = zeros(1,dsl*resolution / division); % 初始化绘图用的4DPSK向量

for i = 1:dsl/division
    level_4DPSK((i - 1)*resolution + 1:(i - 1)*resolution + resolution) = level_4DPSK_dec(i); % 十进制
end

phase_switch_DPSK = zeros(1,dsl*resolution/division);
for i = 1:dsl*resolution/division
    phase_switch_DPSK(i) = sum(switch_table(1:level_4DPSK(i)+1));
end

for i = 1:dsl/division
   level_4DPSK((i - 1)*resolution + 1:(i - 1)*resolution + resolution) = cos((2*pi).*time_4PSK(1:resolution)/(resolution - 1) + phase_switch_DPSK(i*resolution)); 
end

figure(14);
plot(time_4PSK,level_4DPSK);
grid on;
% set(gcf,'position',[1000,1000,1000,200]);
ylim([-1.25,1.25]);
set(gca,'gridalpha',0.7);
set(gca,'GridColor',[1 0 0]);
xticks(0:resolution:resolution*(dsl/division + 1));
xticklabels(x_tag); % x_tag 在2PSK中定义了
set(gca,'YTick',-1:1:1);
title('4DPSK调制波形');

% 2ASK 调制波形
level_2ASK = zeros(1,resolution*dsl);
for i = 1:dsl
    level_2ASK((i - 1)*resolution + 1:(i - 1)*resolution + resolution) = digital_signal(i);
end
level_2ASK = level_2ASK.*carrier*10 + (-level_2ASK + 1).*carrier*5;
figure(15);
plot(time_modulation,level_2ASK,'linewidth',1);
grid on;
ylim([-12.5,12.5]);
set(gca,'gridalpha',0.7);
set(gca,'GridColor',[1 0 0]);
x_tag = 0:dsl;
xticks(0:resolution:resolution*(dsl + 1));
xticklabels(x_tag);
set(gca,'YTick',-12:1:12);
title('2ASK调制波形');

% 2FSK 调制波形
% 0的频率是1的2倍
for i = 1:dsl
    level_2FSK((i - 1)*resolution + 1:(i - 1)*resolution + resolution) = digital_signal(i);
end
carrier0 = amp*sin(((2*2*period*pi)/resolution)*time_modulation); % 初始化载波
level_2FSK = level_2FSK.*carrier + (-level_2FSK + 1).*carrier0;
figure(16);
plot(time_modulation,level_2FSK,'linewidth',1);
grid on;
ylim([-1.25,1.25]);
set(gca,'gridalpha',0.7);
set(gca,'GridColor',[1 0 0]);
x_tag = 0:dsl;
xticks(0:resolution:resolution*(dsl + 1));
xticklabels(x_tag);
set(gca,'YTick',-1:1:1);
title('2FSK调制波形');