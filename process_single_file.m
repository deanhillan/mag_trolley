clear all
tic;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% For processing the output of the Bartington Spectramag export data
% Change the filenames or (absolute) paths to filenames below
% An absolute path might look like -
% 'H:\Lindfield 2014_09_30\data1.Dat'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input 1: Magnetic channel
filename_mag = 'data_single.Dat';
% Input 2: Distance channel
% Output file to write to
output_file = 'combined_data.dat';
% Track distance (m) to Z sensor
track_dist = 1.14;
% Y (first) sensor offset
y_offset = 0.017;
% X (thrid) sensor offset
x_offset = -0.015;

% Background signal information
% Does background data exist (1=Yes, 0=No)
background_exist = 0;
% Background Input 1: Magnetic channel
filename_mag_back = 'back_single.Dat';
% Background Input 2: Distance channel
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Begin
delimiter = '\t';
startRow = 3;
%% Format string for each line of text:
formatSpec_mag = '%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%[^\n\r]';
%% Open the text file.
disp('Attempting to open data files:')
fileID_mag = fopen(filename_mag,'r');

if (background_exist == 1)
    disp('Attempting to open background data files:')
    fileID_mag_back = fopen(filename_mag_back,'r');

end
    
%% Read columns of data according to format string.
dataArray_mag = textscan(fileID_mag, formatSpec_mag, 'Delimiter', ...
    delimiter, 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, ...
    'ReturnOnError', false);
%% Close the text file.
fclose(fileID_mag);
if (background_exist == 1)
    dataArray_mag_back = textscan(fileID_mag_back, formatSpec_mag, ...
        'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines' , ...
        startRow-1, 'ReturnOnError', false);

    fclose(fileID_mag_back);
end
%% Allocate imported array to column variable names
Times = dataArray_mag{:, 1};
xnT = dataArray_mag{:, 2};
ynT = dataArray_mag{:, 3};
znT = dataArray_mag{:, 4};
dist = dataArray_mag{:, 12};
% Convert potentiometer data to a real distance
dist_conv = -(-dist(1)+dist).*track_dist/(max(dist)-min(dist));
% Interpolate to create x and y offset
dist_conv_x = dist_conv + x_offset;
dist_conv_y = dist_conv + y_offset;

xnT_new = xnT;
ynT_new = ynT;
last_y = 1;
last_x = 1;
for i =1:length(dist_conv)
    for j = 1:length(dist_conv_y)
        cur_dist = abs(dist_conv(i)- dist_conv_y(j));
            if (j==1)
                best_dist = cur_dist;
                best_j = j;
            elseif(cur_dist<best_dist)
                best_dist = cur_dist;
                best_j = j ;
            end   
    end
    last_y = best_j;
    ynT_new(i) = ynT(best_j);

    for j = 1:length(dist_conv_x)
        cur_dist = abs(dist_conv(i)- dist_conv_x(j));
            if (j==1)
                best_dist = cur_dist;
                best_j = j;
            elseif(cur_dist<best_dist)
                best_dist = cur_dist;
                best_j = j ;
            end     
    end
    last_x = best_j;
    xnT_new(i) = xnT(best_j);
end

xnT = xnT_new;
ynT = ynT_new;


max_dist_diff = max(dist - [dist(2:size(dist,1)); dist(size(dist,1))]);

if (background_exist==0)
    fileID_write = fopen(output_file,'w+');
    dlmwrite(output_file,[dist dist_conv xnT ynT znT],'delimiter','\t','precision',4)
    fclose(fileID_write);
else
    Times_back = dataArray_mag_back{:, 1};
    xnT_back = dataArray_mag_back{:, 2};
    ynT_back = dataArray_mag_back{:, 3};
    znT_back = dataArray_mag_back{:, 4};
    dist_back = dataArray_mag_back{:, 12};
    
    dist_back_conv = -(-dist_back(1)+dist_back).*track_dist/(max(dist_back)-min(dist_back));
    dist_back_conv_x = dist_back_conv + x_offset;
    dist_back_conv_y = dist_back_conv + y_offset;

    xnT_back_new = xnT_back;
    ynT_back_new = ynT_back;
    last_y = 1;
    last_x = 1;
    for i =1:length(dist_back_conv)
        for j = 1:length(dist_conv_y)
            cur_dist = abs(dist_back_conv(i)- dist_back_conv_y(j));
                if (j==1)
                    best_dist = cur_dist;
                    best_j = j;
                elseif(cur_dist<best_dist)
                    best_dist = cur_dist;
                    best_j = j ;
                end   
        end
        last_y = best_j;
        ynT_back_new(i) = ynT_back(best_j);

        for j = 1:length(dist_conv_x)
            cur_dist = abs(dist_back_conv(i)- dist_back_conv_x(j));
                if (j==1)
                    best_dist = cur_dist;
                    best_j = j;
                elseif(cur_dist<best_dist)
                    best_dist = cur_dist;
                    best_j = j ;
                end     
        end
        last_x = best_j;
        xnT_back_new(i) = xnT_back(best_j);
    end

    xnT_back = xnT_back_new;
    ynT_back = ynT_back_new;

    % Background to sample interpolation
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
    dlmwrite(output_file,[dist dist_conv xnT_m_back ynT_m_back ... 
        znT_m_back xnT ynT znT xnT_back ynT_back ... 
        znT_back],'delimiter','\t','precision',4)
    fclose(fileID_write);
end

%% Plotting
figure
if (background_exist == 0)
    plot(dist_conv,xnT,'r', 'LineWidth',1.5)
    hold on
    plot(dist_conv,ynT,'LineWidth',1.5)
    plot(dist_conv,znT,'g','LineWidth',1.5)
    legend('X', 'Y', 'Z')
    ylabel('nT')
    xlabel('Distance (m)')
    hold off
else
    plot(dist_conv,xnT_m_back,'r', 'LineWidth',1.5)
    hold on
    plot(dist_conv,ynT_m_back,'LineWidth',1.5)
    plot(dist_conv,znT_m_back,'g','LineWidth',1.5)
    axis tight
    plot(dist_conv,xnT_back, 'r--','LineWidth',0.5)
    plot(dist_conv,ynT_back,'b--','LineWidth',0.5)
    plot(dist_conv,znT_back, 'g--','LineWidth',0.5)
    legend('X-X_b_a_c_k', 'Y-Y_b_a_c_k', 'Z-Z_b_a_c_k', ...
        'X_b_a_c_k', 'Y_b_a_c_k', 'Z_b_a_c_k')
    ylabel('nT')
    xlabel('Distance (m)')
    hold off
end

disp(['Code took : ' num2str(toc) 's'])