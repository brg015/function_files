function [x1,x2,y1,y2] = AddTextToImage(Image,String,Position,Color,Font,FontSize,save_name,flag)

% Image = AddTextToImage(Image,String,Position,Color,Font,FontSize)
%
%   Overlays a rasterized version of the text in String on top of the given
%   Image. The top-left coordinate in pixels is set by Position. Text
%   colour is specified in the variable Color. Font may either be a
%   structure output by BitmapFont or a string specifying a font name.  If
%   the latter, BitmapFont will be called for this font with its size in
%   pixels as specified by FontSize.
%
%   Images may be 1- or 3-channel. Images of class double should have range
%   [0 1] and images of class double should have range [0 255].
%
%   Color specifications should be in the range [0 1] for all RGB and
%   grayscale images regardless of their class.
%
% Daniel Warren
% Particle Therapy Cancer Research Institute
% University of Oxford

if ~exist('Image','var') || isempty(Image)
    % Sample image
    Image = linspace(0,1,500)'*(linspace(0,1,500));
    Image = cat(3,Image,rot90(Image),rot90(Image,2));
end
if ~exist('String','var')
    String = 'No string specified.';
end
if ~exist('Position','var')
    Position = [1 1];
end
if ~exist('Color','var')
    Color = [1 1 0];
end
if ~exist('Font','var')
    Font = 'Arial';
end
if ~exist('FontSize','var')
    FontSize = 32;
end

% uint8 images go from 0 to 255, whereas double ones go from 0 to 1
% if isa(Image, 'uint8')
%     ScaleFactor = 255;
% else
%     ScaleFactor = 1;
% end
ScaleFactor=1; % Don't manipulate my COLORS

% monochrome images need monochrome text, colour images need colour text
if ndims(Image) == 2 %#ok<ISMAT>
    Color = mean(Color(:));
end
if ndims(Image) == 3 && numel(Color) == 1
    Color = [Color Color Color];
end

% remove overflowing text and/or pad mask to image size
TextMask = RasterizeText(String,Font,FontSize);
% This text mask is shitty and needs fixed
row_match=find(sum(TextMask,1)>=1);
col_match=find(sum(TextMask,2)>=1); 
x1=row_match(1); x2=row_match(end);
y1=col_match(1); y2=col_match(end);
TextMask=TextMask(y1:y2,x1:x2);
[Tx,Ty]=size(TextMask);
xL1=Position(1)-round(Tx/2)-1; xL=xL1:xL1+Tx-1;
yL1=Position(2)-round(Ty/2)-1; yL=yL1:yL1+Ty-1;
% Design an assocaited BOX mask
[xx,yy,~]=size(Image);
Cx=round(xx/2); Cy=round(yy/2);
% Setup centered positions
TextMap=zeros(xx,yy);
TextMap(xL,yL)=TextMask;
TextMask=TextMap;

Color2=[1,1,1];
dilate=10; % Number of pixels surrounding box
row_match=find(sum(TextMask,1)>=1);
col_match=find(sum(TextMask,2)>=1); 
x1=row_match(1); x2=row_match(end);
y1=col_match(1); y2=col_match(end);
TextBox=zeros(size(TextMask));
TextBox(y1-dilate:y2+dilate,x1-dilate:x2+dilate)=1; TextBox=logical(TextBox);

if flag==0, return; end

% Setup the masked image
Blank=uint8(ones(size(Image))*255);
for i=1:length(Color)
    tmp = Blank(:,:,i); % to use logical indexing;
    tmp(TextBox==1) = Color2(i);  
    tmp(TextMask==1) = Color(i);  
    Blank(:,:,i) = tmp;
    
    tmp2=Image(:,:,i);
    Box_vals(i,:)=tmp2(TextBox==1);
end

% Calculate alpha based upon Box_vals
trans_calc='linear';
intens=mean(mean(Box_vals));
switch trans_calc
    case 'linear'
        thresh=.4; adder=.1;
        alpha_val=(intens/255)*thresh+adder;
end
ImMask=zeros(size(TextBox));
ImMask(TextBox==1)=alpha_val;
ImMask(TextBox==0)=0;
ImMask(TextMask==1)=1;

% makes center voxels red
% for ii=Cx-5:Cx+5
%     for jj=Cy-5:Cy+5
%         Image(ii,jj,1:3)=[255,1,1];
%     end
% end

% imwrite(~ImMask,save_name);

imshow(Image); hold on; h=imshow(Blank); hold off;
set(h,'AlphaData',ImMask); pause(1);

f=getframe(gcf);
[x,y]=find(f.cdata(:,:,1)==255);
imwrite(f.cdata(min(x):max(x),min(y):max(y),:),save_name);

