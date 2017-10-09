% clc;
clear all;
load F1.dat;
xb = zeros(4,3,5);
for nnn = 1:1:5
    for nn = 1:1:4
        for n = 1:1:3
            xb(nn,n,nnn) = F1((nnn-1)*4*3*2+(nn-1)*3*2+2*n-1)+F1((nnn-1)*4*3*2+(nn-1)*3*2+2*n)*1j;
        end
    end
end

flag_julixuanda = 1;
if flag_julixuanda
    s2 = reshape(xb(:,:,1),4,3);
    s3 = reshape(xb(:,:,2),4,3);
    s4 = reshape(xb(:,:,3),4,3);
    s5 = reshape(xb(:,:,4),4,3);
    s6 = reshape(xb(:,:,5),4,3);
    s7 = [s2;s3;s4;s5;s6];
    
    s1 = s7(13:3,:);
    % clear xb;
else
    s = reshape(xb(:,:,1),4,3);
    s1 = s(13:3,:);
end
fn = 18;                    
if 1
    xa = s1;
else
    for k = 1:16
        rx_s_err = ec_rx_w_err(fn,1:30).';      %
        xa(k,:) = s1(k,:).*rx_s_err.';         %
    end;
end
clear -regexp ^ec ^gain ^phase;
%% mtd
load mtd_w_0922
mtd_c = mtd_w1;
xb = mtd_c*xa; 
clear -regexp ^ca_w ^mtd_w;

if flag_julixuanda
    [m,n] = max(max(abs(xb')));
    aa = max(max(abs(xb'))); % 最大值
    xc = xb(n,:);
    
    xa = s7(13+4*1:3+4*1,:);
    xb = mtd_c*xa; 
    [m,n] = max(max(abs(xb')));
    bb = max(max(abs(xb'))); % 最大值
    if aa<bb
        aa = bb;
        xc = xb(n,:);
    end
    
    xa = s7(13+4*2:3+4*2,:);
    xb = mtd_c*xa;
    [m,n] = max(max(abs(xb')));
    bb = max(max(abs(xb'))); % 最大值
    if aa<bb
        aa = bb;
        xc = xb(n,:);
    end
    
    xa = s7(13+4*3:3+4*3,:);
    xb = mtd_c*xa; 
    [m,n] = max(max(abs(xb')));
    bb = max(max(abs(xb'))); % 最大值
    if aa<bb
        aa = bb;
        xc = xb(n,:);
    end
    
    xa = s7(13+4*4:3+4*4,:);
    xb = mtd_c*xa; ;
    [m,n] = max(max(abs(xb')));
    bb = max(max(abs(xb'))); % 最大值
    if aa<bb
        aa = bb;
        xc = xb(n,:);
    end
    xb = mtd_c(10,:)*xa; 
else
    [m,n] = max(max(abs(xb')));
    xc = xb(n,:);
end
x2 = xc.';

c = 3e8;
f = ((1215-2.5)+(fn-1)*5)*1e6; 
d = 0.125;
lada = c/f;
%%
N=30;
ts=zeros(1,3);
    s = x2;
 
    Rx=s*s'/N;
    
    v=ones(N,1);
    for i=1:20
        px=Rx*v;
        pD=1/max(abs(px));
        v=px*pD;
%         v=Rx*v/max(abs(Rx*v));
    end
    v = v/norm(v);
    Un = eye(N)-v*v';
    
    theta1 = -20:0.1:-10;  
    theta2 = -20:0.1:-10;
    n = (0:N-1)';
    peakV = zeros(length(theta1),length(theta2));
    peakVR = zeros(length(theta1),length(theta2));
    a = zeros(length(theta1),length(theta2));
    b = zeros(length(theta1),length(theta2));
    a2 = zeros(length(theta1),length(theta2));
    test = zeros(length(theta1),5);
    for k = 1:length(theta1)
        for ki = 1:length(theta2)
            asita1 = exp(1j*n*2*pi*d/lada*sind(theta1(k)));
            asita2 = exp(1j*n*2*pi*d/lada*sind(theta2(ki)));
            B = [asita1,asita2];
            BUn = B'*Un;
            peakV(k,ki) = abs(det(B'*B)/(det(BUn*BUn')+0.0000001));
            peakVR(k,ki) = real(det(B'*B))/real(det(BUn*BUn')+0.0000000000001);
            a(k,ki) = det(B'*B);
            b(k,ki) = det(BUn*BUn');
            a2(k,ki) = abs(det(B'*B))^2;
        end
       	test(k,1) = k;
        test(k,2)=find(peakVR(k,:)==max(peakVR(k,:)));
        test(k,3)=peakVR(k,test(k,2));
        test(k,4) = 102-test(k,2);
        test(k,5) = 101-k+1;
    end
%     figure;
%     mesh(theta2,theta1,peakV(:,:));
%     zlim([1 1.2]);
    [m,n]=find(peakV==max(max(peakV)));
    si1=theta1(m)+15.1     
    si2=theta2(n)+15.1

