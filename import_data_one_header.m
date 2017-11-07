% import data 
% available for just one text header , the other lines are all data

clc;
clear;
ex = importdata('data.txt');
header= ex.textdata(1);
data=ex.data;

