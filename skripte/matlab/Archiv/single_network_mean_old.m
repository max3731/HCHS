%% General settings
hchs_dir = '/Users/mschu/Documents/Documents/CSI/HCHS/analysis'
%conn_dir = [hchs_dir, '/fMRI_resting/conn_mat/aroma_matrix'];
%conn_dir = [hchs_dir, '/fMRI_resting/conn_mat/aroma_pvalthresh_matrix'];
conn_dir = [hchs_dir, '/fMRI_resting/conn_mat/aroma_gsr_matrix'];



% hchs_dir = '/Users/mschu/Documents/Documents/CSI/HCHS/analysis'
% conn_dir = [hchs_dir, '/fMRI_resting/conn_mat/36p_matrix'];

main_txt_path = [hchs_dir '/sozio_data'];
absolute_values = 1;
mean_default = []



BCT_path = '/Users/mschu/Documents/Documents/CSI/HCHS/analysis/BCT/2019_03_03_BCT';
addpath(BCT_path);
 

 all_thresh = [0 0.1 0.3 0.5  ];%0.9 0.7
 num_thresh = length(all_thresh);

 %mkdir(target_dir)
 cd(conn_dir)
        
 broken_subjects = 'sub-2016203f.mat'


%% Sorting Subjects
       
        cd(conn_dir)
        
            all_subjects_str = ls(conn_dir);
            all_subjects     = cellstr(all_subjects_str);
            
            for i = 1:length(all_subjects);
                csubj = all_subjects{i}; 
            if ~isempty(regexp(broken_subjects, csubj, 'once'))
                all_subjects{i} = [];
            elseif isempty(regexp(csubj, 'sub', 'once')) 
                all_subjects{i} = [];
            end
            end 

all_subjects = all_subjects(~cellfun('isempty', all_subjects));
all_subjects = sort(all_subjects);

%% Vorbereiten von Matrizen Datensatz

         id_m = cell(length(all_subjects),1);
         for subjind = 1:length(all_subjects);
             csubj = all_subjects{subjind};
             nsubj=csubj(1:12);
             nsubj=strsplit(nsubj);
             id_m(subjind,:) = nsubj;       
         end


%% Vorbereiten von WML Datensatz

        tbl = readtable([main_txt_path '/WML.dat'])
          [~,idx] = sortrows(tbl(:,1)); % sortieren der Tabelle nach Subject ID
          tbl = tbl(idx,:);
                    
          id  = tbl.ID    
          id(115) = [] % broken_subjects = 'sub-2016203f.mat'
%         id(925) = [] % nur bei 36p

         setdiff(id_m,id)
         setdiff(id,id_m)
          
%% Vorbereiten von Age Datensatz       

        tbl2 = readtable([main_txt_path '/demographics.csv'],'Delimiter','space')          
         [~,idx] = sortrows(tbl2(:,1)); % sortieren der Tabelle nach Subject ID
         tbl2 = tbl2(idx,:);
%          
         age_sub = tbl2.sub;
         str2 = 'sub-';
         
         for subjind = 1:length(age_sub)
             csubj = age_sub{subjind};
             nsubj=strcat(str2,csubj);
             nsubj=strsplit(nsubj);
             age_sub(subjind,:)=nsubj;            
         end


%% Angleichen von Matrizen an Age Datensatz

           ex1 = setdiff(id_m,age_sub)  % Subjects die in wml aber nicht in age  sind 
           [~,idx1] = ismember(id_m,ex1)
           [idx1] = find(idx1)
        
           id_m(idx1) = [] % löschen dieser Subejcts aus wml datensatz
            
           
           all_subjects(idx1) = [] % löschen der Werte aus Matrizen datensatz die nicht im age Datensatz sind
           
           
           ex3 = setdiff(age_sub,id)  % Subjects die in age aber nicht in wml sind 
           [~,idx3] = ismember(age_sub,ex3)
           [idx3] = find(idx3)
          
           
           age = tbl2.age
           age_sub(idx3) = [] % löschen dieser Subejcts aus age datensatz
           age(idx3)= [] % löschen der Werte aus age datensatz die nicht im wml Datensatz sind


         setdiff(id_m,age_sub)
         setdiff(age_sub,id_m)

%% Loop through Subjects

      for ind_thresh = 1:num_thresh;
              thresh  = all_thresh(ind_thresh);
              
%                       if absolute_values
% 
%                          target_dir = [hchs_dir, '/fMRI_resting/conn_mat/mean_aroma_abs_' num2str(thresh)];
%                       else
% 
%                          target_dir = [hchs_dir, '/fMRI_resting/conn_mat/mean_aroma_' num2str(thresh)];
%                              
%                       end
%                       
%                       if absolute_values
% 
%                          target_dir = [hchs_dir, '/fMRI_resting/conn_mat/mean_aroma_pval_abs_' num2str(thresh)];
%                       else
% 
%                          target_dir = [hchs_dir, '/fMRI_resting/conn_mat/mean_aroma_pval_' num2str(thresh)];
%                              
%                       end
% %                       
                      
                      
                      
                      
                      
                      if absolute_values

                         target_dir = [hchs_dir, '/fMRI_resting/conn_mat/mean_gsr_aroma_abs_' num2str(thresh)];
                      else

                         target_dir = [hchs_dir, '/fMRI_resting/conn_mat/mean_gsr_aroma_' num2str(thresh)];
                             
                      end
                      
                      
%                       if absolute_values
% 
%                          target_dir = [hchs_dir, '/fMRI_resting/conn_mat_36/mean_36_abs_' num2str(thresh)];
%                       else
% 
%                          target_dir = [hchs_dir, '/fMRI_resting/conn_mat_36/mean_36_' num2str(thresh)];
%                              
%                       end


%                        mkdir(target_dir)
                       
              for subjind = 1:length(all_subjects)

                            subject = all_subjects{subjind};
                            load([conn_dir '/' subject]);

                                  if absolute_values
                                     Mat = abs(Mat);
                                  end  
                                  Mat = threshold_proportional(Mat, (1-thresh));
                                  mean_conn = mean(mean(Mat));
                                  mean_conn_all(subjind,:) = mean_conn;
                                  


                             %%  extracting default net and mean connectivity

                               default_lh = (74:100); % 
                               default_rh = (182:200); 
                               %
                               default_index = [default_lh,default_rh]; %
                               default = Mat(default_index, default_index);
                               default_all(:,:,subjind)  = default;
                               
                               mean_default = tril(default);
                               mean_default(mean_default==0) = nan;

                              % s=mean(half_default(logical(triu(ones(size(half_default))))))

                               mean_default = nanmean(mean_default);
                               mean_default = mean_default(~isnan(mean_default));
                               mean_default = mean(mean_default);
                                                                                          
                               mean_default_all(subjind,:) = mean_default;
                               
                               [~, mod] = modularity_und(default);
                               modul_default(subjind,:) = mod;


                              %% extracting Dorsal net and mean connectivity 


                               dorsal_lh = (31:43); % 
                               dorsal_rh = (135:147); 
                               %
                               dorsal_index = [ dorsal_lh, dorsal_rh]; %
                               dorsal = Mat(dorsal_index, dorsal_index);
                               dorsal_all(:,:,subjind)  = dorsal;
                               
                               mean_dorsal = tril(dorsal);
                               mean_dorsal(mean_dorsal==0) = nan;

                              % s=mean(half_default(logical(triu(ones(size(half_default))))))

                               mean_dorsal = nanmean(mean_dorsal);
                               mean_dorsal = mean_dorsal(~isnan(mean_dorsal));
                               mean_dorsal = mean(mean_dorsal);
                               mean_dorsal_all(subjind,:) = mean_dorsal;
                               
                               
                               [~, mod] = modularity_und(dorsal);
                               modul_dorsal(subjind,:) = mod;

                             %%  extracting SalVen net and mean connectivity     


                               salven_lh = (44:54); % 
                               salven_rh = (148:158); 
                               %
                               salven_index = [salven_lh,salven_rh]; %
                               salven = Mat(salven_index, salven_index);
                               salven_all(:,:,subjind)  = salven;
                               
                               mean_salven = tril(salven);
                               mean_salven(mean_salven==0) = nan;

                              % s=mean(half_default(logical(triu(ones(size(half_default))))))

                               mean_salven = nanmean(mean_salven);
                               mean_salven = mean_salven(~isnan(mean_salven));
                               mean_salven = mean(mean_salven);
                               mean_salven_all(subjind,:) = mean_salven;


                               [~, mod] = modularity_und(salven);
                               modul_salven(subjind,:) = mod;


                            %%  extracting SomMot net and mean connectivity     


                               sommot_lh = (15:30); % 
                               sommot_rh = (116:134); 
                               %
                               sommot_index = [ sommot_lh, sommot_rh]; %
                               sommot = Mat(sommot_index, sommot_index);
                               sommot_all(:,:,subjind)  = sommot;
                               
                               mean_sommot = tril(sommot);
                               mean_sommot(mean_sommot==0) = nan;

                              % s=mean(half_default(logical(triu(ones(size(half_default))))))

                               mean_sommot = nanmean(mean_sommot);
                               mean_sommot = mean_sommot(~isnan(mean_sommot));
                               mean_sommot = mean(mean_sommot);
                               mean_sommon_all(subjind,:) = mean_sommot;
                               
                               
                               [~, mod] = modularity_und(sommot);
                               modul_sommot(subjind,:) = mod;


                            %%  extracting Cont net and mean connectivity     


                               cont_lh = (61:73); % 
                               cont_rh = (165:181); 
                               %
                               cont_index = [cont_lh,cont_rh]; %
                               cont = Mat(cont_index, cont_index);
                               cont_all(:,:,subjind)  = cont;
                               
                               mean_cont = tril(cont);
                               mean_cont(mean_cont==0) = nan;

                              % s=mean(half_default(logical(triu(ones(size(half_default))))))

                               mean_cont = nanmean(mean_cont);
                               mean_cont = mean_cont(~isnan(mean_sommot));
                               mean_cont = mean(mean_cont);
                               mean_cont_all(subjind,:) = mean_cont;

                               [~, mod] = modularity_und(cont);
                               modul_cont(subjind,:) = mod;



                           %%  extracting Vis net and mean connectivity     


                               vis_lh = (1:14); % 
                               vis_rh = (101:115); 
                               %
                               vis_index = [vis_lh,vis_rh]; %
                               vis = Mat(vis_index, vis_index);
                               vis_all(:,:,subjind)  = vis;
                               
                               mean_vis = tril(vis);
                               mean_vis(mean_vis==0) = nan;

                              % s=mean(half_default(logical(triu(ones(size(half_default))))))

                               mean_vis = nanmean(mean_vis);
                               mean_vis = mean_vis(~isnan(mean_vis));
                               mean_vis = mean(mean_vis);
                               mean_vis_all(subjind,:) = mean_vis;
                               
                               
                               

                               [~, mod] = modularity_und(vis);
                               modul_vis(subjind,:) = mod;

                          %%  extracting Limb net and mean connectivity     


                               limb_lh = (55:60); % 
                               limb_rh = (159:164); 
                               %
                               limb_index = [limb_lh,limb_rh]; %
                               limb = Mat(limb_index, limb_index);
                               limb_all(:,:,subjind)  = limb;
                               
                               mean_limb = tril(limb);
                               mean_limb(mean_limb==0) = nan;

                              % s=mean(half_default(logical(triu(ones(size(half_default))))))

                               mean_limb = nanmean(mean_limb);
                               mean_limb = mean_limb(~isnan(mean_limb));
                               mean_limb = mean(mean_limb);
                               mean_limb_all(subjind,:) = mean_limb;         
                               
                               [~, mod] = modularity_und(limb);
                               modul_limb(subjind,:) = mod;
              end
  
  
     
                   save([target_dir '/default_all'],'default_all');
                   save([target_dir '/dorsal_all'],'dorsal_all');
                   save([target_dir '/salven_all'],'salven_all');
                   save([target_dir '/sommot_all'],'sommot_all');
                   save([target_dir '/cont_all'],'cont_all');
                   save([target_dir '/vis_all'],'vis_all');
                   save([target_dir '/limb_all'],'limb_all');
                   
                   save([target_dir '/mean_default'],'mean_default_all');
                   save([target_dir '/mean_dorsal'],'mean_dorsal_all');
                   save([target_dir '/mean_salven'],'mean_salven_all');
                   save([target_dir '/mean_sommon'],'mean_sommon_all');
                   save([target_dir '/mean_conn'],'mean_conn_all');
                   save([target_dir '/mean_vis'],'mean_vis_all');
                   save([target_dir '/mean_limb'],'mean_limb_all');
                   save([target_dir '/mean_cont'],'mean_cont_all');
                   
                   save([target_dir '/modul_default'],'modul_default');
                   save([target_dir '/modul_dorsal'],'modul_dorsal');
                   save([target_dir '/modul_salven'],'modul_salven');
                   save([target_dir '/modul_sommot'],'modul_sommot');
                  
                   save([target_dir '/modul_vis'],'modul_vis');
                   save([target_dir '/modul_limb'],'modul_limb');
                   save([target_dir '/modul_cont'],'modul_cont');
                   
      end