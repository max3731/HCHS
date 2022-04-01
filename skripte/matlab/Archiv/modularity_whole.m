 %% General settings
hchs_dir = '/Users/mschu/Documents/Documents/CSI/HCHS/analysis'
 %main_dir = [hchs_dir, '/fMRI_resting/conn_mat/aroma_matrix'];
%  main_dir = [hchs_dir, '/fMRI_resting/conn_mat/aroma_pvalthresh_matrix'];
  main_dir = [hchs_dir, '/fMRI_resting/conn_mat/aroma_gsr_matrix'];
  
%  main_dir = [hchs_dir, '/fMRI_resting/conn_mat/36p_matrix'];
 main_txt_path = [hchs_dir '/sozio_data'];
 
 absolute_values = 1
 broken_subjects = 'sub-2016203f.mat'
 
BCT_path = '/Users/mschu/Documents/Documents/CSI/HCHS/analysis/BCT/2019_03_03_BCT';
addpath(BCT_path);

 all_thresh = [ 0.5 ];%0.9 0 0.1 0.3 0.7 
 num_thresh = length(all_thresh);
 
 mean_conn = []

 cd(main_dir)
 
 %% Sorting Subjects        
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


                      if absolute_values

                         target_dir = [hchs_dir, '/fMRI_resting/conn_mat/mean_gsr_aroma_abs_' num2str(thresh)];
                      else

                         target_dir = [hchs_dir, '/fMRI_resting/conn_mat/mean_gsr_aroma_' num2str(thresh)];
                             
                      end







%                       if absolute_values
% 
%                          target_dir = [hchs_dir, '/fMRI_resting/conn_mat/mean_aroma_pval_abs_' num2str(thresh)];
%                       else
% 
%                          target_dir = [hchs_dir, '/fMRI_resting/conn_mat/mean_aroma_pval_' num2str(thresh)];
%                              
%                       end
                      
                      
                      
%                       if absolute_values
% 
%                          target_dir = [hchs_dir, '/fMRI_resting/conn_mat_36/mean_36_abs_' num2str(thresh) '/between_net'];
%                       else
% 
%                          target_dir = [hchs_dir, '/fMRI_resting/conn_mat_36/mean_36_' num2str(thresh) '/between_net'];
%                              
%                       end
                      
                        mkdir(target_dir)
                        
                        for subjind = 1:length(all_subjects)
                    
                                subject = all_subjects{subjind};
                                load([main_dir '/' subject]);
                    
                                   if absolute_values
                                       Mat = abs(Mat);
                                   end  
                         
                             mat_thr = threshold_proportional(Mat, (1-thresh));
                             [rois, mod] = modularity_und(mat_thr,1.1);
                             modul(subjind,:) = mod;
                             ROI(subjind,:) = rois;
                             save([target_dir '/modul'],'modul');
                             save([target_dir '/ROI'],'ROI');
                        end
   
           end                                           
               