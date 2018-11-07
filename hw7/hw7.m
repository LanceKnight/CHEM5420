clear
clc
red = [
    0,0,0,2,2,2,2,2,0,0;
    0,0,2,-10,-10,-10,-10,-10,2,0;
    0,2,-10,-10,-10,2,2,2,0,0;
    0,2,-10,-10,2,0,0,0,0,0;
    0,2,-10,-10,2,2,0,0,0,0;
    0,0,2,2,-10,-10,2,2,2,0;
    0,0,0,2,2,-10,-10,-10,-10,2;
    0,2,2,-10,-10,-10,-10,-10,2,0;
    2,-10,-10,-10,2,2,2,2,0,0;
    0,2,2,2,0,0,0,0,0,0
];

blue = [
    0,2,0,0,0;
    2,-10,2,2,0;
    2,-10,-10,-10,2;
    0,2,-10,-10,2;
    0,2,-10,2,0;
    0,0,2,0,0;
];

%imagesc(blue)

R0 = blue;
R90 = imrotate(blue, 90);
R180 =imrotate(blue, 180);
R270 = imrotate(blue, 270);

for k = 1:4
    if(k ==1)
        R = R0;
    elseif(k==2)
        R = R90;
    elseif(k==3)
        R = R180;
    elseif(k==4)
        R = R270;
    end
        
        
    for i = 0:5

        exp_R = expand(R);
        hor_R = circshift(exp_R, i ,1);
        for j = 0:4

            ver_R = circshift(hor_R, j, 2);
            score(i+1,j+1, k)=get_score(red, ver_R);
        end
    end
end
%{
clear score
score = zeros(3,3,3);
score(1,2,2)=9
%}


score
[x1,y1,z1, v1]=get_max(score)
score(x1,y1,z1)= inf;


[x2,y2,z2,v2]=get_max(score)
score(x2,y2,z2)= inf;

[x3,y3,z3, v3]=get_max(score)


disp( "the best score is "+v1+", if you translate " +(y1-1) +" in x and "+ (x1-1)+" in y, rotate 90 degree")
disp( "the second best score is "+v2+", if you translate " +(y2-1) +" in x and"+ (x2-1)+ " in y, rotate 180 degree")
disp( "the third best score is "+v3+", if you translate " +(y3-1) +" in x and" +(x3-1) +" in y, rotate 90")

map_red = [
    1 0 0
    1 1 1
    252/255 173/255 173/255
    ];
map_blue = [
    0 0 1
    1 1 1
    173/255 205/255 252/255
    ];
%--------------------------original
t = expand(blue)
get_score(t, red);

red_subplot = subplot(4,3,1);
imagesc(red);
title("receptor");
colormap(red_subplot, map_red);
caxis([-1 1])

blue_subplot = subplot(4,3,2);
imagesc(t)
title("original ligand pose")
colormap(blue_subplot, map_blue);
caxis([-1 1])

subplot(4,3,3), 
imagesc(imfuse(t,red))
title("Fused View")

%--------------------------best
t = expand(R90);
t = circshift(t, 4,1);
t = circshift(t, 0,2);
get_score(t, red);

red_subplot = subplot(4,3,4);
imagesc(red);
title("receptor");
colormap(red_subplot, map_red);
caxis([-1 1])

blue_subplot = subplot(4,3,5);
imagesc(t)
title("best pose with score "+v1+" (translate " +(y1-1) +" in x, " +(x1-1) +" in y, rotate 90)")
colormap(blue_subplot, map_blue);
caxis([-1 1])

subplot(4,3,6), 
imagesc(imfuse(t,red))
title("Fused View")
%--------------------------second best
t = expand(R180);
t = circshift(t, 1,1);
t = circshift(t, 3,2);
get_score(t, red);

red_subplot = subplot(4,3,7);
imagesc(red);
title("receptor");
colormap(red_subplot, map_red);
caxis([-1 1])

blue_subplot = subplot(4,3,8);
imagesc(t)
title("best pose with score "+v2+" (translate " +(y2-1) +" in x, " +(x2-1) +" in y, rotate 180)")
colormap(blue_subplot, map_blue);
caxis([-1 1])

subplot(4,3,9), 
imagesc(imfuse(t,red))
title("Fused View")
%--------------------------third best
t = expand(R90);
t = circshift(t, 1,1);
t = circshift(t, 3,2);
get_score(t, red);

red_subplot = subplot(4,3,10);
imagesc(red);
title("receptor");
colormap(red_subplot, map_red);
caxis([-1 1])

blue_subplot = subplot(4,3,11);
imagesc(t)
title("best pose with score "+v3+" (translate " +(y3-1) +" in x, " +(x3-1) +" in y, rotate 90)")
colormap(blue_subplot, map_blue);
caxis([-1 1])

subplot(4,3,12), 
imagesc(imfuse(t,red))
title("Fused View")

%{
k = [
    7,2;
    1,4
    ];
[a,b]= max(k, [],1);
[a,c]=max(a,[],2);
b(c)
c


k = round(rand(4,4)*100+1)
k = sort(k,'descend')
%}

function [x,y,z,v] = get_max(mat)
    [v1, i1] = min(mat);
    [v2, i2]=  min(v1);
    [v3, i3] = min(v2);

    x = i1(1,i2(i3),i3);
    y = i2(i3);
    z = i3;
    v = v3;

end

function score=get_score(mat1, mat2)
    score = sum(mat1.*mat2, 'all');
   
end

function mat2 = expand(mat1)
    mat1(10,10) =0;
    mat2 = mat1;
end
