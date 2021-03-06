function red = crearRedNeuronal(seniales,salidaDeseada)

[R,Q] = size(seniales);%%Obtienes numero de filas y columnas para la matriz seniales
[S2,Q] = size(salidaDeseada);%%neuronas en la capa de salida 7 tama�o del eye
S1=10;%%neuronas en la capa oculta 10
red = newff(minmax(seniales),[S1 S2],{'tansig' 'logsig'},'traingdx');
red.LW{2,1} = red.LW{2,1}*0.01;
red.b{2} = red.b{2}*0.01;
red.performFcn = 'sse';  %%Suma Square error       
red.trainParam.goal = 0.1;  %%Objetivo para converger  
red.trainParam.show = 20;   %%Actualizar salida de entrenamiento cada ciertos epoch   
red.trainParam.epochs = 5000;  %%numero maximo de iteraciones para que la red converja 
red.trainParam.mc = 0.95;  %%Momentum constante    
red = train(red,seniales,salidaDeseada);  %%Entrenamiento de la red se le envia la red
%%los patrones a reconocer en este caso el alfabeto y ademas las salidas
%%deseadas que representan un caracter.