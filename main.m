DIR = dir('train_set');
X = [];
C = [];
for i = 3:length(DIR)
    dirname = strcat('train_set/',DIR(i).name);
    disp(dirname);
    AUX_DIR = dir(dirname);
    for j = 3:length(AUX_DIR)
        auxfilename = strcat(dirname,'/',AUX_DIR(j).name);
        aux = double(imread(auxfilename))/255.0;
        d = size(aux);
        X = [X ; reshape(aux,[1,numel(aux)])];
        C = [C ; i-3];
    end
end

[A,E] = fast_NCA(X,C,3,10*size(X,1),25,1e-1);
Y = X*A;

figure;
plot(E);

figure;
a = A(:,2);
a = (a-min(a))/(max(a)-min(a));
imshow(reshape(a,d));

figure;
for i = 3:length(DIR)
    disp(DIR(i).name);
    idx = (C == i-3);
    scatter3(Y(idx,1),Y(idx,2),Y(idx,3),7,C(idx),'filled','MarkerEdgeColor','k','DisplayName',DIR(i).name);
    if i == 3
        hold on;
    end
end
colormap(colorcube);
legend(gca,'show');
hold off;

w = 4;
DIR = dir('coil_100');
X = [];
C = [];
for i = 3:length(DIR)
    dirname = strcat('coil_100/',DIR(i).name);
    disp(dirname);
    AUX_DIR = dir(dirname);
    for j = 3:length(AUX_DIR)        
        auxfilename = strcat(dirname,'/',AUX_DIR(j).name);
        aux = double(imread(auxfilename))/255.0;
        mean_aux  = zeros([size(aux,1)/w,size(aux,2)/w,size(aux,3)]);
        d = size(mean_aux);

        kk = 1;
        ll = 1;
        for k = 1:w:size(aux,1)
            ll = 1;
            for l = 1:w:size(aux,2)
                aux3 = aux(k:k+w-1,l:l+w-1,:);
                mean_aux(kk,ll,:)  = mean(mean(aux3));
                ll = ll + 1;
            end
            kk = kk + 1;
        end
        %d = size(aux2);
        X = [X ; reshape(mean_aux,[1,numel(mean_aux)]) ];
        C = [C ; i-3];
    end
end


[A,E] = fast_NCA(X,C,3,4*size(X,1),50,5e-2);
Y = X*A;

figure;
plot(E);

figure;
a = A(:,1);
a = (a-min(a))/(max(a)-min(a));
imshow(reshape(a,d));

figure;
for i = 3:length(DIR)
    disp(DIR(i).name);
    idx = (C == i-3);
    scatter3(Y(idx,1),Y(idx,2),Y(idx,3),7,C(idx),'filled','MarkerEdgeColor','k','DisplayName',DIR(i).name);
    if i == 3
        hold on;
    end
end
colormap(colorcube);
legend(gca,'show');
hold off;
