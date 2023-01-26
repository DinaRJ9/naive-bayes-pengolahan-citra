clc; clear; close all; warning off all;
 
% Naive bayes
% memanggil menu "browse file"
[nama_file, nama_folder] = uigetfile('*.jpg');
 
% jika ada nama file yang dipilih maka akan mengeksekusi perintah di bawah
% ini
if ~isequal(nama_file,0)
    % membaca file citra rgb
    Img = imread(fullfile(nama_folder,nama_file));
 %   figure, imshow(Img)
    % melakukan konversi citra rgb menjadi citra grayscale
    Img_gray = rgb2gray(Img);
 %   figure, imshow(Img_gray)
    % melakukan konversi citra grayscale menjadi citra biner
    bw = im2bw(Img_gray);
 %   figure, imshow(bw)
    % melakukan operasi komplemen 
    bw = imcomplement(bw);
 %   figure, imshow(bw)
    % melakukan operasi morfologi filling holes
    bw = imfill(bw,'holes');
 %   figure, imshow(bw)
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
 %   figure, imshow(H)
 %   figure, imshow(S)
 %   figure, imshow(V)
    % menghitung nilai rata2 h,s, dan v 
    Hue = sum(sum(H))/sum(sum(bw));
    Saturation  = sum(sum(S))/sum(sum(bw));
    Value = sum(sum(V))/sum(sum(bw));
    % menghitung luas objek 
    Luas = sum(sum(bw));
    % mengisi variabel ciri_uji dengan ciri hasil ekstraksi
    ciri_uji(1,1) = Hue;
    ciri_uji(1,2) = Saturation;
    ciri_uji(1,3) = Value;
    ciri_uji(1,4) = Luas;
    
    % memanggil model naive bayes hasil pelatihan 
    load Mdl
 
    % membaca kelas keluaran hasil dari pengujian 
    hasil_uji = predict(Mdl,ciri_uji);
    
    % menampilkan citra asli dan kelas keluaran hasil pengujian 
    figure, imshow(Img)
    title({['Nama File: ',nama_file],['Kelas Keluaran: ',hasil_uji{1}]})
else
    % jika tidak ada nama file yang dipilih maka akan kembali
    return
end