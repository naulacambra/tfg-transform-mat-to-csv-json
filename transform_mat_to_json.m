
myDir = uigetdir; %gets directory
myFiles = dir(fullfile(myDir,'it*.mat')); %gets all mat files in struct

channels = {
  'rssi_temporal_A_a'
  'rssi_temporal_A_b'
  'rssi_temporal_A_c'
  'rssi_temporal_A_d' 
  'rssi_temporal_A_e' 
  'rssi_temporal_A_f'
  'rssi_temporal_B_a'
  'rssi_temporal_B_b'
  'rssi_temporal_B_c'
  'rssi_temporal_B_d' 
  'rssi_temporal_B_e' 
  'rssi_temporal_B_f'
  'rssi_temporal_C_a'
  'rssi_temporal_C_b'
  'rssi_temporal_C_c'
  'rssi_temporal_C_d' 
  'rssi_temporal_C_e' 
  'rssi_temporal_C_f'
  'rssi_temporal_D_a'
  'rssi_temporal_D_b'
  'rssi_temporal_D_c'
  'rssi_temporal_D_d' 
  'rssi_temporal_D_e' 
  'rssi_temporal_D_f'
};

tic
for k = 1:length(myFiles)
  baseFileName = myFiles(k).name;
  fullFileName = fullfile(myDir, baseFileName);
  fprintf(1, 'Now reading %s\n', fullFileName);
  reduce = 10;

  rssi = load(fullFileName, channels{:});
  fileInfo = regexp(baseFileName,'it\d{4}_(?<date>\d*)-(?<month>\d*)-(?<year>\d*)_(?<hour>\d*)-(?<minute>\d*)-(?<second>\d*)', 'names');
  
  datetime_from = datetime(str2double(fileInfo.year) + 2000, str2double(fileInfo.month), str2double(fileInfo.date), str2double(fileInfo.hour), str2double(fileInfo.minute), str2double(fileInfo.second), 0);
  datetime_to = datetime(str2double(fileInfo.year) + 2000, str2double(fileInfo.month), str2double(fileInfo.date), str2double(fileInfo.hour), str2double(fileInfo.minute), str2double(fileInfo.second), 10000);
    
  channelInfoArray = repmat(struct("Channel", 0, "From", datetime, "To", datetime, "Values", []), 24, 1);
  
  for c = 1:length(channels)
      valuesArr = rssi.(channels{c});
      avgValuesArr = arrayfun(@(i) mean(valuesArr(i:i+reduce-1)),1:reduce:length(valuesArr)-reduce+1);
      channelInfo = struct("Channel", c, "From", datetime_from, "To", datetime_to, "Values", avgValuesArr);
      channelInfoArray(c) = channelInfo;
  end
  
  json = jsonencode(channelInfoArray);
  filename = sprintf('D:\\Documentos\\TFG\\json-10\\%s', strrep(baseFileName,'mat','json'));
  outputFile = fopen(filename,'w');
  fprintf(outputFile,'%s',json);
  fclose(outputFile);
  toc

end