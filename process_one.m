function [X, y] = process_one(load_path, file_name, R)

%%
% label:       0          1            2           3 
% stand for: left fist, right fist, both fist, both feet
% event type: T0 T1 T2
% T0: rest;  1
% T1: left fist or both fists 2
% T2: right fist or both feet 3 
% R 4 6 8 10 12 14
% 4 8 12 for left and right fist
% 6 10 14 for both fist and feet
%%

EEG = pop_biosig(load_path);
labels = [];
datas = {};  % not sure for the total num of trials
event = EEG.event;
for i = 1: length(event)
    if event(i).edftype == 1  
        continue;  % rest  state, skip
    end
    
    
    %% determine the label
    if event(i).edftype == 2
        if R == 4 || R == 8 || R == 12
            % left fist label = 0
            labels = [labels, 0];
        elseif R == 6 || R == 10 || R == 14
            % both fists label = 2
            labels = [labels, 2];
        end
    elseif event(i).edftype == 3
        if R == 4 || R == 8 || R == 12
            % right fist labe = 1
            labels = [labels, 1];
        elseif R == 6 || R == 10 || R == 14
            % both feet label = 3
            labels = [labels, 3];
        end
    end
    %% data process
    fs = EEG.srate;
    prefix = 0.5 * fs;  % keep 0.5 sec prefix data
    latency = event(i).latency;
    start_t = latency - prefix;
    data_length = fs * 4;
    cur_data = EEG.data(:, start_t: start_t + data_length - 1);
    datas{end + 1} = reshape(cur_data, 1, size(cur_data, 1), size(cur_data, 2));
end

datas = cat(1, datas{:});
X = datas;
y = labels;
