clear all
tic;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% For combining the output of the Bartington Spectramag export data
% Change the filenames or (absolute) paths to filenames below
% An absolute path might look like -
% 'H:\Lindfield 2014_09_30\data1.Dat'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input 1: Magnetic channel
filename_mag = 'data1.Dat';
% Input 2: Distance channel
filename_dist = 'data2.Dat';
% Output file to write to
output_file = 'combined_data.dat';

% Background signal information
% Does background data exist (1=Yes, 0=No)
background_exist = 1;
% Background Input 1: Magnetic channel
filename_mag_back = 'back1.Dat';
% Background Input 2: Distance channel
filename_dist_back = 'back2.Dat';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Begin
delimiter = '\t';
startRow = 3;
%% Format string for each line of text:
formatSpec_mag = '%f%f%f%f%*s%*s%*s%*s%[^\n\r]';
formatSpec_dist = '%*s%*s%*s%f%*s%*s%*s%*s%[^\n\r]';
%% Open the text file.
disp('Attempting to open data files:')
fileID_mag = fopen(filename_mag,'r');
fileID_dist = fopen(filename_dist,'r');
if (background_exist == 1)
    disp('Attempting to open background data files:')
    fileID_mag_back = fopen(filename_mag_back,'r');
    fileID_dist_back = fopen(filename_dist_back,'r');
end
    
%% Read columns of data according to format string.
dataArray_mag = textscan(fileID_mag, formatSpec_mag, 'Delimiter', ...
    delimiter, 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, ...
    'ReturnOnError', false);
dataArray_dist = textscan(fileID_dist, formatSpec_dist, 'Delimiter', ...
    delimiter, 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, ...
    'ReturnOnError', false);
%% Close the text file.
fclose(fileID_mag);
fclose(fileID_dist);
if (background_exist == 1)
    dataArray_mag_back = textscan(fileID_mag_back, formatSpec_mag, ...
        'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines' , ...
        startRow-1, 'ReturnOnError', false);
    dataArray_dist_back = textscan(fileID_dist_back, formatSpec_dist, ...
        'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines' , ...
        startRow-1, 'ReturnOnError', false);
    fclose(fileID_mag_back);
    fclose(fileID_dist_back);
end
%% Allocate imported array to column variable names
Times = dataArray_mag{:, 1};
xnT = dataArray_mag{:, 2};
ynT = dataArray_mag{:, 3};
znT = dataArray_mag{:, 4};
dist = dataArray_dist{:, 1};

max_dist_diff = max(dist - [dist(2:size(dist,1)); dist(size(dist,1))]);

if (background_exist==0)
    fileID_write = fopen(output_file,'w+');
    dlmwrite(output_file,[dist xnT ynT znT],'delimiter','\t','precision',4)
    fclose(fileID_write);
else
    Times_back = dataArray_mag_back{:, 1};
    xnT_back = dataArray_mag_back{:, 2};
    ynT_back = dataArray_mag_back{:, 3};
    znT_back = dataArray_mag_back{:, 4};
    dist_back = dataArray_dist_back{:, 1};
    
    xnT_m_back = zeros(size(xnT));
    ynT_m_back = zeros(size(ynT));
    znT_m_back = zeros(size(znT));
    last_j = 1;
    for i=1:size(xnT,1)
        for j=last_j:size(xnT_back,1)
            
            cur_dist = abs(dist(i)- dist_back(j));
            if (j==last_j)
                best_dist = cur_dist;
                best_j = j;
            elseif(cur_dist<best_dist)
                best_dist = cur_dist;
                best_j = j ;
            end
            if (best_dist < max_dist_diff)
                break
            end

        end   
        last_j = best_j;
        xnT_m_back(i) = xnT(i) - xnT_back(best_j);
        ynT_m_back(i) = ynT(i) - ynT_back(best_j);
        znT_m_back(i) = znT(i) - znT_back(best_j);
    end

    fileID_write = fopen(output_file,'w+');
    dlmwrite(output_file,[dist xnT_m_back ynT_m_back znT_m_back xnT ...
        ynT znT xnT_back ynT_back znT_back],'delimiter','\t','precision',4)
    fclose(fileID_write);
end

%% Plotting
figure
if (background_exist == 0)
    plot(dist,xnT,'r', 'LineWidth',1.5)
    hold on
    plot(dist,ynT,'LineWidth',1.5)
    plot(dist,znT,'g','LineWidth',1.5)
    legend('X', 'Y', 'Z')
    ylabel('nT')
    xlabel('Distance (arb.)')
    set(gca,'XDir','Reverse')
    hold off
else
    plot(dist,xnT_m_back,'r', 'LineWidth',1.5)
    hold on
    plot(dist,ynT_m_back,'LineWidth',1.5)
    plot(dist,znT_m_back,'g','LineWidth',1.5)
    axis tight
    plot(dist,xnT_back, 'r--','LineWidth',0.5)
    plot(dist,ynT_back,'b--','LineWidth',0.5)
    plot(dist,znT_back, 'g--','LineWidth',0.5)
    legend('X-X_b_a_c_k', 'Y-Y_b_a_c_k', 'Z-Z_b_a_c_k', ...
        'X_b_a_c_k', 'Y_b_a_c_k', 'Z_b_a_c_k')
    ylabel('nT')
    xlabel('Distance (arb.)')
    set(gca,'XDir','Reverse')
    hold off
end

disp(['Code took : ' num2str(toc) 's'])