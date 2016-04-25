function letra = obtenerMatrizDeCaracteristicas(imagen)
% Esta funcion toma una imagen binaria y la cambia a esta para una matriz
% de 5 x 7 que es representado como un simple vector.

imagen_7050=imresize(imagen,[70,50]);
for cnt=1:7
    for cnt2=1:5
        %%Se encuentra el porcentaje de cada caja (100 pixeles por 100 pixeles)
        %%de la imagen que esta vacio ya que negro tiene un valor de cero
        %%por lo tanto no sumara a area ocupada
        porcentajeVacio=sum(imagen_7050((cnt*10-9:cnt*10),(cnt2*10-9:cnt2*10)));
        %%Se asigna el porcentaje a una poscion del vector que representa
        %%la letra.
        letra((cnt-1)*5+cnt2)=sum(porcentajeVacio);
    end
end
letra=((100-letra)/100);%%Se dividen todos los complementos de los valores
%%de la matriz para cien para tener valores entre 0 y 1 que representan
%%el area ocupada.
letra=letra';%%transpuesta de una matriz