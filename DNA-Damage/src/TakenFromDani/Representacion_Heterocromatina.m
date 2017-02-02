function [Diapositiva]=Representacion_Heterocromatina(serie,cell,corte_max,rect,Diapositiva)

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
Tam_imagen_um_z=0.21*corte_max; %umetro

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
numg=20;
numr=20;
color_nodos_verdes=[0 0.5 0];
color_nodos_rojos=[0.6 0 0];

dibujo(num_hetero_um,2);
hold on;plot3(eje_x_green_node,Tam_imagen_rect_um_y-eje_y_green_node,eje_z_green_node,'.','Color',color_nodos_verdes,'MarkerSize', numg)
xlabel('Eje X')
ylabel('Eje Y')
zlabel('Eje Z')

title('Relacion Heterocromatina con picos gH2AX');
stringres=strcat('Proyeccion_General_3D_FOCI-VERDE.tiff');
ncc=strcat('Imagenes_Serie_',serie,'_resultados');
if isdir(ncc)~=1
    mkdir(ncc)
end
cd (ncc)
nccb=strcat('Celula_',cell);
cd (nccb)
ncca=strcat('Imagenes_Serie_',serie,'_Representacion-3D');
if isdir(ncca)~=1
    mkdir(ncca)
end
cd (ncca)
Diapositiva=Diapositiva+1;
Diapositivach=num2str(Diapositiva);
numeracion=strcat('-f',Diapositivach);
print(numeracion,'-dtiff',stringres)
cd ..
cd ..
cd ..

if length(eje_x_red_node)~=0
    
    dibujo(num_hetero_um,2);
    hold on;plot3(eje_x_red_node,Tam_imagen_rect_um_y-eje_y_red_node,eje_z_red_node,'.','Color',color_nodos_rojos,'MarkerSize', numr)
    xlabel('Eje X')
    ylabel('Eje Y')
    zlabel('Eje Z')
    
    title('Relacion Heterocromatina con picos de 53BP1');
    stringres=strcat('Proyeccion_General_3D_FOCI-ROJO.tiff');
    cd (ncc)
    cd (nccb)
    cd (ncca)
    Diapositiva=Diapositiva+1;
    Diapositivach=num2str(Diapositiva);
    numeracion=strcat('-f',Diapositivach);
    print(numeracion,'-dtiff',stringres)
    cd ..
    cd ..
    cd ..
end

name=strcat('Datos_Serie_',serie,'_resultados_heterocromatina');
if isdir(name)~=1
    mkdir(name)
end
cd (name)
nombre2=strcat('Serie_',serie,'_celula_',cell);
stringres=strcat(nombre2,'_hetero_results.mat');
save (stringres,'Matriz_resultado','Pos_x','Pos_y','Pos_z','num_hetero','num_hetero_um')
cd ..