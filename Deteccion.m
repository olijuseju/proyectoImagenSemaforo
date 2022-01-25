function output = Deteccion(imgOrigen)
    Img = imgOrigen; 
    Img = rgb2gray(Img); % Pasar a escala de grises
   
    vehicleDetector = vehicleDetectorACF('front-rear-view'); % Detector de vehiculos
    detectorPeople = peopleDetectorACF('inria-100x41'); % Detector de personas
    
    numCoches = 0;
    numPersonas = 0;
    
    % Deteccion vehiculos
    [cboxes,cscores] = detect(vehicleDetector,Img);
    if not (isempty(cboxes))
        indice = find(cscores > 4);
        puntuacioncochesBuenos = cscores(indice);
        cochesBuenos = cboxes(indice,:);
        Img = insertObjectAnnotation(Img,'rectangle',cochesBuenos,puntuacioncochesBuenos);
        numCoches = size(cochesBuenos);
    end
    
    
    % Deteccion personas
    [pboxes,pscores] = detect(detectorPeople,Img);
    if not (isempty(pboxes))
        indice2 = find(pscores > 4);
        puntuacionpeatonesBuenos = pscores(indice2);
        peatonesBuenos = pboxes(indice2,:);
        Img = insertObjectAnnotation(Img,'rectangle',peatonesBuenos,puntuacionpeatonesBuenos);
        numPersonas = size(peatonesBuenos);

    end
    
    
    
    % Return
    output = [numCoches(1); numPersonas(1)];
end

