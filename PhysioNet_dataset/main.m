% determine how many subs' data to extract
n_subject = 20;
% the scripts stay in the same directory with edf files
% edf files are downloaded from 
% https://physionet.org/content/eegmmidb/1.0.0/
root = 'files/';  
runs = [4, 6, 8, 10, 12, 14];
for i = 1 : n_subject
    folder_name = sprintf('S%03d/', i);
   % each sub extract data from
   % R 4 6 8 10 12 14
   % for motor imagery tasks
   X_data = [];
   y_data = [];
   for j = 1: length(runs)
       run = runs(j);
              file_name = sprintf('S%03dR%02d.edf', i, run);
       load_path = [root, folder_name, file_name];
       [X, y] = process_one(load_path, file_name, run);
       X_data = cat(1, X_data, X);
       y_data = [y_data, y];
   end
   save_path = ['mat_format/', sprintf('S%03d.mat', i)];
   save(save_path, 'X_data', 'y_data');
end