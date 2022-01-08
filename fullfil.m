function [img2] = fullfil (img_bin,img)


se = ones(3);

BIN = img_bin;

    for i = 1 : 5
        BIN = imerode(BIN,se);
    end;
    
    pos = find ((BIN == 1) & (img == min(min(img))));
    
    A = zeros(size(img,1),size(img,2));
    
    A(pos) = 1;
    
    A(1:5,:) = 0;
    A((size(img,1)-5):size(img,1),:) = 0;
    A(:,1:5) = 0;
    A(:,(size(img,2)-5):size(img,2)) = 0;
    
    LABEL = bwlabel(A,8);
    
    HOLES = unique(LABEL);
    
    
    INTER_L = zeros(size(img,1),size(img,2));
    
    INTER_C = zeros(size(img,1),size(img,2));
    
    for j = 2 : size(HOLES,1)
        
        h = HOLES(j);
        
        [linha,coluna] = find(LABEL == h);
        
        for L = min(linha) : max(linha)
            
            FL = find((LABEL(L,:) == h), 1, 'first');

            LL = find((LABEL(L,:) == h), 1, 'last');
            
            if FL <= LL
                pos = [FL:LL];
            end;
            
            if FL > LL
                pos = [FL:-1:LL];
            end;
            
            
            P1 = double(img(L,(LL+1))-img(L,(FL-1)));
            P2 = P1/(size(pos,2)+1);
            passo = P2;           
            
            
            if passo ~= 0 
            
                if FL <= LL

                    value = [double(img(L,(FL-1))):passo:double(img(L,(LL+1)))];

                end;

%                 if FL > LL
% 
%                     value = [double(img(L,(FL-1))):-passo:double(img(L,(LL+1)))];
% 
%                 end;
            end;

            
            if passo == 0
                
                value = double(img(L,(FL-1)))*ones(1,size(pos,2));                
                
            end;
            
%             if sum(value < 1000)~=0
%              
%                 Z = find (value < 1000);
%                 
%                 value(Z) = 0;              
%             
%             end;
            
            value = round(value);
            
            if passo ~= 0
                
                value = value(:,2:(end-1));
                
            end;

            for V = 1 : size(pos,2)

                INTER_L(L,pos(V)) = value(1,V);
                         
            end;
%             
%             %%%%%%%%%%%%%%%%%%%%%%%%%%%
%             T = sum(value<0);
%             if T~=0
%                 L
%                 j
%             end;
%             %%%%%%%%%%%%%%%%%%%%%%%%%%%
            clear value 
            clear pos
            clear passo
            clear FL
            clear LL 
            
        end;   
        
        for C = min(coluna) : max(coluna)
            
            FC = find((LABEL(:,C) == h), 1, 'first');

            LC = find((LABEL(:,C) == h), 1, 'last');
            
            if FC <= LC
                pos = [FC:LC];
            end;
            
            if FC > LC
                pos = [FC:-1:LC];
            end;
            
            
            P1 = double(img((LC+1),C)-img((FC-1),C));
            P2 = P1/(size(pos,2)+1);
            passo = P2;           
            
            
            if passo ~= 0 
            
                if FC <= LC

                    value = [double(img((FC-1),C)):passo:double(img((LC+1),C))];

                end;

                if FC > LC

                    value = [double(img((FC-1),C)):-passo:double(img((LC+1),C))];

                end;
            end;
            
            if passo == 0
                
                value = double(img((FC-1),C))*ones(1,size(pos,2));                
                
            end;
            
%             if sum(value < 1000)~=0
%              
%                 Z = find (value < 1000);
%                 
%                 value(Z) = 0;              
%             
%             end;
            
            value = round(value);
            
            if passo ~= 0
                
                value = value(:,2:(end-1));
                
            end;

            for V = 1 : size(pos,2)

                INTER_C(pos(V),C) = value(1,V);
                         
            end;
            
%             %%%%%%%%%%%%%%%%%%%%%%%%%%%
%             T = sum(value<0);
%             if T~=0
%                 L
%                 j
%             end;
%             %%%%%%%%%%%%%%%%%%%%%%%%%%%
            clear value 
            clear pos
            clear passo
            clear FL
            clear LL 
            
        end;  
    
    end;

PL = find(INTER_L<-50);
INTER_L(PL) = 0;
    
PC = find(INTER_C<-50);
INTER_C(PC) = 0;


INTER = round((INTER_C + INTER_L)/2);

for i = 1 : size(img,1)
    for j = 1 : size(img,2)
        
        x = img(i,j);
        
        if x > 0
            
            INTER(i,j) = x;
            
        end;
        
    end;
end;


img2 = uint16(INTER);
 
imwrite(img2,'SRTM.tif');
    
    
end