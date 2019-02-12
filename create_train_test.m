subject_train = 31:39;
subject_test = 40;
label = 'the dew shimmered over my shiny blue shell again'; 

delete sub_train.txt sub_test.txt label_train.txt label_test.txt

% Create files for training subjects
fileID = fopen('sub_train.txt', 'w');
fprintf(fileID, 'R%03d\n', subject_train(1:end-1));
fprintf(fileID, 'R%03d', subject_train(end));
fclose(fileID);

fileID = fopen('label_train.txt', 'w');
fprintf(fileID, '%s', label);
fclose(fileID)

% Create files for testing subjects
fileID = fopen('sub_test.txt', 'w');
fprintf(fileID, 'R%03d', subject_test);
fclose(fileID);

fileID = fopen('label_test.txt', 'w');
fprintf(fileID, '%s', label);
fclose(fileID)