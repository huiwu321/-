
clear
data=readmatrix("data14_9_1.txt");
[n,m]=size(data);
a=zeros(n,m);
for i=1:m
    a(:,i)=p1(data(:,i));
end
z=norm_(a);
w=weight(z);
[s,I]=topsis(z,w)


%%
%指标正向化，保证所有指标中的数值为正值且为效益型指标,指标列向量用a表示
%效益型
function y=p1(a) 
         y=(a-min(a))./(max(a)-min(a));
end
%成本型
function y=p2(a) 
         y=(max(a)-a)./(max(a)-min(a));
end
%区间型：lb为容忍下限，ub为容忍上限，区间内的值为1
function y=p3(qujian,lb,ub,a)
            y=(1-(qujian(1)-a)./(qujian(1)-lb)).*...
                (a>=lb & a<qujian(1))+(a>=qujian(1) & a<=qujian(2))+...
                    (1-(a-qujian(2))./(ub-qujian(2))).*(a>qujian(2) & a<=ub); 
end
%中间型
function y=p4(a,best)
         y=1-abs(a-best)./max(abs(a-best));
end
%%
%指标标准化，使各个指标具有相同的表现力
function y=norm_(a) 
         y=a./vecnorm(a);
end
%%
%熵权法得到权重，原始矩阵用data表示,w表示各指标权重
function w=weight(data)
[n,m]=size(data);
p=data./sum(data);
g=zeros(1,m);
for j=1:m
    g(j)=1;
    for i=1:n
        if p(i,j)~=0
            g(j)=g(j)+1/log(n)*p(i,j)*log(p(i,j));
        end
    end
end
w=g./sum(g);
end
%%
%计算综合评价值,由于已经正向化处理了指标，正理想解best和负理想解worst已知
function [s,ind]=topsis(z,w)%ind,s为排序后的序号与权重
[n,~]=size(z);
w=repmat(w,[n,1]);
best=repmat(max(z),[n,1]);
worst=repmat(min(z),[n,1]);
dbest=sqrt(sum(w.*((best-z).^2),2));
dworst=sqrt(sum(w.*((worst-z).^2),2));
s1=dworst./(dbest+dworst);
[s,ind] = sort(s1,'descend');
end








