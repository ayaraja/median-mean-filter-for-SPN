
original_img=imread('c:\IM\lena.png'); 

noise_img = imnoise(original_img, 'salt & pepper', 0.2); 

enhanced_median=im2uint8(zeros(size(noise_img))); 
standard_median=im2uint8(zeros(size(noise_img))); 

[x,y]=size(noise_img); 

% ---------------------- standard median filter -----------------------%
for i = 2:x-1
    for j = 2:y-1
            matrix = noise_img(i-1:i+1,j-1:j+1); %matrix 3x3
            oneD = matrix(:)'; %convert to 1D
            medvalue = median(oneD); %median value from 1D array
            standard_median(i,j) = medvalue; %replaced with corrections
    end;
end;
%----------------------------------------------------------------%


% ---------------------- enhanced filter -----------------------%
black =0; 
white =255;

for i = 2:x-1
    for j = 2:y-1
            matrix = noise_img(i-1:i+1,j-1:j+1); %matrix 3x3
            oneD = matrix(:)'; %convert to 1D
            
            oneD = setdiff(oneD,black);%remove 0
            oneD = setdiff(oneD,white); %remove 255
            
            medvalue = median(oneD); %median value from 1D array
            s = sum(oneD); %summition of oneD elements  
            meanvalue = s /(length(oneD)); % calculate mean
                        
            if (medvalue >= meanvalue)
                enhanced_median(i,j) = medvalue; %replaced with corrections
            else
                enhanced_median(i,j) = meanvalue; %replaced with corrections
            end;
    end;
end;
%--------------------------------------------------------------------------%

n=size(original_img);
M=n(1);
N=n(2);

MSE_Standard = sum(sum((original_img-standard_median).^2))/(M*N);
MSE_enhanced = sum(sum((original_img-enhanced_median).^2))/(M*N);

PNSR_standard = 10*log10(255^2/MSE_Standard);
PNSR_enhanced = 10*log10(255^2/MSE_enhanced);

subplot(1,4,1), imshow(original_img),
subplot(1,4,2), imshow(noise_img),
subplot(1,4,3), imshow(standard_median),
subplot(1,4,4), imshow(enhanced_median),

