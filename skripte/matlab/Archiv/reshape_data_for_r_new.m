
%% General settings
hchs_dir = '/Users/mschu/Documents/Documents/CSI/HCHS/analysis';
% main_dir = [hchs_dir, '/fMRI_resting/conn_mat/aroma_matrix'];
%   main_dir = [hchs_dir, '/fMRI_resting/conn_mat/aroma_pvalthresh_matrix'];
  main_dir = [hchs_dir, '/fMRI_resting/conn_mat/aroma_gsr_matrix'];
  
% main_dir = [hchs_dir, '/fMRI_resting/conn_mat/36p_matrix'];
 %conn_dir = [hchs_dir, '/fMRI_resting/conn_mat/mean_aroma'];
absolute_values = 1;
target_dir = [hchs_dir, '/csv_for_R'];
main_txt_path = [hchs_dir '/sozio_data'];

all_thresh = [0.5  ];% 0.9 0.7 0 0.1 0.3
num_thresh = length(all_thresh);

 broken_subjects = 'sub-2016203f.mat' 
% brokgen_subjects = 'sub-1f00664b' 'sub-20e346fc' 'sub-20ee3cab' 'sub-2a6b2e84'    'sub-35cf5d17'
%     if absolute_values
%         conn_dir = [hchs_dir, '/fMRI_resting/conn_mat/mean_aroma_abs'];
%         conn_dir_betw = [hchs_dir, '/fMRI_resting/conn_mat/mean_aroma_abs/between_net_abs'];
%     else
%         conn_dir = [hchs_dir, '/fMRI_resting/conn_mat/mean_aroma'];
%         conn_dir_betw = [hchs_dir, '/fMRI_resting/conn_mat/mean_aroma/between_net'];
%     end

%% Sorting Subjects

%         mkdir(target_dir)
%         cd(main_dir)
        
          %  all_subjects_str = ls(main_dir);
             all_subjects = ls(main_dir);
             all_subjects = cellstr(all_subjects)
           % all_subjects     = strsplit(all_subjects_str);
            
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
        


%%% Sorting Subjects

        mean_conn = []

        cd(main_dir)
        
            all_subjects_str = ls(main_dir);
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
         
       tbl = readtable([main_txt_path '/data.xlsx']) ; 

          id = tbl.DisclosureID;
          
         
         % Angleichen der Nomenklatur
             str2 = 'sub-';
         for subjind = 1:length(id)
             csubj = id{subjind};
             nsubj=strcat(str2,csubj);
             nsubj=strsplit(nsubj);
             id(subjind,:)=nsubj;            
         end

%% Angleichen von Matrizen an Age Datensatz         
         
         % Index der Subjects die in der Demographie Tabelle aber nicht bei
         % den Matrizen enthalten sind
           ex1 = setdiff(id,id_m)  
           [~,idx] = ismember(id,ex1)
           [idx1] = find(idx)
         
           id(idx1, :) = [];
     
           
          tbl(idx1, :) = []; %löschen der subjects für die keine Tabelleneinträge existieren
          [~,idx] = sortrows(tbl(:,3)); % sortieren der Tabelle nach Subject ID
          tbl = tbl(idx,:);
          id = sort(id) %  sortieren des Subject ID arrays
          
          ex3 = setdiff(id_m,id)  % Subjects die in Matrizen aber nicht in Demographie Tabelle exisiteren  
          [~,idx3] = ismember(id_m,ex3)
          [idx3] = find(idx3)
           
          id_m(idx3) = [] % %löschen der subjects für die keine Matrizen existieren
            
           
          all_subjects(idx3) = [] % löschen der Matrizen  die nicht im Demographie Datensatz sind
 
         

           

         setdiff(id_m,id)
         setdiff(id,id_m)

          
        wml = tbl.wmh_total_vol ;       
        
        vol = tbl.BrainSegNotVent
        age = tbl.age;
        
        ratio = wml./vol

        education = tbl.educationyears
        
        hypertension = tbl.hypertension
        
        TMT = tbl.TMTAB
        sex = tbl.sex
        BMI = tbl.BMI
        GDS = tbl.GDS
        psmd = tbl.psmd

           
%          for subjind = 1:length(ex2)
%              csubj = ex2{subjind}
%             if ~isempty(regexp(broken_subjects, csubj, 'once'))
%                 all_subjects{i} = [];
%              age_sub(subjind,:)=nsubj            
%          end
        
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
                      
                     

        all_val = table(id,age,wml,vol,ratio,education,hypertension,TMT,sex,BMI,GDS,psmd,modul,modul_default,modul_dorsal,modul_salven,modul_sommot,modul_vis,modul_limb,modul_cont,mean_conn_all,mean_cont_all,mean_default_all,mean_dorsal_all,mean_limb_all,mean_salven_all,mean_sommon_all,mean_vis_all,cont_limb_all,cont_vis_all,default_cont_all,default_dorsal_all,default_limb_all,default_salven_all,default_sommot_all,default_vis_all,dorsal_cont_all,dorsal_limb_all,dorsal_salven_all,dorsal_sommot_all,dorsal_vis_all,salven_cont_all,salven_limb_all,salven_sommot_all,salven_vis_all,sommot_cont_all,sommot_limb_all,sommot_vis_all,vis_limb_all,default_dorsal_all,default_salven_all,default_sommot_all,default_cont_all,default_vis_all,default_limb_all,dorsal_salven_all,dorsal_sommot_all,dorsal_cont_all,dorsal_vis_all,dorsal_limb_all,salven_sommot_all,salven_cont_all,salven_vis_all,salven_limb_all,sommot_cont_all,sommot_vis_all,sommot_limb_all,cont_vis_all,cont_limb_all,vis_limb_all)
        
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




   