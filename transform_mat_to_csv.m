
myDir = uigetdir; %gets directory
myFiles = dir(fullfile(myDir,'it*.mat')); %gets all wav files in struct
tic
for k = 1:length(myFiles)
  baseFileName = myFiles(k).name;
  fullFileName = fullfile(myDir, baseFileName);
  fprintf(1, 'Now reading %s\n', fullFileName);
  
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

  rssi = load(fullFileName, channels{:});
  matrix = zeros(24,100000);
  
  for c = 1:length(channels)
      matrix(c, 1:100000) = rssi.(channels{c});
  end
  
  writematrix(matrix, sprintf('D:\\Documentos\\TFG\\csv\\%s', strrep(baseFileName,'mat','csv')));
  toc

end