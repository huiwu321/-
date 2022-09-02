
clear
data=readmatrix("datatopsis.txt");%读取数据，列向量为对应指标数据
[n,m]=size(data);%n：数据点个数；m:指标个数
a=zeros(n,m);
for i=1:m
    a(:,i)=p1(data(:,i));%指标正向化、无量纲化
end
z=norm_(a);%指标规范化处理，各指标列向量数据的平方和均为1，这步可以去除
w=weight(z);%得到各个指标的权重
[s,I]=topsis(z,w)%根据权重计算排序，s为评价值，I为对应数据点排序（评价值降序排列）


%%
%指标正向化，保证所有指标中的数值为正值且为效益型指标,指标列向量用a表示
%效益型
function y=p1(a) 
         y=(a-min(a))./(max(a)-min(a));%转换后为0-1范围内
end
%成本型
function y=p2(a) 
         y=(max(a)-a)./(max(a)-min(a));%转换后为0-1范围内
end
%区间型：lb为容忍下限，ub为容忍上限，区间内的值为1
function y=p3(qujian,lb,ub,a)
            y=(1-(qujian(1)-a)./(qujian(1)-lb)).*...
                (a>=lb & a<qujian(1))+(a>=qujian(1) & a<=qujian(2))+...
                    (1-(a-qujian(2))./(ub-qujian(2))).*(a>qujian(2) & a<=ub); 
end
%中间型
function y=p4(a,best)
         y=1-abs(a-best)./max(abs(a-best));%转换后为0-1范围内
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








