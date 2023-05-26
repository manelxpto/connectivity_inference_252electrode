probmatrix = zeros(N);
timewindow = 20;

for i = 1:N
    for j = 1:N
        target = cell2mat(spike_times_elec_ms(i));
        ref = cell2mat(spike_times_elec_ms(j));
        probmatrix(i,j) = connprob(target,ref,timewindow);
        disp(['target=',num2str(i),' ref=',num2str(j)]);
    end
end

%% Ploting
% Através de métodos estatísticos no matlab, podemos calcular a probabilidade dos neurónios estarem conectados entre si. 
figure;
ax = axes;

labels = 1:N;
labels_str = int2str(labels);

yticks(labels);
yticklabels(labels_str);
ytickangle(0);

xticks(labels);
xticklabels(labels_str);
xtickangle(90);

imagesc(probmatrix);
colorbar;