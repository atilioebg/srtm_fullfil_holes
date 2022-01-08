function [table] = area_muni(declividade)

%%%%%%%%%%%%%%%%%%%% CALCULAR ÀREA CLASSIFICADA %%%%%%%%%%%%%%%%%%%%%%%%%%%
% IN:
% MUNICIPIO:     imagem raster com os municipios rotulados
% CLASSIFICACAO: imagem classificada pela rede neural
% 
% OUT:
% TABLE: 1a coluna informa o codigo IBGE do municipio, 2a coluna o total
%        de pixels classificados no municipio
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

p1 = find ((-100 <= declividade) & (declividade < 3));

p2 = find ((3 <= declividade) & (declividade < 8));

p3 = find ((8 <= declividade) & (declividade < 20));

p4 = find ((20 <= declividade) & (declividade < 45));

p5 = find ((45 <= declividade) & (declividade < 75));

p6 = find ((75 <= declividade) & (declividade < 200));



table = [table zeros(size(table,1),1)];

    for i = 1 : size(pos_class) 
        
            x = municipio(pos_class(i));
            
            y = classificacao(pos_class(i));            
                
            pos_table = find (table(:,1) == x);
            
            table(pos_table,2) = table(pos_table,2) + 1;                
    end;
    
    table = double(table);
    
    save('table.txt', 'table', '-ASCII');
end