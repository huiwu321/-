clear
data=readmatrix('附件1.xlsx','Sheet','中红外','Range','B1:DXU426');
x=data(1,:);
y=data(2:end,:);
plot(x,y);%查找特异值
y2=data([50:50:400],:);
plot(x,y2);
z=normalize(y,'range');
z2=normalize(y);
dsum=zeros(10,1);
%%
%基于k-means的聚类分析
for k=1:10
    [idx,C,sumd]=kmeans(z,k);
    dsum(k)=sum(sumd);
end
plot(1:10,dsum);
[idx,C,sumd]=kmeans(z,3);
%%
%基于主成分分析的k-means
r=corrcoef(z);
[a1,latent,rate]=pcacov(r);
contr=cumsum(rate);
contr2=contr(1:5);
[a1 z3]=pca(z,NumComponents=3);
for k=1:10
    [idx,C,sumd]=kmeans(z3,k);
    dsum(k)=sum(sumd);
end
plot(1:10,dsum);
[idx,C,sumd]=kmeans(z,3);
%%
%层次分类
Z=linkage(z,"average");
dendrogram(Z,300);
T=cluster(Z,3);


    