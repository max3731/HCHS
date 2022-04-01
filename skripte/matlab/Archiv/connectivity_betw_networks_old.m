%% General settings
hchs_dir = '/Users/mschu/Documents/Documents/CSI/HCHS/analysis'
%conn_dir = [hchs_dir, '/fMRI_resting/conn_mat/aroma_matrix'];
% conn_dir = [hchs_dir, '/fMRI_resting/conn_mat/aroma_pvalthresh_matrix'];
 conn_dir = [hchs_dir, '/fMRI_resting/conn_mat/aroma_gsr_matrix'];

% conn_dir = [hchs_dir, '/fMRI_resting/conn_mat/36p_matrix'];

main_txt_path = [hchs_dir '/sozio_data'];
absolute_values = 1;
default_dorsal_all = []
default_salven_all = []
default_sommot_all = []
default_cont_all   = []
default_vis_all    = []
 

BCT_path = '/Users/mschu/Documents/Documents/CSI/HCHS/analysis/BCT/2019_03_03_BCT';
addpath(BCT_path);
 

 all_thresh = [0 0.1 0.3 0.5 0.7 ];%0.9
 num_thresh = length(all_thresh);
 
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
%                          target_dir = [hchs_dir, '/fMRI_resting/conn_mat/mean_aroma_abs_' num2str(thresh) '/between_net'];
%                       else
% 
%                          target_dir = [hchs_dir, '/fMRI_resting/conn_mat/mean_aroma_' num2str(thresh) '/between_net'];
%                              
%                       end


                      if absolute_values

                         target_dir = [hchs_dir, '/fMRI_resting/conn_mat/mean_gsr_aroma_abs_' num2str(thresh) '/between_net'];
                      else

                         target_dir = [hchs_dir, '/fMRI_resting/conn_mat/mean_gsr_aroma_' num2str(thresh) '/between_net'];
                             
                      end
                      
%                       
%                       if absolute_values
% 
%                          target_dir = [hchs_dir, '/fMRI_resting/conn_mat/mean_aroma_pval_abs_' num2str(thresh) '/between_net'];
%                       else
% 
%                          target_dir = [hchs_dir, '/fMRI_resting/conn_mat/mean_aroma_pval_' num2str(thresh) '/between_net'];
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
                                        load([conn_dir '/' subject]);
                                        
                                        if absolute_values
                                           Mat = abs(Mat);
                                        end  
                                        
                                          Mat = threshold_proportional(Mat, (1-thresh));
                                          mean_conn = mean(mean(Mat));

                                         %%  extracting default and dorsal connectivity

                                           default_lh = (74:100); % 
                                           default_rh = (182:200); 
                                           %
                                           default_index = [default_lh,default_rh]; 

                                           dorsal_lh = (31:43); % 
                                           dorsal_rh = (135:147);   

                                           dorsal_index = [ dorsal_lh, dorsal_rh]; %

                                           default_dorsal = Mat(default_index, dorsal_index);
                                           

                                           mean_default_dorsal = mean(default_dorsal);
                                           mean_default_dorsal = mean(mean_default_dorsal);


                                           default_dorsal_all(subjind,:) = mean_default_dorsal;



                                        %%  extracting default and salven connectivity

                                           default_lh = (74:100); % 
                                           default_rh = (182:200); 
                                           %
                                           default_index = [default_lh,default_rh]; 

                                           salven_lh = (44:54); % 
                                           salven_rh = (148:158);  

                                           salven_index = [salven_lh,salven_rh]; %

                                           default_salven = Mat(default_index, salven_index);
                                         

                                           mean_default_salven = mean(default_salven);
                                           mean_default_salven = mean(mean_default_salven);


                                           default_salven_all(subjind,:) = mean_default_salven;

                                        %%  extracting default and sommot connectivity

                                           default_lh = (74:100); % 
                                           default_rh = (182:200); 
                                           %
                                           default_index = [default_lh,default_rh]; 

                                           sommot_lh = (15:30); % 
                                           sommot_rh = (116:134);  

                                           sommot_index = [ sommot_lh, sommot_rh]; %%

                                           default_sommot = Mat(default_index, sommot_index);
                            

                                           mean_default_sommot = mean(default_sommot);
                                           mean_default_sommot = mean(mean_default_sommot);


                                           default_sommot_all(subjind,:) = mean_default_sommot;


                                       %%  extracting default and cont connectivity

                                           default_lh = (74:100); % 
                                           default_rh = (182:200); 
                                           %
                                           default_index = [default_lh,default_rh]; 

                                           cont_lh = (61:73); % 
                                           cont_rh = (165:181); 

                                           cont_index = [cont_lh,cont_rh]; %%

                                           default_cont = Mat(default_index, cont_index);
                                   

                                           mean_default_cont = mean(default_cont);
                                           mean_default_cont = mean(mean_default_cont);


                                           default_cont_all(subjind,:) = mean_default_cont;



                                       %%  extracting default and vis connectivity

                                           default_lh = (74:100); % 
                                           default_rh = (182:200); 
                                           %
                                           default_index = [default_lh,default_rh]; 

                                           vis_lh = (1:14); % 
                                           vis_rh = (101:115); 

                                           vis_index = [vis_lh,vis_rh];; %%

                                           default_vis = Mat(default_index, vis_index);
                                 

                                           mean_default_vis = mean(default_vis);
                                           mean_default_vis = mean(mean_default_vis);


                                           default_vis_all(subjind,:) = mean_default_vis;        

                                       %%  extracting default and vis connectivity

                                           default_lh = (74:100); % 
                                           default_rh = (182:200); 
                                           %
                                           default_index = [default_lh,default_rh]; 

                                           limb_lh = (55:60); % 
                                           limb_rh = (159:164); 

                                           limb_index = [limb_lh,limb_rh]; %%

                                           default_limb = Mat(default_index, limb_index);
                                        

                                           mean_default_limb = mean(default_limb);
                                           mean_default_limb = mean(mean_default_limb);


                                           default_limb_all(subjind,:) = mean_default_limb; 



                                       %%  extracting dorsal and salven connectivity



                                           dorsal_salven = Mat(dorsal_index, salven_index);
                              

                                           mean_dorsal_salven = mean(dorsal_salven);
                                           mean_dorsal_salven = mean(mean_dorsal_salven);


                                           dorsal_salven_all(subjind,:) = mean_dorsal_salven;    

                                       %%  extracting dorsal and sommot connectivity



                                           dorsal_sommot = Mat(dorsal_index, sommot_index);
                                 

                                           mean_dorsal_sommot = mean(dorsal_sommot);
                                           mean_dorsal_sommot = mean(mean_dorsal_sommot);


                                           dorsal_sommot_all(subjind,:) = mean_dorsal_sommot;    


                                       %%  extracting dorsal and cont connectivity



                                           dorsal_cont = Mat(dorsal_index, cont_index);
                                

                                           mean_dorsal_cont = mean(dorsal_cont);
                                           mean_dorsal_cont = mean(mean_dorsal_cont);


                                           dorsal_cont_all(subjind,:) = mean_dorsal_cont;   


                                       %%  extracting dorsal and vis connectivity



                                           dorsal_vis = Mat(dorsal_index, vis_index);
                                    

                                           mean_dorsal_vis = mean(dorsal_vis);
                                           mean_dorsal_vis = mean(mean_dorsal_vis);


                                           dorsal_vis_all(subjind,:) = mean_dorsal_vis;   

                                       %%  extracting dorsal and limb connectivity



                                           dorsal_limb = Mat(dorsal_index, limb_index);
                                

                                           mean_dorsal_limb = mean(dorsal_limb);
                                           mean_dorsal_limb = mean(mean_dorsal_limb);


                                           dorsal_limb_all(subjind,:) = mean_dorsal_limb;   



                                       %%  extracting salven and sommot connectivity



                                           salven_sommot = Mat(salven_index, sommot_index);
                             

                                           mean_salven_sommot = mean(salven_sommot);
                                           mean_salven_sommot = mean(mean_salven_sommot);


                                           salven_sommot_all(subjind,:) = mean_salven_sommot;  



                                      %%  extracting salven and cont connectivity



                                           salven_cont = Mat(salven_index, cont_index);
                             

                                           mean_salven_cont = mean(salven_cont);
                                           mean_salven_cont = mean(mean_salven_cont);


                                           salven_cont_all(subjind,:) = mean_salven_cont;  



                                       %%  extracting salven and vis connectivity



                                           salven_vis = Mat(salven_index, vis_index);
                                  

                                           mean_salven_vis = mean(salven_vis);
                                           mean_salven_vis = mean(mean_salven_vis);


                                           salven_vis_all(subjind,:) = mean_salven_vis;  

                                      %%  extracting salven and limb connectivity



                                           salven_limb = Mat(salven_index, limb_index);
                                

                                           mean_salven_limb = mean(salven_limb);
                                           mean_salven_limb = mean(mean_salven_limb);


                                           salven_limb_all(subjind,:) = mean_salven_limb;  




                                        %%  extracting sommot and cont connectivity



                                           sommot_cont = Mat(sommot_index, cont_index);
                                

                                           mean_sommot_cont = mean(sommot_cont);
                                           mean_sommot_cont = mean(mean_sommot_cont);


                                           sommot_cont_all(subjind,:) = mean_sommot_cont;  




                                       %%  extracting sommot and vis connectivity



                                           sommot_vis = Mat(sommot_index, vis_index);
                                         

                                           mean_sommot_vis= mean(sommot_vis);
                                           mean_sommot_vis = mean(mean_sommot_vis);


                                           sommot_vis_all(subjind,:) = mean_sommot_vis;  



                                       %%  extracting sommot and limb connectivity



                                           sommot_limb = Mat(sommot_index, limb_index);
                                  

                                           mean_sommot_limb= mean(sommot_limb);
                                           mean_sommot_limb = mean(mean_sommot_limb);


                                           sommot_limb_all(subjind,:) = mean_sommot_limb;  




                                      %%  extracting cont and vis connectivity



                                           cont_vis = Mat(cont_index, vis_index);
                                          

                                           mean_cont_vis = mean(cont_vis);
                                           mean_cont_vis = mean(mean_cont_vis);


                                           cont_vis_all(subjind,:) = mean_cont_vis;  




                                       %%  extracting cont and limb connectivity



                                           cont_limb = Mat(cont_index, limb_index);
                                       

                                           mean_cont_limb = mean(cont_limb);
                                           mean_cont_limb = mean(mean_cont_limb);


                                           cont_limb_all(subjind,:) = mean_cont_limb;  



                                       %%  extracting cont and limb connectivity



                                           vis_limb = Mat(vis_index, limb_index);
                                         

                                           mean_vis_limb = mean(vis_limb);
                                           mean_vis_limb = mean(mean_vis_limb);


                                           vis_limb_all(subjind,:) = mean_vis_limb;  

                          end
  
  
                   save([target_dir '/default_dorsal_all'],'default_dorsal_all');
                   save([target_dir '/default_salven_all'],'default_salven_all');
                   save([target_dir '/default_sommot_all'],'default_sommot_all');
                   save([target_dir '/default_cont_all'],'default_cont_all');
                   save([target_dir '/default_vis_all'],'default_vis_all');
                   save([target_dir '/default_limb_all'],'default_limb_all');
                   
                   save([target_dir '/dorsal_salven_all'],'dorsal_salven_all');
                   save([target_dir '/dorsal_sommot_all'],'dorsal_sommot_all');
                   save([target_dir '/dorsal_cont_all'],'dorsal_cont_all');
                   save([target_dir '/dorsal_vis_all'],'dorsal_vis_all');
                   save([target_dir '/dorsal_limb_all'],'dorsal_limb_all');
                   
                   save([target_dir '/salven_sommot_all'],'salven_sommot_all');
                   save([target_dir '/salven_cont_all'],'salven_cont_all');
                   save([target_dir '/salven_vis_all'],'salven_vis_all');
                   save([target_dir '/salven_limb_all'],'salven_limb_all');
                   
                   save([target_dir '/sommot_cont_all'],'sommot_cont_all');
                   save([target_dir '/sommot_vis_all'],'sommot_vis_all');
                   save([target_dir '/sommot_limb_all'],'sommot_limb_all');
                   
                   save([target_dir '/cont_vis_all'],'cont_vis_all');
                   save([target_dir '/cont_limb_all'],'cont_limb_all');
                   
                   save([target_dir '/vis_limb_all'],'vis_limb_all');
              
      end 