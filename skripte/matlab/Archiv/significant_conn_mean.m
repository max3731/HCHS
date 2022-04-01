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

%% Sorting Subjects
        %mkdir(target_dir)
        cd(conn_dir)
        
 broken_subjects = 'sub-2016203f.mat'

%% excluding for age array
        tbl = readtable([main_txt_path '/WML.dat'])
        id  = tbl.ID    
        id(115) = [] 
%          id(925) = [] % nur bei 36p
        
         tbl2 = readtable([main_txt_path '/demographics.csv'],'Delimiter','space')
         age_sub = tbl2.sub;
         str2 = 'sub-';
         
         % Angleichen der Nomenklatur
         for subjind = 1:length(age_sub)
             csubj = age_sub{subjind};
             nsubj=strcat(str2,csubj);
             nsubj=strsplit(nsubj);
             age_sub(subjind,:)=nsubj;            
         end
         % Index der Subjects die in der Demographie Tabelle nicht
         % enthalten sind
           ex2 = setdiff(id,age_sub)  
           [~,idx] = ismember(id,ex2)
           [idx2] = find(idx)
           
           
           
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
all_subjects(idx2) = []


%% Loop through Subjects

      for ind_thresh = 1:num_thresh;
              thresh  = all_thresh(ind_thresh);
              
              
                      if absolute_values

                         target_dir = [hchs_dir, '/fMRI_resting/conn_mat/mean_gsr_aroma_abs_' num2str(thresh)];
                      else

                         target_dir = [hchs_dir, '/fMRI_resting/conn_mat/mean_gsr_aroma_' num2str(thresh)];
                             
                      end
                      
                      
                                    for subjind = 1:length(all_subjects)

                            subject = all_subjects{subjind};
                            load([conn_dir '/' subject]);

                                  if absolute_values
                                     Mat = abs(Mat);
                                  end  
                                  Mat = threshold_proportional(Mat, (1-thresh));
                                  
                                  
                                                               
                     %%  extracting default net and mean connectivity
                               default_lh = (74:100); % 
                               default_rh = (182:200); 
                               %
                               default_index = [default_lh,default_rh]; %
                               default_M = Mat(default_index, default_index);
                     
                     
                             default = [];
                     
                             
                             
                             
                                                mean_default = mean(default);
                            mean_sign_default_all(subjind,:) = mean_default; 
                             
                             
                     %%  extracting default net and mean connectivity
                     
                               dorsal_lh = (31:43); % 
                               dorsal_rh = (135:147); 
                               %
                               dorsal_index = [ dorsal_lh, dorsal_rh]; %
                               dorsal_M = Mat(dorsal_index, dorsal_index);
                     
                     
                     
                     
                             dorsal = [];
                     
                             
                             
                             
                                                 mean_dorsal = mean(dorsal);
                             mean_sign_dorsal_all(subjind,:) = mean_dorsal; 
                     
  
                     %%  extracting default net and mean connectivity
                               salven_lh = (44:54); % 
                               salven_rh = (148:158); 
                               %
                               salven_index = [salven_lh,salven_rh]; %
                               salven_M = Mat(salven_index, salven_index);
                     
                     
                               salven = [];
                     
                             
                             
                             
                                            mean_salven = mean(salven);
                             mean_sign_salven_all(subjind,:) = mean_salven; 
                     
                             %%  extracting significant sommot connections and mean connectivity
                             
                             % Resting state Netzwerk erstellen
                               sommot_lh = (15:30); % 
                               sommot_rh = (116:134); 
                               %
                               sommot_index = [ sommot_lh, sommot_rh];  
                               sommot_M = Mat(sommot_index, sommot_index);
                             
                               % Aus dem Resting state Netzwerk die von der
                               % NBS angegebenen signifikanten Verbindungen
                             sommot = [];
                               
                             sommot(1,:) =  sommot_M(1,3); 
                             sommot(2,:) =  sommot_M(2,3);
                             sommot(3,:) =  sommot_M(1,4); 
                             sommot(4,:) =  sommot_M(3,8); 
                             sommot(5,:) =  sommot_M(5,8);
                             sommot(6,:) =  sommot_M(3,10);
                             sommot(7,:) =  sommot_M(10,12);
                             sommot(8,:) =  sommot_M(3,15);
                             sommot(9,:) =  sommot_M(1,16); 
                             sommot(10,:) = sommot_M(2,17); 
                             sommot(11,:) =  sommot_M(3,17);
                             sommot(12,:) =  sommot_M(15,19);
                             sommot(13,:) =  sommot_M(16,19);  
                             sommot(14,:) =  sommot_M(1,20); 
                             sommot(15,:) =  sommot_M(8,20);
                             sommot(16,:) =  sommot_M(3,22);
                             sommot(17,:) =  sommot_M(5,22); 
                             sommot(18,:) =  sommot_M(4,26); 
                             sommot(19,:) =  sommot_M(3,27);
                             sommot(20,:) =  sommot_M(19,27); 
                             sommot(21,:) =  sommot_M(20,29); 
                             sommot(22,:) =  sommot_M(19,30); 
                             sommot(23,:) =  sommot_M(20,32); 
                             sommot(24,:) =  sommot_M(15,33);
                             sommot(25,:) =  sommot_M(3,34) ;
                             %Mittelwert der Signifikanten Verbindungen für
                             %ein Subject
                             mean_sommot = mean(sommot);
                             %Für alle Subjects
                             mean_sign_sommon_all(subjind,:) = mean_sommot;  
                             
                     %%  extracting default net and mean connectivity
                               cont_lh = (61:73); % 
                               cont_rh = (165:181); 
                               %
                               cont_index = [cont_lh,cont_rh]; %
                               cont_M = Mat(cont_index, cont_index);
                     
                     
                     
                     
                               cont = [];
                     
                             
                             
                             
                                            mean_cont = mean(cont);
                             mean_sign_cont_all(subjind,:) = mean_cont; 
                     
                             
                      %%  extracting default net and mean connectivity
                      
                      
                               vis_lh = (1:14); % 
                               vis_rh = (101:115); 
                               %
                               vis_index = [vis_lh,vis_rh]; %
                               vis = Mat(vis_index, vis_index);
                               
                               
                               vis = [];
                     
                             
                             
                             
                                            mean_vis = mean(vis);
                             mean_sign_vis_all(subjind,:) = mean_vis; 
                             
                             
                     %%  extracting default net and mean connectivity
                     
                     
                               limb_lh = (55:60); % 
                               limb_rh = (159:164); 
                               %
                               limb_index = [limb_lh,limb_rh]; %
                               limb = Mat(limb_index, limb_index);
                     
                     
                     
                               limb = [];
                     
                             
                             
                             
                                            mean_limb = mean(limb);
                             mean_sign_limb_all(subjind,:) = mean_limb;          
                                    end
                   save([target_dir '/mean_sign_default'],'mean_sign_default_all');
                   save([target_dir '/mean_sign_dorsal'],'mean_sign_dorsal_all');
                   save([target_dir '/mean_sign_salven'],'mean_sign_salven_all');
                   save([target_dir '/mean_sign_sommon'],'mean_sign_sommon_all');
                   save([target_dir '/mean_sign_cont'],'mean_sign_cont_all');
                   save([target_dir '/mean_sign_vis'],'mean_sign_vis_all');
                   save([target_dir '/mean_sign_limb'],'mean_sign_limb_all');
                   save([target_dir '/mean_sign_cont'],'mean_sign_cont_all');
      end