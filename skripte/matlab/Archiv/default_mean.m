%% General settings
hchs_dir = '/home/share/rawdata/Max/HCHS/analysis';
conn_dir = [hchs_dir, '/fMRI_resting/conn_mat/aroma_matrix'];
target_dir = [hchs_dir, '/fMRI_resting/conn_mat/mean_aroma/'];
mean_default = []

%% Sorting Subjects
        %mkdir(target_dir)
        cd(conn_dir)
        
            all_subjects_str = ls(conn_dir);
            all_subjects     = strsplit(all_subjects_str);
            
            for i = 1:length(all_subjects);
                csubj = all_subjects{i};         
            if isempty(regexp(csubj, 'sub', 'once')) 
                all_subjects{i} = [];
            end
            end 

all_subjects = all_subjects(~cellfun('isempty', all_subjects));
all_subjects = sort(all_subjects);


%% Loop through Subjects


  for subjind = 1:length(all_subjects)
                    
                subject = all_subjects{subjind};
                load([conn_dir '/' subject]);
    
                 %%  extracting default net and mean connectivity
                 
                   default_lh = (74:100); % 
                   default_rh = (182:200); 
                   %
                   default_index = [default_lh,default_rh]; %
                   default = Mat(default_index, default_index);
                   mean_default = tril(default);
                   mean_default(mean_default==0) = nan;
                  
                  % s=mean(half_default(logical(triu(ones(size(half_default))))))
                   
                   mean_default = nanmean(mean_default);
                   mean_default = mean_default(~isnan(mean_default));
                   mean_default = mean(mean_default);
                   mean_default_all(subjind,:) = mean_default;
                   
                   
                  %% extracting Dorsal net and mean connectivity 
   
                     
                   dorsal_lh = (31:43); % 
                   dorsal_rh = (135:147); 
                   %
                   dorsal_index = [ dorsal_lh, dorsal_rh]; %
                   dorsal = Mat(dorsal_index, dorsal_index);
                   mean_dorsal = tril(dorsal);
                   mean_dorsal(mean_dorsal==0) = nan;
                  
                  % s=mean(half_default(logical(triu(ones(size(half_default))))))
                   
                   mean_dorsal = nanmean(mean_dorsal);
                   mean_dorsal = mean_dorsal(~isnan(mean_dorsal));
                   mean_dorsal = mean(mean_dorsal);
                   mean_dorsal_all(subjind,:) = mean_dorsal;
                   
                 %%  extracting SalVen net and mean connectivity     
             
             
                   salven_lh = (44:54); % 
                   salven_rh = (148:158); 
                   %
                   salven_index = [salven_lh,salven_rh]; %
                   salven = Mat(salven_index, salven_index);
                   mean_salven = tril(salven);
                   mean_salven(mean_salven==0) = nan;
                  
                  % s=mean(half_default(logical(triu(ones(size(half_default))))))
                   
                   mean_salven = nanmean(mean_salven);
                   mean_salven = mean_salven(~isnan(mean_salven));
                   mean_salven = mean(mean_dorsal);
                   mean_salven_all(subjind,:) = mean_salven;
   
                   
                   
                   
                   
                %%  extracting SomMot net and mean connectivity     
             
             
                   sommot_lh = (15:30); % 
                   sommot_rh = (116:134); 
                   %
                   sommot_index = [ sommot_lh, sommot_rh]; %
                   sommot = Mat(sommot_index, sommot_index);
                   mean_sommot = tril(sommot);
                   mean_sommot(mean_sommot==0) = nan;
                  
                  % s=mean(half_default(logical(triu(ones(size(half_default))))))
                   
                   mean_sommot = nanmean(mean_sommot);
                   mean_sommot = mean_sommot(~isnan(mean_sommot));
                   mean_sommot = mean(mean_sommot);
                   mean_sommon_all(subjind,:) = mean_sommot;
   
                %%  extracting Cont net and mean connectivity     
             
             
                   cont_lh = (61:73); % 
                   cont_rh = (165:181); 
                   %
                   cont_index = [cont_lh,cont_rh]; %
                   cont = Mat(cont_index, cont_index);
                   mean_cont = tril(cont);
                   mean_cont(mean_cont==0) = nan;
                  
                  % s=mean(half_default(logical(triu(ones(size(half_default))))))
                   
                   mean_cont = nanmean(mean_cont);
                   mean_cont = mean_cont(~isnan(mean_sommot));
                   mean_cont = mean(mean_cont);
                   mean_cont_all(subjind,:) = mean_cont;
                      
                   

                   
                   
               %%  extracting Vis net and mean connectivity     
             
             
                   vis_lh = (1:14); % 
                   vis_rh = (101:115); 
                   %
                   vis_index = [vis_lh,vis_rh]; %
                   vis = Mat(vis_index, vis_index);
                   mean_vis = tril(vis);
                   mean_vis(mean_vis==0) = nan;
                  
                  % s=mean(half_default(logical(triu(ones(size(half_default))))))
                   
                   mean_vis = nanmean(mean_vis);
                   mean_vis = mean_vis(~isnan(mean_sommot));
                   mean_vis = mean(mean_vis);
                   mean_vis_all(subjind,:) = mean_vis;
                                         
              %%  extracting Limb net and mean connectivity     
             
             
                   limb_lh = (55:68); % 
                   limb_rh = (159:164); 
                   %
                   limb_index = [limb_lh,limb_rh]; %
                   limb = Mat(limb_index, limb_index);
                   mean_limb = tril(limb);
                   mean_limb(mean_limb==0) = nan;
                  
                  % s=mean(half_default(logical(triu(ones(size(half_default))))))
                   
                   mean_limb = nanmean(mean_limb);
                   mean_limb = mean_limb(~isnan(mean_sommot));
                   mean_limb = mean(mean_limb);
                   mean_limb_all(subjind,:) = mean_limb;                 
  end
  
  
                   save([target_dir '/mean_default'],'mean_default_all');
                   save([target_dir '/mean_dorsal'],'mean_dorsal_all');
                   save([target_dir '/mean_salven'],'mean_salven_all');
                   save([target_dir '/mean_sommon'],'mean_sommon_all');
                   save([target_dir '/mean_con'],'mean_cont_all');
                   save([target_dir '/mean_vis'],'mean_vis_all');
                   save([target_dir '/mean_limb'],'mean_limb_all');