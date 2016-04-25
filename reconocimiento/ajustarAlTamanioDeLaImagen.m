function imagenrecortada = ajustarAlTamanioDeLaImagen(imagen)

% Encontrar los límites de la imagen
[y2temp x2temp] = size(imagen);
x1=1;
y1=1;
x2=x2temp;
y2=y2temp;

% Encontrar a la izquierda espacios en blanco
cntB=1;
while (sum(imagen(:,cntB))==y2temp)%%mientras toda la linea este vacia
    x1=x1+1;
    cntB=cntB+1;
end

% Encontrar arriba espacios en blanco
cntB=1;
while (sum(imagen(cntB,:))==x2temp)%%mientras toda la linea este vacia
    y1=y1+1;
    cntB=cntB+1;
end

% Encontrar a la derecha espacios en blanco
cntB=x2temp;
while (sum(imagen(:,cntB))==y2temp)%%mientras toda la linea este vacia
    x2=x2-1;
    cntB=cntB-1;
end

% Encontrar a bajo espacios en blanco
cntB=y2temp;
while (sum(imagen(cntB,:))==x2temp)%%mientras toda la linea este vacia
    y2=y2-1;
    cntB=cntB-1;
end

% Recortar la imagen hasta los bordes encontrados
imagenrecortada=imcrop(imagen,[x1,y1,(x2-x1),(y2-y1)]); 