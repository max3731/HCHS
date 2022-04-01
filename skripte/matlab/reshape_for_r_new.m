
%% General settings
hchs_dir = 'C:\Users\mschu\Documents\CSI\HCHS\new_cohort\'
main_dir = [hchs_dir, '/fMRI_resting/matrix_200_7'];


absolute_values = 0;
no_negative = 1;
target_dir = ['C:\Users\mschu\Documents\CSI\HCHS\analysis\csv_for_R'];
main_txt_path = [hchs_dir '/social_data'];

all_thresh = [0.9 ];

num_thresh = length(all_thresh);

 broken_subjects = 'sub-xxxx.mat' 

%% Sorting Subjects


            all_subjects_str = ls(main_dir);
            all_subjects = cellstr(all_subjects_str);

            
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
                all_subjects = all_subjects';



                       

%% Vorbereiten von Matrizen Datensatz

         id_m = cell(length(all_subjects),1);
         for subjind = 1:length(all_subjects);
             csubj = all_subjects{subjind};
             nsubj=csubj(1:12);   %extract subject name
             nsubj=strsplit(nsubj);% convert into cell
             id_m(subjind,:) = nsubj;       
         end

            id_str = importdata([hchs_dir '/id_subjects.txt']) ;

            tbl = readtable([main_txt_path '/data_mayer_20210917.csv']) ; 

            id = tbl.DisclosureID;
          
         
         % Angleichen der Nomenklatur
             str2 = 'sub-';
         for subjind = 1:length(id)
             csubj = id{subjind};
             nsubj=strcat(str2,csubj); % attach "sub"
             nsubj=strsplit(nsubj); %convert into cell
             id(subjind,:)=nsubj;            
         end

%% Angleichen von Matrizen an Demographie Datensatz      

         % Index der Subjects die in der Demographie Tabelle aber nicht bei
         % den Matrizen enthalten sind
               ex1 = setdiff(id,id_m)  % returns names in id that are not in id_m
               [~,idx1] = ismember(id,ex1) % one's on these rows which resemble index of ex1
               [idx1] = find(idx1) % returns index numbers of ones              
               id(idx1, :) = []; % delete subjects of id which are not in id_m                       
               tbl(idx1, :) = []; %löschen der subjects für die keine Tabelleneinträge existieren
               [~,idx1] = sortrows(tbl(:,2)); % sortieren der Tabelle nach Subject ID
               tbl = tbl(idx1,:);
      %  sortieren des Subject ID arrays
              
               ex2 = setdiff(id_m,id)  % Subjects die in Matrizen aber nicht in Demographie Tabelle exisiteren  
               [~,idx2] = ismember(id_m,ex2)
               [idx2] = find(idx2)               
               id_m(idx2) = [] % %löschen der subjects für die keine Dempgraphie existieren
               all_subjects(idx2) = [] % löschen der Matrizen  die nicht im Demographie Datensatz sind
    
    
              if isequal(id_m,id);
                  display 'Matrizen und Demographie angeglichen'
              else
                  display 'Matrizen und Demographie ungleich'
              end
         
         
                  ex3 = setdiff(id,id_str);
                  [~,idx3] = ismember(id,ex3);
                  [idx3] = find(idx3); 
                  id(idx3, :) = [];
                  tbl(idx3, :) = []; 
                  id_m(idx3) = []
                  all_subjects(idx3) = [] % löschen der Matrizen  die nicht im Demographie Datensatz sind
                  [~,idx3] = sortrows(tbl(:,2)); % sortieren der Tabelle nach Subject ID
                  tbl = tbl(idx3,:);

                  ex4 = setdiff(id_str,id);
                  [~,idx4] = ismember(id_str,ex4);
                  [ex4] = find(idx4); 
                  id_str(ex4, :) = [];


              if isequal(id_str,id);
                  display 'Matrizen und Demographie angeglichen'
              else
                  display 'Matrizen und Demographie ungleich'
              end
          

%% Klinische Variablen aus Demographie Tabelle 

        age = tbl.HCH_SVAGE0001;
        sex = tbl.HCH_SVSEX0001;
        TMTA = tbl.HCH_TMTE0003
        TMTB = tbl.HCH_TMTE0010
    
          

%              psmd = tbl.psmd;
%              intercranial  = tbl.EstimatedTotalIntraCranialVolume;            
%              BrainSegNotVent = tbl.BrainSegNotVent
%              brainvol = BrainSegNotVent./intercranial
%              MeanThicknessL        = tbl.MeanThicknessL;
%              MeanThicknessR        = tbl.MeanThicknessR;
%              mean_thickness = MeanThicknessL+MeanThicknessR;
%              mean_thickness = mean_thickness/2;
%              psmd = tbl.psmd;
%              
%               TMT3 = tbl.HCH_TMTE0003;
%               TMT10 = tbl.HCH_TMTE0010;
%               TMTB = tbl.TMTB
%               weight = tbl.HCH_SVSY0001;

        
        
       %% load network data  
         for ind_thresh = 1:num_thresh;
              thresh  = all_thresh(ind_thresh);
              





                      if absolute_values

                             conn_dir = [hchs_dir, '/fMRI_resting/results_200_7/mean_36_abs_' num2str(thresh)];
                             conn_dir_betw = [hchs_dir, '/fMRI_resting/results_200_7/mean_36_abs_' num2str(thresh) '/between_net'];
                             conn_dir_str =  [hchs_dir, '/MRI_dwi/results_200_7/sift_radius2_0']

                      elseif no_negative    
                             conn_dir = [hchs_dir, '/fMRI_resting/results_200_7/mean_36_no_neg_' num2str(thresh)];
                             conn_dir_betw = [hchs_dir, '/fMRI_resting/results_200_7/mean_36_no_neg_' num2str(thresh) '/between_net'];
                             conn_dir_str =  [hchs_dir, '/MRI_dwi/results_200_7/sift_radius2_0']

                      else
                             conn_dir = [hchs_dir, '/fMRI_resting/results_200_7/mean_36_' num2str(thresh)];
                             conn_dir_betw = [hchs_dir, '/fMRI_resting/results_200_7/mean_36_' num2str(thresh) '/between_net'];
                             conn_dir_str =  [hchs_dir, '/MRI_dwi/results_200_7/sift_radius2_0' ]
                      end  
%                                            
% 
    
                      
         %% Single Network Values functional            
                      cd(conn_dir)
                      all_val_single = ls('mean*');
                      all_val_single     = cellstr(all_val_single)
                      
 
                      
                      all_val_single = all_val_single(~cellfun('isempty', all_val_single));
                      all_val_single = sort(all_val_single);
                      
                      for val_s = 1:length(all_val_single);
                          
                          value_s = all_val_single{val_s};
                          load([conn_dir '/' value_s]);
                               
                      end

         %% Single Network Values structural            
                      cd(conn_dir_str)

                      all_val_single_str = ls('mean*');
                      all_val_single_str     = cellstr(all_val_single_str)
                      
 
                      
                      all_val_single_str = all_val_single_str(~cellfun('isempty', all_val_single_str));
                      all_val_single_str = sort(all_val_single_str);
                      
                      for val_s_str = 1:length(all_val_single_str);
                          
                          val_s_str = all_val_single_str{val_s_str};
                          load([conn_dir_str '/' val_s_str]);
                               
                      end                      
         %% Between Network Values
                      cd(conn_dir_betw)
                      all_val_betw = ls('m*');
                      all_val_betw     = cellstr(all_val_betw)
                      
                      all_val_betw = all_val_betw(~cellfun('isempty', all_val_betw));
                      all_val_betw = sort(all_val_betw);
                      
                      for val_b = 1:length(all_val_betw);
                          
                          value_b = all_val_betw{val_b};
                          load([conn_dir_betw '/' value_b]);
                          %  value_b(idx2) = []
                      end
                      
         %% Structural Network Values
         

                       
%                       cd(struc_dir)
%                       all_val_struc = ls('m*');
%                       all_val_struc     = cellstr(all_val_struc)
%                       
%                       all_val_struc = all_val_struc(~cellfun('isempty', all_val_struc));
%                     %    all_val_betw(1) = []
%                    %     all_val_betw(1) = []
%                       all_val_struc = sort(all_val_struc);
%                       
%                       for val_b = 1:length(all_val_struc);
%                           
%                           value_b = all_val_struc{val_b};
%                           load([struc_dir '/' value_b]);
%                           %  value_b(idx2) = []
%                       end
                     
% 
%   all_val = table(id,age,sex,mean_conn_all, mean_default_all,mean_dorsal_all,mean_salven_all,mean_sommon_all ...
%                   ,mean_cont_all,mean_vis_all, mean_limb_all,mean_global_within_all,default_betw_all,dorsal_betw_all ...
%                   ,salven_betw_all,sommot_betw_all,cont_betw_all,vis_betw_all,limb_betw_all,seg_asso_all,seg_sensor_all ...
%                   ,seg_default_all,seg_dorsal_all,seg_salven_all,seg_sommot_all,seg_cont_all,seg_vis_all,seg_vis_all,seg_limb_all ...
%                   ,mean_default_sign_all,mean_dorsal_sign_all,mean_salven_sign_all);
 

all_val = table( id,age,sex, TMTA, TMTB ... 
                 ,mean_conn_all_str, mean_default_all_str,mean_dorsal_all_str,mean_salven_all_str,mean_cont_all_str ...
                 ,mean_default_sign_all_str,mean_dorsal_sign_all_str,mean_salven_sign_all_str,mean_cont_sign_all_str ...
                 ,seg_global_all,seg_asso_all, seg_sensor_all, seg_default_all,seg_dorsal_all,seg_salven_all,seg_cont_all ...
                 ,mean_default_all,mean_dorsal_all,mean_salven_all,mean_cont_all ...
                 ,default_betw_all,dorsal_betw_all,salven_betw_all,cont_betw_all ...
                 ,mean_conn_all, mean_global_within_all, mean_global_between_all)
 %% Change to Table
 




            if absolute_values
                writetable(all_val,[target_dir '/HCHS_new_' num2str(thresh) '_36_abs.csv'])

            elseif no_negative    

                writetable(all_val,[target_dir '/HCHS_new_' num2str(thresh) '_36_no_neg.csv']) 
          
            else

                writetable(all_val,[target_dir '/HCHS_new_' num2str(thresh) '_36.csv'])

            end
            
            



 end

