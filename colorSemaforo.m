
function output = colorSemaforo(nCoches,nPersonas, condicionDistancia)
    if (nCoches < nPersonas)
        output = false;%Rojo
    elseif (nCoches > nPersonas)
        output = true;%rojo
    else %Si hay el mismo numero 
        output = condicionDistancia;%Verde si la distancia de los peatones es menor
    end
end
