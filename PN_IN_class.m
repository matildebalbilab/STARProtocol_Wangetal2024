function PN_IN_class

% Load the information of the trough-to-peak duration and repolarization time of all units 
Stimunits=xlsread('all units.xlsx'); 

% Partition the data into two clusters, and choose the best arrangement out of five initializations.
opts = statset('Display','final');
[idx,C] = kmeans(Stimunits,2,'Distance','cityblock',...
'Replicates',5,'Options',opts);

% Plot the clusters and the cluster centroids
figure;
plot(Stimunits(idx==1,1),Stimunits(idx==1,2),'^','MarkerSize',9,'MarkerEdgeColor',[139 69 19]/255,'MarkerFaceColor',[255 128 0]/255);hold on
plot(Stimunits(idx==2,1),Stimunits(idx==2,2),'o','MarkerSize',9,'MarkerEdgeColor',[46 139 87]/255,'MarkerFaceColor',[25 202 173]/255);hold on
plot(C(:,1),C(:,2),'kx','MarkerSize',15,'LineWidth',3) 
legend('Putative PN','Putative IN','Location','SE')
xlabel('Trough to peak (ms)');ylabel('Repolarizatio time(ms) ')
