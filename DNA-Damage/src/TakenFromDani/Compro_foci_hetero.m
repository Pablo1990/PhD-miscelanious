function Compro_foci_hetero(serie,cell,corte_max,rect,Diapositiva)

%% DATOS DEL PLANO AZUL
canal=num2str(2);
n=strcat('Datos_Serie_',serie,'_valores_intermedios');
cd (n)
n2=strcat('segmentacion_Serie_',serie,'_ch_',canal,'_celula_',cell);
load (n2)
cd ..

n=strcat('Datos_Serie_',serie,'_resultados');
cd (n)
n2=strcat('Serie_',serie,'_celula_',cell,'_results');
load (n2)
cd ..



% Datos de medida de la imagen
Tam_imagen_pix_x=1024; %pixeles
Tam_imagen_pix_y=1024; %pixeles
Tam_imagen_um_x=82.01; %umetro
Tam_imagen_um_y=82.01; %umetro
Tam_imagen_um_z=0.17*corte_max; %umetro

% Pasamos las medidas de picos de foci de pixeles a micrometro

Rel_dist_x=Tam_imagen_um_x/Tam_imagen_pix_x;
Rel_dist_y=Tam_imagen_um_y/Tam_imagen_pix_y;
Rel_dist_z=Tam_imagen_um_z/corte_max;

Tam_imagen_rect_pix_y=rect(4); %pixeles
Tam_imagen_rect_um_y=Tam_imagen_rect_pix_y*Rel_dist_y;
%Obtenemos en num_hetero la posicion de los pixeles en las 3 dimensiones de
%cada heterocromatina presente en la celula bajo evaluacion.
objeto=1;
Pos_x=[];
Pos_y=[];
Pos_z=[];


for i=1:size(Matriz_resultado,1)
    if Matriz_resultado{i,1}==objeto
        Pos_x=[Pos_x;Matriz_resultado{i,6}(:,1)];
        Pos_y=[Pos_y;Matriz_resultado{i,6}(:,2)];
        Base=zeros(size(Matriz_resultado{i,6}(:,1),1),1);
        Bas=Base+Matriz_resultado{i,2};
        Pos_z=[Pos_z;Bas];
    else
        Posicion=[Pos_x Pos_y Pos_z];
        num_hetero{objeto}=Posicion;
        Pos_x=[];
        Pos_y=[];
        Pos_z=[];
        Posicion=[Pos_x Pos_y Pos_z];
        objeto=objeto+1;
        Pos_x=[Pos_x;Matriz_resultado{i,6}(:,1)];
        Pos_y=[Pos_y;Matriz_resultado{i,6}(:,2)];
        Base=zeros(size(Matriz_resultado{i,6}(:,1),1),1);
        Bas=Base+Matriz_resultado{i,2};
        Pos_z=[Pos_z;Bas];
    end
end
Posicion=[Pos_x Pos_y Pos_z];
num_hetero{objeto}=Posicion;

for i=1:objeto
    num_hetero_um{i}(:,1)=num_hetero{i}(:,1)*Rel_dist_x;
    num_hetero_um{i}(:,2)=Tam_imagen_rect_um_y-(num_hetero{i}(:,2)*Rel_dist_y);
    num_hetero_um{i}(:,3)=(num_hetero{i}(:,3)-1)*Rel_dist_z;
end
dibujo(num_hetero_um,2);
%% DATOS DEL PLANO VERDE
canal=num2str(1);
n=strcat('Datos_Serie_',serie,'_valores_intermedios');
cd (n)
n2=strcat('Deteccion_de_nodos_Serie_',serie,'_ch_1_celula_',cell);
load (n2)
cd ..

objeto=1;
Pos_x=[];
Pos_y=[];
Pos_z=[];


for i=1:size(Matriz_resultadov,1)
    if Matriz_resultadov{i,1}==objeto
        Pos_x=[Pos_x;Matriz_resultadov{i,11}(:,1)];
        Pos_y=[Pos_y;Matriz_resultadov{i,11}(:,2)];
        Base=zeros(size(Matriz_resultadov{i,11}(:,1),1),1);
        Bas=Base+Matriz_resultadov{i,2};
        Pos_z=[Pos_z;Bas];
    else
        Posicion=[Pos_x Pos_y Pos_z];
        num_foci_verde{objeto}=Posicion;
        Pos_x=[];
        Pos_y=[];
        Pos_z=[];
        Posicion=[Pos_x Pos_y Pos_z];
        objeto=objeto+1;
        Pos_x=[Pos_x;Matriz_resultadov{i,11}(:,1)];
        Pos_y=[Pos_y;Matriz_resultadov{i,11}(:,2)];
        Base=zeros(size(Matriz_resultadov{i,11}(:,1),1),1);
        Bas=Base+Matriz_resultadov{i,2};
        Pos_z=[Pos_z;Bas];
    end
end
Posicion=[Pos_x Pos_y Pos_z];
num_foci_verde{objeto}=Posicion;
for i=1:objeto
    num_foci_verde_um{i}(:,1)=num_foci_verde{i}(:,1)*Rel_dist_x;
    num_foci_verde_um{i}(:,2)=Tam_imagen_rect_um_y-(num_foci_verde{i}(:,2)*Rel_dist_y);
    num_foci_verde_um{i}(:,3)=(num_foci_verde{i}(:,3)-1)*Rel_dist_z;
end
dibujo(num_foci_verde_um,1);
