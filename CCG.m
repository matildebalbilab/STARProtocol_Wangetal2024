function CGG_jitter_part(filename)
close all

load([filename '.mat']);  ct=0
  figure;set(gcf,'position',[0 100 1000 800])
    for i=1:size(unit_t,2)
        for j=1:size(unit_t,2)          
            for c=1:10
                 
               %new_unit_t = unit_t{i}(unit_t{i}>800&unit_t{i}<1200)+ 0.01*randn(size(unit_t{i}(unit_t{i}>800&unit_t{i}<1200))) %jittered signal 
               new_unit_t = unit_t{i}+ 0.01*randn(size(unit_t{i})) 
               %[tsOffsets, ts1idx, ts2idx] = crosscorrelogram(new_unit_t, unit_t{j}(unit_t{j}>800&unit_t{j}<1200), [-0.025 0.025])     
               [tsOffsets, ts1idx, ts2idx] = crosscorrelogram(new_unit_t, unit_t{j}, [-0.025 0.025])     
                %nbins = 101;
                %h = histogram(tsOffsets,nbins);m(c,:)=h.Values
                [m(c,:), centers]=hist(tsOffsets,101); %bar(centers,m(c,:))
            end
            subplot(size(unit_t,2),size(unit_t,2),size(unit_t,2)*(i-1)+j)
            %[tsOffsets1, ts1idx, ts2idx] = crosscorrelogram(unit_t{i}(unit_t{i}>800&unit_t{i}<1200), unit_t{j}(unit_t{j}>800&unit_t{j}<1200), [-0.025 0.025])
            [tsOffsets1, ts1idx, ts2idx] = crosscorrelogram(unit_t{i}, unit_t{j}, [-0.025 0.025])
            [counts1, centers1]=hist(tsOffsets1,101);xlim([-0.025 0.025]); 
            bar(centers1,counts1);hold on
            for n=1:101
                CI(n,:)=poissinv([0.01,0.5,0.99],mean(m(:,n)))
            end
            xlim([-0.025 0.025]); 
          
            if i<=j
            else
            ct=ct+1
     
            plot([-0.025:0.05/100:0.025],CI(:,1),'g--','Linewidth',0.5)
            %plot([-0.025:0.05/100:0.025],CI(:,2),'c','Linewidth',1)
            plot([-0.025:0.05/100:0.025],CI(:,3),'g--','Linewidth',0.5)
            
            
            window=counts1(1,50:57)'
            CI_window_up=CI(50:57,3)
            peak=sum(window>CI_window_up)
            if sum(counts1<=1)>=101
                z=0
                text(-0.003, max(ylim)*1.1, sprintf('%.1f',z),'color','m','Fontsize',8)
            else
            z=(max(window)-mean(reshape(m,1,[])))/std(reshape(m,1,[]))
            
            text(-0.003, max(ylim)*1.1, sprintf('%.1f',z),'color','m','Fontsize',8)
            end
            if peak>0
                text(min(xlim), max(ylim)*0.85, sprintf('*excitatory'),'color','r','Fontsize',8)
            end
            connection(ct,1)=z
            
            
            %CI_window_down=CI(51:57,1)
            %trough=sum(window(2:end)<CI_window_down)
            %if trough>1
             %   p=find(window(2:end)<CI_window_down)
              %  for q=1:(length(p)-1)
               %     if p(q+1)-p(q)==1
                %        z=(mean(window(p+1))-mean(reshape(m,1,[])))/std(reshape(m,1,[]))
                 %       text(min(xlim)+0.032, max(ylim)*0.8, sprintf('*inhibitory'),'color','b','Fontsize',7)
                  %      text(min(xlim)+0.032, max(ylim)*0.92, sprintf('%.1f',z),'color','b','Fontsize',7)
                    end
                end
            end
        
    
   
    
    saveas(gcf,[filename 'CCG stim'])   
    xlswrite([filename 'SC stim.xlsx'],connection)
end