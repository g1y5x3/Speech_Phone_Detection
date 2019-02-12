subject_train = 25:39;
subject_test = 40;

delete sub_train.txt

fileID = fopen('sub_train.txt', 'w');
fprintf(fileID, 'R%03d\n', subject_train(1:end-1));
fprintf(fileID, 'R%03d', subject_train(end));
fclose(fileID);