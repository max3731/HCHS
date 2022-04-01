
%% General settings
hchs_dir = '/Users/mschu/Documents/CSI/HCHS/analysis'
main_dir = [hchs_dir, '/fMRI_resting/conn_mat/aroma_gsr_matrix'];

conn_dir = [hchs_dir, '/fMRI_resting/conn_mat/mean_aroma'];
absolute_values = 0;
no_negative = 1;
target_dir = [hchs_dir, '/csv_for_R'];
main_txt_path = [hchs_dir '/sozio_data'];

all_thresh = [0.3 ];% 0.9 0.7 0 0.1 0.3
num_thresh = length(all_thresh);

 broken_subjects = 'sub-2016203f.mat' 

%% Sorting Subjects

        
 
             all_subjects = ls(main_dir);
             all_subjects = cellstr(all_subjects);
       
            
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
         
         tbl = readtable([main_txt_path '/data.xlsx']); % Einlesen Demographietabelle
         id = tbl.DisclosureID; % id aus Demographietabelle
          
         
         % Angleichen der Nomenklatur
             str2 = 'sub-';
         for subjind = 1:length(id)
             csubj = id{subjind};
             nsubj=strcat(str2,csubj);
             nsubj=strsplit(nsubj);
             id(subjind,:)=nsubj;            
         end

%% Angleichen von Matrizen an Demographie Datensatz       

         
%                        ex0 = setdiff(id,id_mu)
%                        [~,idx0] = ismember(id,ex0);
%                        [idx00] = find(idx0);
%                        id(idx00, :) = []; 
%                        tbl(idx00, :) = [];
          % Index der Subjects die in der Demographie Tabelle aber nicht bei
          % den Matrizen enthalten sind
           ex1 = setdiff(id,id_m);  
           [~,idx] = ismember(id,ex1);
           [idx1] = find(idx);
         
           id(idx1, :) = [];               
           tbl(idx1, :) = []; %löschen der subjects für die keine Tabelleneinträge existieren
          
          [~,idx] = sortrows(tbl(:,3)); % sortieren der Tabelle nach Subject ID
          tbl = tbl(idx,:);
          id = sort(id); %  sortieren des Subject ID arrays
          
         % Subjects die in Matrizen aber nicht in Demographie Tabelle exisiteren  
          ex3 = setdiff(id_m,id);  
          [~,idx3] = ismember(id_m,ex3);
          [idx3] = find(idx3);
           
          id_m(idx3) = []; % löschen der subjects für die keine Matrizen existieren
          all_subjects(idx3) = []; % löschen der Matrizen  die nicht im Demographie Datensatz sind

          if isequal(id_m,id);
              display 'Matrizen und Demographie angeglichen'
          else
              display 'Matrizen und Demographie ungleich'
          end
         
 %% Angleichen von BrainVolume und WMH an Demographie Datensatz 
          
          tbl_v = readtable([main_txt_path '/BrainVol.dat']);
          [~,idx] = sortrows(tbl_v(:,1)); % sortieren der Tabelle nach Subject ID
          tbl_v = tbl_v(idx,:);
          vol = tbl_v.BrainVol_T1w;
          vol_sub = tbl_v.sub;
        
          [~, ind] = unique(vol_sub);
          duplicate_ind = setdiff(1:size(vol_sub,1),ind);% find double strings 
          duplicate_value = vol_sub(duplicate_ind,1);% find vlaue of double strings
          vol_sub (duplicate_ind) = [];% deleeting double measurements in sub string
          vol(duplicate_ind) = []; % deleeting double measurements in value string

          ex2 = setdiff(vol_sub,id_m);% Index der Subjects die im Volumen aber nicht im Matrizen Datensatz enthalten sind 
          [~,idx2] = ismember(vol_sub,ex2);
          [idx2] = find(idx2);
           
           vol_sub(idx2) = []; %löschen der subjects für die keine Matrizen existieren
           vol(idx2) = [];

          if isequal(vol_sub,id);
              display 'Volumen und Demographie angeglichen'
          else
              display 'Volumen und Demographie ungleich'
          end

          tbl_wmh = readtable([main_txt_path '/WML.dat']);
          [~,idx] = sortrows(tbl_wmh(:,1)); % sortieren der Tabelle nach Subject ID
          tbl_wmh = tbl_wmh(idx,:);                                      
          id_wmh  = tbl_wmh.ID;   
              wml = tbl_wmh.WML ;
          
           ex4 = setdiff(id_wmh,id_m);  % Subjects die in wml aber nicht in Matrizen Datensatz  sind 
           [~,idx1] = ismember(id_wmh,ex4);
           [idx1] = find(idx1);
        
           id_wmh(idx1) = []; % löschen dieser Subejcts aus wml datensatz
              wml(idx1) = []; % löschen der Werte aus wml datensatz die nicht im age Datensatz
              
              
          if isequal(vol_sub,id);
              display 'WMH und Demographie angeglichen'
          else
              display 'WMH und Demographie ungleich'
          end
%% Klinische Variablen aus Demographie Tabelle 

        age = tbl.age;
        sex = tbl.sex;
     

        education = tbl.educationyears;
        
        hypertension =tbl.hypertension;
        
         for k = 1 : length(hypertension)
              cellContents = hypertension{k};
             % Truncate and stick back into the cell
              hypertension{k} = cellContents(1:2);
         end
         hypertension = str2double(hypertension)
         
         diabetes      = tbl.diabetes;
         
         for k = 1 : length(diabetes)
              cellContents = diabetes{k};
             % Truncate and stick back into the cell
              diabetes{k} = cellContents(1:2);
         end
         
          smoking = tbl.smoking_yn;     
          

             psmd = tbl.psmd;
            ratio = wml./vol;
    intercranial  = tbl.EstimatedTotalIntraCranialVolume;            
  BrainSegNotVent = tbl.BrainSegNotVent
  brainvol = BrainSegNotVent./intercranial
    mean_l        = tbl.MeanThicknessL;
    mean_r        = tbl.MeanThicknessR;
   mean_thickness = mean_l+mean_r;
   mean_thickness = mean_thickness/2;
             psmd = tbl.psmd;
             
              TMT = tbl.TMTAB;
              TMTA = tbl.TMTA
              TMTB = tbl.TMTB
              BMI = tbl.BMI;
              GDS = tbl.GDS;
           animal = tbl.animaltest;
             word = tbl.Wortschatz;
             word_perc = tbl.Recall_percentsavings
         sumwords = tbl.Recall_Sumwords ;
         
        
         dementia = tbl.dementiascore


        
       %% load network data  
         for ind_thresh = 1:num_thresh;
              thresh  = all_thresh(ind_thresh);
              




                      if absolute_values

                             conn_dir = [hchs_dir, '/fMRI_resting/conn_mat/mean_gsr_aroma_abs_' num2str(thresh)];
                             conn_dir_betw = [hchs_dir, '/fMRI_resting/conn_mat/mean_gsr_aroma_abs_' num2str(thresh) '/between_net'];

                      elseif no_negative    

                             conn_dir = [hchs_dir, '/fMRI_resting/conn_mat/mean_gsr_aroma_no_neg_' num2str(thresh)];
                             conn_dir_betw = [hchs_dir, '/fMRI_resting/conn_mat/mean_gsr_aroma_no_neg_' num2str(thresh) '/between_net'];
    
                      else
                             conn_dir = [hchs_dir, '/fMRI_resting/conn_mat/mean_gsr_aroma_' num2str(thresh)];
                             conn_dir_betw = [hchs_dir, '/fMRI_resting/conn_mat/mean_gsr_aroma_' num2str(thresh) '/between_net'];
                             
                      end  

    
                      
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
                      all_val_betw = ls('m*');
                      all_val_betw     = cellstr(all_val_betw)
                      
                      all_val_betw = all_val_betw(~cellfun('isempty', all_val_betw));
                    %    all_val_betw(1) = []
                   %     all_val_betw(1) = []
                      all_val_betw = sort(all_val_betw);
                      
                      for val_b = 1:length(all_val_betw);
                          
                          value_b = all_val_betw{val_b};
                          load([conn_dir_betw '/' value_b]);
                          %  value_b(idx2) = []
                      end
                      

                     

%   all_val = table(id,age,sex,wml,vol,ratio,psmd,brainvol,intercranial,BrainSegNotVent,diabetes,mean_thickness,mean_conn_sign_all ... 
%      ,hypertension,smoking,animal,word,sumwords,word_perc,education,TMT,TMTA,TMTB,BMI,GDS,mean_conn_all,mean_cont_all,mean_default_all,mean_dorsal_all,mean_limb_all,mean_salven_all,mean_sommon_all ... 
%      ,mean_vis_all);
 
 all_val = table(id,age,sex,mean_thickness,psmd,education,TMT,TMTA,TMTB,seg_default_all, seg_dorsal_all, seg_salven_all, seg_sommot_all, seg_cont_all, seg_vis_all ...
             ,seg_limb_all, seg_global_all,seg_asso_all, seg_sensor_all,mean_global_within_all,mean_global_between_all,mean_conn_all ...
             ,mean_default_all,mean_dorsal_all,mean_salven_all,mean_sommon_all,mean_cont_all,salven_betw_all,mean_default_sign_all,mean_dorsal_sign_all ...
             ,mean_salven_sign_all)


 %% Change to Table
 




            if absolute_values
                writetable(all_val,[target_dir '/HCHS_conn_' num2str(thresh) '_aroma_gsr_abs.csv'])
                save([target_dir '/all_val_aroma_abs', 'all_val'])

            elseif no_negative    

                writetable(all_val,[target_dir '/HCHS_conn_' num2str(thresh) '_aroma_gsr_no_neg.csv'])
                save([target_dir '/all_val_aroma_abs', 'all_val'])

            else
                writetable(all_val,[target_dir '/HCHS_conn_' num2str(thresh) '_gsr_aroma.csv'])
                save([target_dir '/all_val_aroma_abs', 'all_val'])
            end
            

 end




   