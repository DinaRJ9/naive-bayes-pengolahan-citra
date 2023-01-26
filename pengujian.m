clc; clear; close all; warning off all;
 
%%% Proses pengujian Naive Bayes
% menetapkan lokasi folder data uji
nama_folder = 'data uji';
% menbaca file yang berekstensi .jpg
nama_file = dir(fullfile(nama_folder, '*.jpg'));
% membaca jumlah file yang berektensi .jpg
jumlah_file = numel(nama_file);

% menginisialisasi variabel ciri_uji
ciri_uji = zeros(jumlah_file,4);
% melakukan pengolahan citra terhadap seluruh file
for n = 1:jumlah_file
    % membaca file citra rgb
    Img = imread(fullfile(nama_folder,nama_file(n).name));
  %  figure, imshow(Img)
    % melakukan konversi citra rgb menjadi citra grayscale
    Img_gray = rgb2gray(Img);
  %  figure, imshow(Img_gray)
    % melakukan konversi citra grayscale menjadi citra biner
    bw = im2bw(Img_gray);
  %  figure, imshow(bw)
    % melakukan operasi komplemen 
    bw = imcomplement(bw);
  %  figure, imshow(bw)
    % melakukan operasi morfologi filling holes
    bw = imfill(bw,'holes');
  %  figure, imshow(bw)
    % ekstaksi ciri
    % melakukan konversi citra rgb menjadi citra hsv
    HSV = rgb2hsv(Img);
 %   figure, imshow(HSV)
    % mengekstrak komponen h,s, dan v pada citra hsv
    H = HSV(:,:,1); % Hue / H
    S = HSV(:,:,2); % Saturation
    V = HSV(:,:,3); % Value
    % mengubah nilai piksel background menjadi nol
    H(~bw) = 0;
    S(~bw) = 0; 
    V(~bw) = 0;
  %  figure, imshow(H)
  %  figure, imshow(S)
  %  figure, imshow(V)
 
    % menghitung nilai rata2 h,s, dan v 
    Hue = sum(sum(H))/sum(sum(bw));
    Saturation  = sum(sum(S))/sum(sum(bw));
    Value = sum(sum(V))/sum(sum(bw));
    % menghitung luas objek 
    Luas = sum(sum(bw));
    % mengisi variabel ciri_uji dengan ciri hasil ekstraksi
    ciri_uji(n,1) = Hue;
    ciri_uji(n,2) = Saturation;
    ciri_uji(n,3) = Value;
    ciri_uji(n,4) = Luas;
end

% menyusun variabel kelas_uji
kelas_uji = cell(jumlah_file,1);
% mengisi nama2 ikan pada variabek kelas_latih
for k = 1:3
    kelas_uji{k} = 'cupang';
end
 
for k = 4:6
    kelas_uji{k} = 'guppy';
end
 
for k = 7:9
    kelas_uji{k} = 'koi';
end
 
for k = 10:12
    kelas_uji{k} = 'maskoki';
end

% memanggil model naive bayes hasil pelatihan 
load Mdl
 
% membaca kelas keluaran hasil dari pengujian 
hasil_uji = predict(Mdl,ciri_uji);

% menghitung akurasi pengujian
jumlah_benar = 0;
for k = 1:jumlah_file
    if isequal(hasil_uji{k},kelas_uji{k})
        jumlah_benar = jumlah_benar+1;
    end 
end
 
akurasi_pengujian = jumlah_benar/jumlah_file*100

% menyimpan model naive bayes hasil pelatihan
save Mdl Mdl