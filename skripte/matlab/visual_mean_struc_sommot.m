%% General settings
hchs_dir = 'C:\Users\mschu\Documents\CSI\HCHS\new_cohort\'
conn_dir = [hchs_dir, '/MRI_dwi/matrix_200_7']; 




main_txt_path = [hchs_dir '/social_data'];
absolute_values = 0;
mean_default = []
broken_subjects = 'sub-xxxxx.mat'


BCT_path = 'C:\Users\mschu\Documents\CSI\HCHS\analysis\BCT\2019_03_03_BCT';
addpath(BCT_path);
 

 all_thresh = [ 0];
 num_thresh = length(all_thresh);



 cd(conn_dir)       
 %broken_subjects = 'sub-2016203f.mat'
 


         
%% Sorting Subjects
       
        cd(conn_dir)
        
            all_subjects_str = ls(conn_dir);
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
         
%        tbl = readtable([main_txt_path '/data_mayer_20210917.csv']) ; 
% 
%           id = tbl.DisclosureID;
          
       tbl = readtable([main_txt_path '/data_mayer_20210917.csv']) ; 

                 idx = tbl.HCH_SVAGE0001 < 57
                 tbl = tbl(idx,:);
                 disp(tbl);

            id = tbl.DisclosureID;
         
         % Angleichen der Nomenklatur
             str2 = 'sub-';
         for subjind = 1:length(id)
             csubj = id{subjind};
             nsubj=strcat(str2,csubj); % attach "sub"
             nsubj=strsplit(nsubj); %convert into cell
             id(subjind,:)=nsubj;            
         end

%% Angleichen von Matrizen an Age Datensatz         
         
         % Index der Subjects die in der Demographie Tabelle aber nicht bei
         % den Matrizen enthalten sind
           ex1 = setdiff(id,id_m)  % returns names in id that are not in id_m
           [~,idx] = ismember(id,ex1) % one's on these rows which resemble index of ex1
           [idx1] = find(idx) % returns index numbers of ones 
         
           id(idx1, :) = []; % delete subjects of id which are not in id_m
     
           
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
              
                                            
                      

                      
                      
                       
              for subjind = 1:length(all_subjects)

                            subject = all_subjects{subjind};
                            load([conn_dir '/' subject]);

                                  if absolute_values
                                     Mat = abs(Mat);
                                  else                                    
                                     Mat = max(Mat,0) ; 
                                  end  
                                  
%                                   s=sign(Mat);
%                                   inegatif=sum(s(:)==-1);
%                                   negative_all(subjind,:) = inegatif;
                                  
                                  Mat = threshold_proportional(Mat, (1-thresh));
                                                                    
                               sommot_lh = (15:30); % 
                               sommot_rh = (116:134); 
                               %
                               sommot_index = [ sommot_lh, sommot_rh]; %
                               sommot = Mat(sommot_index, sommot_index);
                                  
                                  conn_all(:,:,subjind)  = sommot;

              end
      end
      

                  Mat = mean(conn_all,3);

                  X = Mat

figure                    
labelnames = {'Vis', 'SomMot','DorsAtt','SalVenAttn', 'Limbic','Control','Default'}
imagesc(X); % plot the matrix
set(gca, 'XTick', [6,  31,  65,  90,  116,  125, 165]); % center x-axis ticks on bins
set(gca, 'YTick', [6,  31,  65,  90,  116,  125, 165]); % center y-axis ticks on bins
set(gca,'XTickLabelRotation', 90)
set(gca, 'XTickLabel',labelnames); % set x-axis labels
set(gca, 'YTickLabel', labelnames); % set y-axis labels
%title('Mean Connectivity', 'FontSize', 14); % set title
colormap(jet); % set the colorscheme
colorbar; % enable colorbar

%% Sorting Subjects
       
        cd(conn_dir)
        
            all_subjects_str = ls(conn_dir);
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

       tbl = readtable([main_txt_path '/data_mayer_20210917.csv']) ; 

                  idx = tbl.HCH_SVAGE0001 > 71
                  tbl = tbl(idx,:);
                  disp(tbl);

                 id = tbl.DisclosureID 


         
         % Angleichen der Nomenklatur
             str2 = 'sub-';
         for subjind = 1:length(id)
             csubj = id{subjind};
             nsubj=strcat(str2,csubj); % attach "sub"
             nsubj=strsplit(nsubj); %convert into cell
             id(subjind,:)=nsubj;            
         end

%% Angleichen von Matrizen an Age Datensatz         
         
         % Index der Subjects die in der Demographie Tabelle aber nicht bei
         % den Matrizen enthalten sind
           ex1 = setdiff(id,id_m)  % returns names in id that are not in id_m
           [~,idx] = ismember(id,ex1) % one's on these rows which resemble index of ex1
           [idx1] = find(idx) % returns index numbers of ones 
         
           id(idx1, :) = []; % delete subjects of id which are not in id_m
     
           
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
              
                                            
                      

                      
                      
                       
              for subjind = 1:length(all_subjects)

                            subject = all_subjects{subjind};
                            load([conn_dir '/' subject]);

                                  if absolute_values
                                     Mat = abs(Mat);
                                  else                                    
                                     Mat = max(Mat,0) ; 
                                  end  
                                  
%                                   s=sign(Mat);
%                                   inegatif=sum(s(:)==-1);
%                                   negative_all(subjind,:) = inegatif;
                                  
                                  Mat = threshold_proportional(Mat, (1-thresh));
                                                                    
                               sommot_lh = (15:30); % 
                               sommot_rh = (116:134); 
                               %
                               sommot_index = [ sommot_lh, sommot_rh]; %
                               sommot = Mat(sommot_index, sommot_index);
                                  
                               conn_all(:,:,subjind)  = sommot;
              end
      end
      
                  
                    

                  Mat = mean(conn_all,3);

                     Y =  Mat
%                   imagesc(Y) ;
                  
%                   [~,idx] = sort(Mat(:,1));
%                     Mat = Mat(idx,:);
figure                    
labelnames = {'Vis', 'SomMot','DorsAtt','SalVenAttn', 'Limbic','Control','Default'}
imagesc(Y); % plot the matrix
set(gca, 'XTick', [6,  31,  65,  90,  116,  125, 165]); % center x-axis ticks on bins
set(gca, 'YTick', [6,  31,  65,  90,  116,  125, 165]); % center y-axis ticks on bins
set(gca,'XTickLabelRotation', 90)
set(gca, 'XTickLabel',labelnames); % set x-axis labels
set(gca, 'YTickLabel', labelnames); % set y-axis labels
%title('Mean Connectivity', 'FontSize', 14); % set title
colormap(jet); % set the colorscheme
colorbar; % enable colorbar


figure
Z = X - Y 
% Z = imabsdiff(X,Y)
imagesc(Z)
set(gca, 'XTick', [6,  31,  65,  90,  116,  125, 165]); % center x-axis ticks on bins
set(gca, 'YTick', [6,  31,  65,  90,  116,  125, 165]); % center y-axis ticks on bins
set(gca,'XTickLabelRotation', 90);
set(gca, 'XTickLabel',labelnames); % set x-axis labels
set(gca, 'YTickLabel', labelnames); % set y-axis labels
%title('Mean Connectivity', 'FontSize', 14); % set title
colormap(winter); % set the colorscheme
colorbar; % enable colorbar

s=sign(Z)
inegatif=sum(s(:)== -1)
ipositif=sum(s(:)== 1)
% inegatif/40000
mean_pos = mean(Z(Z>=0)); %Avg Negatives
mean_neg = mean(Z(Z<=0));
