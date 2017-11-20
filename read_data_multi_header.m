%%% created by Chandler 20Sep2017
clc;
clear;
tic;

%%  use the scan method - load all data including the string into one cell
% fid=fopen('data.txt','r');
% temp=textscan(fid,'%s');
% % ====== count the number and coordinate
% length=size(temp{1});
% nodes=length(1,1);
%
% header_n=27;
% freq_n=1102;
% nodes=nodes/(freq_n*2+header_n); % header:27 freq:1102 data:1102
%
% freq=zeros(1,freq_n);
% data=zeros(nodes,freq_n);
% for ii=header_n+1:header_n+freq_n
%     freq(ii-header_n) = str2double(temp{1}{ii});
% end
% header = cell(1,nodes);
% for jj=1:nodes
%     header{jj} = temp{1}{1+(jj-1)*(header_n+freq_n*2)}; %header char
%     for ii = (jj-1)*(header_n+freq_n*2)+header_n+freq_n+1 : jj*(header_n+freq_n*2)
%         data(jj,ii-((jj-1)*(header_n+freq_n*2)+header_n+freq_n)) = str2double(temp{1}{ii});
%     end
% end
%
% fclose(fid);
% clear temp;

%% another faster method - read every line
fid=fopen('data 2017-10-16.txt','r');
i=1;
while feof(fid)==0
    tline{i,1}=fgetl(fid);
    i=i+1;
end
fclose(fid);

nodes=(i-1)/3;
header_n=27;
freq_n=1102;
freq=zeros(1,freq_n);
data=zeros(nodes,freq_n);
header = cell(1,nodes);

freq = str2num(tline{2});

for ii=1:nodes
    temp=regexp(tline{1+(ii-1)*3},' ','split');
    header{ii}=temp{1};
    data(ii,:) = str2num(tline{ii*3});
end

%% calculate the acoustic power amplitude of a frequency range
f1 = input('Please input the start freq you consider f1: ');
f2 = input('Please input the end freq you consider f2: ');
f1_L=find(freq==f1);
f2_L=find(freq==f2);

pressure = zeros(nodes,1);
power_data = data.^2;
pressure = sqrt( sum(power_data,2)/(f2_L-f1_L) );


%% pcolor of the scan
N = sqrt(nodes);
% reshape the pressure vector to matrix
P = zeros(N);
for ii=1:N
    P(ii,1)=pressure(ii);
    P(ii,2:end)=pressure(31+(ii-1)*(N-1):30+ii*(N-1));
end
figure;pcolor(P);colorbar;shading interp;
% caxis([30 100])
set(gca,'FontSize',12);title(['2D Scan Frequency Range: ',num2str(f1),'Hz - ',num2str(f2),'Hz'],'FontSize',12);
xlabel('X scan range(mm)','FontSize',12);ylabel('Y scan range(mm)','FontSize',12);

saveas(gcf,['2D holography scan_',num2str(f1),'-',num2str(f2),'Hz.jpg']);
pause

%% contour the scan
figure;
h1 = axes('units','normalized');
im_base=imread('berlin60.jpg');         % first, we need a base figure
image(im_base);
set(h1,'handlevisibility','off','visible','off'); %clear the axis of figure

contourf(P);colorbar('position',[0.92 0.11 0.03 0.81])
set(gca,'color','none','FontSize',12);
title(['2D Scan Frequency Range: ',num2str(f1),'Hz - ',num2str(f2),'Hz'],'FontSize',12);
xlabel('X scan range(mm)','FontSize',12);ylabel('Y scan range(mm)','FontSize',12);
saveas(gcf,['2D holography contour_',num2str(f1),'-',num2str(f2),'Hz.jpg']);

close all;

toc
