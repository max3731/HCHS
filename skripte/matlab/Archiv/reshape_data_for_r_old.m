
%% General settings
hchs_dir = '/Users/mschu/Documents/Documents/CSI/HCHS/analysis';
%main_dir = [hchs_dir, '/fMRI_resting/conn_mat/aroma_matrix'];
%   main_dir = [hchs_dir, '/fMRI_resting/conn_mat/aroma_pvalthresh_matrix'];
 main_dir = [hchs_dir, '/fMRI_resting/conn_mat/aroma_gsr_matrix'];
  
%  main_dir = [hchs_dir, '/fMRI_resting/conn_mat/36p_matrix'];
 %conn_dir = [hchs_dir, '/fMRI_resting/conn_mat/mean_aroma'];
absolute_values = 1;
target_dir = [hchs_dir, '/csv_for_R'];
main_txt_path = [hchs_dir '/sozio_data'];

all_thresh = [0.5  ];% 0.9 0.7 0 0.1 0.3
num_thresh = length(all_thresh);

 broken_subjects = 'sub-2016203f.mat' 


%% Sorting Subjects

%         mkdir(target_dir)
%         cd(main_dir)
        
          %  all_subjects_str = ls(main_dir);
             all_subjects = ls(main_dir);
             all_subjects = cellstr(all_subjects)
           % all_subjects     = strsplit(all_subjects_str);
            
            for i = 1:length(all_subjects);
                     csubj = all_subjects{i};         
                  if isempty(regexp(csubj, 'sub', 'once')) 
                     all_subjects{i} = [];
                 end
            end 

        all_subjects = all_subjects(~cellfun('isempty', all_subjects));
        all_subjects = sort(all_subjects);
        


%% Load clinical Data

                  
%% Vorbereiten von WML Datensatz

        tbl = readtable([main_txt_path '/WML.dat'])
          [~,idx] = sortrows(tbl(:,1)); % sortieren der Tabelle nach Subject ID
          tbl = tbl(idx,:);
                    
          id  = tbl.ID    
          id(115) = []
%           id(925) = [] % nur bei 36p
          
%% Vorbereiten von Age Datensatz       

        tbl2 = readtable([main_txt_path '/demographics.csv'],'Delimiter','space')          
         [~,idx] = sortrows(tbl2(:,1)); % sortieren der Tabelle nach Subject ID
         tbl2 = tbl2(idx,:);
% %          
         age_sub = tbl2.sub;
         str2 = 'sub-';
         
         for subjind = 1:length(age_sub)
             csubj = age_sub{subjind};
             nsubj=strcat(str2,csubj);
             nsubj=strsplit(nsubj);
             age_sub(subjind,:)=nsubj;            
         end

%% Angleichen von WML und Age Datensätzen

           ex1 = setdiff(id,age_sub)  % Subjects die in wml aber nicht in age  sind 
           [~,idx1] = ismember(id,ex1)
           [idx1] = find(idx1)
        
           id(idx1) = [] % löschen dieser Subejcts aus wml datensatz
          
           wml = tbl.WML %Bereiningung der WML Werte       
           wml(115) = []
%            wml(925) = [] % nur bei 36p
           
           wml(idx1) = [] % löschen der Werte aus wml datensatz die nicht im age Datensatz sind
           
           
           ex3 = setdiff(age_sub,id)  % Subjects die in age aber nicht in wml sind 
          [~,idx3] = ismember(age_sub,ex3)
          [idx3] = find(idx3)
          
           
          age = tbl2.age
          age_sub(idx3) = [] % löschen dieser Subejcts aus age datensatz
          age(idx3)= [] % löschen der Werte aus age datensatz die nicht im wml Datensatz sind


%% Vorbereiten von brain volume Datensatz   

          tbl_v = readtable([main_txt_path '/BrainVol.dat'])
          vol = tbl_v.BrainVol_T1w
          vol_sub = tbl_v.sub
        
          [~, ind] = unique(vol_sub)
          duplicate_ind = setdiff(1:size(vol_sub,1),ind)% find double strings 
          duplicate_value = vol_sub(duplicate_ind,1)% find vlaue of double strings
          vol_sub (duplicate_ind) = []% deleeting double measurements in sub string
          vol(duplicate_ind) = [] % deleeting double measurements in value string
 
%% Angleichen von volume und wml Datensatz

          ex2 = setdiff(vol_sub,id)% looking for additional strings in vol_sub by hand
          [~,idx2] = ismember(vol_sub,ex2)
           [idx2] = find(idx2)
           
           vol_sub(idx2) = []
           vol(idx2) = []
                   
           ratio = wml./vol % WML Volumen korrigiert für Gesamthirnvolumen

       %% load network data  
         for ind_thresh = 1:num_thresh;
              thresh  = all_thresh(ind_thresh);
              
%                       if absolute_values
% 
%                              conn_dir = [hchs_dir, '/fMRI_resting/conn_mat/mean_aroma_abs_' num2str(thresh)];
%                              conn_dir_betw = [hchs_dir, '/fMRI_resting/conn_mat/mean_aroma_abs_' num2str(thresh) '/between_net'];
%                       else
%                              conn_dir = [hchs_dir, '/fMRI_resting/conn_mat/mean_aroma_' num2str(thresh)];
%                              conn_dir_betw = [hchs_dir, '/fMRI_resting/conn_mat/mean_aroma_' num2str(thresh) '/between_net'];
%                              
%                       end     





                      if absolute_values

                             conn_dir = [hchs_dir, '/fMRI_resting/conn_mat/mean_gsr_aroma_abs_' num2str(thresh)];
                             conn_dir_betw = [hchs_dir, '/fMRI_resting/conn_mat/mean_gsr_aroma_abs_' num2str(thresh) '/between_net'];
                      else
                             conn_dir = [hchs_dir, '/fMRI_resting/conn_mat/mean_gsr_aroma_' num2str(thresh)];
                             conn_dir_betw = [hchs_dir, '/fMRI_resting/conn_mat/mean_gsr_aroma_' num2str(thresh) '/between_net'];
                             
                      end  
%                                            
%                       if absolute_values
% 
%                              conn_dir = [hchs_dir, '/fMRI_resting/conn_mat/mean_aroma_pval_abs_' num2str(thresh)];
%                              conn_dir_betw = [hchs_dir, '/fMRI_resting/conn_mat/mean_aroma_pval_abs_' num2str(thresh) '/between_net'];
%                       else
%                              conn_dir = [hchs_dir, '/fMRI_resting/conn_mat/mean_aroma_pval' num2str(thresh)];
%                              conn_dir_betw = [hchs_dir, '/fMRI_resting/conn_mat/mean_aroma_pval' num2str(thresh) '/between_net'];
%                              
%                       end  
                      
                      
                      
%                        if absolute_values
% 
%                              conn_dir = [hchs_dir, '/fMRI_resting/conn_mat_36/mean_36_abs_' num2str(thresh)];
%                              conn_dir_betw = [hchs_dir, '/fMRI_resting/conn_mat_36/mean_36_abs_' num2str(thresh) '/between_net'];
%                       else
%                              conn_dir = [hchs_dir, '/fMRI_resting/conn_mat_36/mean_aroma_' num2str(thresh)];
%                              conn_dir_betw = [hchs_dir, '/fMRI_resting/conn_mat_36/mean_aroma_' num2str(thresh) '/between_net'];
%                              
%                       end   
    
                      
         %% Single Network Values             
                      cd(conn_dir)
                      all_val_single = ls('m*');
                      all_val_single     = cellstr(all_val_single)
                      
 
                      
                      all_val_single = all_val_single(~cellfun('isempty', all_val_single));
                      all_val_single = sort(all_val_single);
                      
                      for val_s = 1:length(all_val_single);
                          
                          value_s = all_val_single{val_s};
                          load([conn_dir '/' value_s]);
                                 % value_s(idx2) = []
                      end
                      
         %% Between Network Values
                      cd(conn_dir_betw)
                      all_val_betw = ls(conn_dir_betw);
                      all_val_betw     = cellstr(all_val_betw)
                      
                      all_val_betw = all_val_betw(~cellfun('isempty', all_val_betw));
                        all_val_betw(1) = []
                        all_val_betw(1) = []
                      all_val_betw = sort(all_val_betw);
                      
                      for val_b = 1:length(all_val_betw);
                          
                          value_b = all_val_betw{val_b};
                          load([conn_dir_betw '/' value_b]);
                          %  value_b(idx2) = []
                      end
                      
                     

   all_val = table(id,age,wml,ratio,modul,modul_default,modul_dorsal,modul_salven,modul_sommot,modul_vis,modul_limb,modul_cont,mean_conn_all,mean_cont_all,mean_default_all,mean_dorsal_all,mean_salven_all,mean_sommon_all,mean_vis_all,mean_limb_all,default_dorsal_all,default_salven_all,default_sommot_all,default_cont_all,default_vis_all,default_limb_all,dorsal_salven_all,dorsal_sommot_all,dorsal_cont_all,dorsal_vis_all,dorsal_limb_all,salven_sommot_all,salven_cont_all,salven_vis_all,salven_limb_all,sommot_cont_all,sommot_vis_all,sommot_limb_all,cont_vis_all,cont_limb_all,vis_limb_all)
        
 %% Change to Table
 

% 
%             if absolute_values
%                 writetable(all_val,[target_dir '/HCHS_conn_' num2str(thresh) '_aroma_abs.csv'])
%                 save([target_dir '/all_val_aroma_abs', 'all_val'])
%             else
%                 writetable(all_val,[target_dir '/HCHS_conn_' num2str(thresh) '_aroma.csv'])
%                 save([target_dir '/all_val_aroma_abs', 'all_val'])
%             end



            if absolute_values
                writetable(all_val,[target_dir '/HCHS_conn_' num2str(thresh) '_aroma_gsr_abs.csv'])
                save([target_dir '/all_val_aroma_abs', 'all_val'])
            else
                writetable(all_val,[target_dir '/HCHS_conn_' num2str(thresh) '_gsr_aroma.csv'])
                save([target_dir '/all_val_aroma_abs', 'all_val'])
            end
            
            
%             if absolute_values
%                 writetable(all_val,[target_dir '/HCHS_conn_' num2str(thresh) '_aroma_pval_abs.csv'])
%                 save([target_dir '/all_val_aroma_abs', 'all_val'])
%             else
%                 writetable(all_val,[target_dir '/HCHS_conn_' num2str(thresh) '_aroma_pval.csv'])
%                 save([target_dir '/all_val_aroma_abs', 'all_val'])
%             end
%             
            
            
%             if absolute_values
%                 writetable(all_val,[target_dir '/HCHS_conn_' num2str(thresh) '_36_abs.csv'])
%                 save([target_dir '/all_val_aroma_abs', 'all_val'])
%             else
%                 writetable(all_val,[target_dir '/HCHS_conn_' num2str(thresh) '_36.csv'])
%                 save([target_dir '/all_val_aroma_abs', 'all_val'])
%             end


 end



   
