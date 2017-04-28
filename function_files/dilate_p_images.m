% BRG 2014 
% Function file
% dilate_p_images
%
function dilate_p_images(image_file,p_chance,grain_size)

[rut,nam,suf]=fileparts(image_file);

M=load_nii(image_file);

M.img=M.img-p_chance;
M_dilate=M.img;
M_mask=M.img;
M_mask(~isnan(M_mask))=1;


SL=[-grain_size:grain_size]; SL=SL(SL~=0);

for jj=1:size(M.img,3)
    [x,y]=find(~isnan(M.img(:,:,jj)));
    for ii=1:length(x)
        Central_Value=M.img(x(ii),y(ii),jj);
        for x_inc=SL, for y_inc=SL, for z_inc=SL,    
            if ((x(ii)+x_inc)<=M.hdr.dime.dim(2)     && ...
                    (y(ii)+y_inc)<=M.hdr.dime.dim(3) && ...
                    (jj+z_inc)<=M.hdr.dime.dim(4)    && ...
                    (x(ii)+x_inc)>0 && ...
                    (y(ii)+y_inc)>0 && ...
                    (jj+z_inc)>0 )
                       
                if isnan(M_dilate(x(ii)+x_inc,y(ii)+y_inc,jj+z_inc))
                    M_dilate(x(ii)+x_inc,y(ii)+y_inc,jj+z_inc)=Central_Value;
                else
                    M_dilate(x(ii)+x_inc,y(ii)+y_inc,jj+z_inc)=M_dilate(x(ii)+x_inc,y(ii)+y_inc,jj+z_inc)+Central_Value;
                end
                
                if isnan(M_mask(x(ii)+x_inc,y(ii)+y_inc,jj+z_inc))
                    M_mask(x(ii)+x_inc,y(ii)+y_inc,jj+z_inc)=1;
                else
                    M_mask(x(ii)+x_inc,y(ii)+y_inc,jj+z_inc)=M_mask(x(ii)+x_inc,y(ii)+y_inc,jj+z_inc)+1;
                end
                        
            end % if fits
        end; end; end;
    end
end

M.img=M_dilate./M_mask;
save_nii(M,fullfile(rut,[nam '_d' num2str(grain_size),suf]));

M.img=M_dilate;
save_nii(M,fullfile(rut,[nam '_values' num2str(grain_size),suf]));

M.img=M_mask;
save_nii(M,fullfile(rut,[nam '_mask' num2str(grain_size),suf]));
        