
function output = Distancia(imagenBase)
    img= imagenBase; 

    vehicleDetector = vehicleDetectorACF; % Cargamos el detector de vehiculos
    peopleDetector = peopleDetectorACF; % Cargamos el detector de personas
    
    [cboxes,cscores] = detect(vehicleDetector,img);
    if not (isempty(cboxes))
        indice = find(cscores > 3);
        puntuacioncochesBuenos = cscores(indice);
        cochesBuenos = cboxes(indice,:);
        img = insertObjectAnnotation(img,'rectangle',cochesBuenos,puntuacioncochesBuenos);
    end
    
    
    % Deteccion personas
    [pboxes,pscores] = detect(peopleDetector,img);
    if not (isempty(pboxes))
        indice2 = find(pscores > 3);
        puntuacionpeatonesBuenos = pscores(indice2);
        peatonesBuenos = pboxes(indice2,:);
        img = insertObjectAnnotation(img,'rectangle',peatonesBuenos,puntuacionpeatonesBuenos);
    end
    
    img= rgb2gray(img); % Pasar a escala de grises
    img= imbinarize(img, 'adaptive','Sensitivity',0.4);
    img= imfill(img,'holes');
    SE = strel('rectangle',[5,4]);
    img= imdilate(img,SE);
    BW = edge(img);

    %CALCULO DE DISTANCIAS
    [H,T,R] = hough(BW,'RhoResolution',0.5,'Theta',-90:0.5:89);
    P = houghpeaks(H, 5, 'threshold', ceil(0.3*max(H(:))));
    
    lineasPasodeCebra = houghlines(BW, T, R, P, 'FillGap', 5, 'MinLength', 7);
    
    distPeatones = 99999;
    distCoches = 99999;  
    for i = 1: length(lineasPasodeCebra)
     
        for j = 1: length(cochesBuenos)
            distcoche = sqrt( (cochesBuenos(2,j) - cochesBuenos(1,j)).^2 + (lineasPasodeCebra(i).point2 - lineasPasodeCebra(i).point1).^2);
            if (distcoche < distCoches)
                distCoches = distcoche;
            end
        end
        
        for k = 1: length(peatonesBuenos)
            distpersona = sqrt( (peatonesBuenos(2,k) - peatonesBuenos(1,k)).^2 + (lineasPasodeCebra(i).point2 - lineasPasodeCebra(i).point1).^2);
            if (distpersona < distPeatones)
                distPeatones = distpersona;
            end
        end
    end
    
    % Outputs
    if (distCoches <= distPeatones)%Verde si la distancia de los peatones es menor
        output = true;
    else
        output = false;
    end
    
end