function unit_CCG(filename)
    % Combine the firing events timestamps (the spike train) of each cell from different brain regions by saving each spike train as a cell array of a .mat file called ‘all_unit.mat’ Can you provide an example of this file with data organization?
load([filename '.mat'],'unit_t')  
% Generate the CCG for each pair of all the units. 
    for i=1:size(unit_t,2)
        for j=1:size(unit_t,2)    
            for c=1:1000     % Calculate and plot the jittered CCG
                m=zeros(1000,101);
                new_unit_t = unit_t{i} + 0.01*randn(size(unit_t{i})); %jittered signal 
                [tsOffsets, ~, ~] = crosscorrelogram(new_unit_t, unit_t{j}, [-0.025 0.025]);
                % temporal shift within a range of -25 to 25 ms     
                h1=histogram(tsOffsets,101);%0.5 ms interval
                m(c,:)=h1.Values;xlim([-0.025 0.025]);hold on
            end
            xlabel('Lag (ms)');ylabel('Counts')            
            % Calculate and plot the real CCG
            [tsOffsets1, ~, ~] = crosscorrelogram(unit_t{i}, unit_t{j}, [-0.025 0.025]);
            figure(2);
            h2=histogram(tsOffsets1,101);counts1=h2.Values;xlim([-0.025 0.025]); hold on      
          
            % Calculate and plot 1% and 99% confidential interval
            for n=1:101
                CI=zeros(101,3);
                CI(n,:)=poissinv([0.01,0.5,0.99],mean(m(:,n)));
            end
            plot((-0.025:0.05/100:0.025),CI(:,1),'m--','Linewidth',1)
            plot((-0.025:0.05/100:0.025),CI(:,2),'c','Linewidth',1)
            plot((-0.025:0.05/100:0.025),CI(:,3),'m--','Linewidth',1)
           xlim([-0.025 0.025]);  xlabel('Lag (ms)');ylabel('Counts')
            % Define if the synaptic connection is excitatory or inhibitory 
            window=counts1(1,50:57)'; % Get the 4 ms window
            % Excitatory connection
            CI_window_up=CI(50:57,3); peak=sum(window>CI_window_up);
            z=(max(window)-mean(reshape(m,1,[])))/std(reshape(m,1,[]));
       end
            if peak>0 && z>5
                 text(-0.003, max(ylim)*1.1, sprintf('%.1f',z),'color','m','Fontsize',8)
                text(min(xlim), max(ylim)*0.85, sprintf('*excitatory'),'color','r','Fontsize',8)
            end 
             % Inhibitory connection
            CI_window_down=CI(51:57,1);trough=sum(window(2:end)<CI_window_down);
            z=(max(window)-mean(reshape(m,1,[])))/std(reshape(m,1,[]));
            if trough>1 && z<-5      
                text(-0.003, max(ylim)*1.1, sprintf('%.1f',z),'color','m','Fontsize',8)                
                text(min(xlim), max(ylim)*0.85, sprintf('*inhibitory'),'color','b','Fontsize',8)
            end                  
            close all
    end
   end

