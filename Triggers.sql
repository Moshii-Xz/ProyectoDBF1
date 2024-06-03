-- Crear la vista materializada
CREATE OR REPLACE FUNCTION AsignarPuntos(posicionFinal INT)
RETURNS INT AS $$
BEGIN
    IF posicionFinal = 1 THEN
        RETURN 25;
    ELSIF posicionFinal = 2 THEN
        RETURN 18;
    ELSIF posicionFinal = 3 THEN
        RETURN 15;
    ELSIF posicionFinal = 4 THEN
        RETURN 12;
    ELSIF posicionFinal = 5 THEN
        RETURN 10;
    ELSIF posicionFinal = 6 THEN
        RETURN 8;
    ELSIF posicionFinal = 7 THEN
        RETURN 6;
    ELSIF posicionFinal = 8 THEN
        RETURN 4;
    ELSIF posicionFinal = 9 THEN
        RETURN 2;
    ELSIF posicionFinal = 10 THEN
        RETURN 1;
    ELSE
        RETURN 0;
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE MATERIALIZED VIEW PuntosPilotos AS
WITH puntos_asignados AS (
    SELECT
        rc.idPiloto,
        AsignarPuntos(rc.posicionFinal) AS puntos
    FROM
        ResultadosCarrera rc
)
SELECT
    p.idPiloto,
    pr.nombre AS nombrePiloto,
    COALESCE(SUM(pa.puntos), 0) AS puntosTotales
FROM
    Pilotos p
LEFT JOIN
    puntos_asignados pa ON p.idPiloto = pa.idPiloto
LEFT JOIN
    Personas pr ON p.idpiloto = pr.idPersona
GROUP BY
    p.idPiloto, pr.nombre;

-- Crear la función para refrescar la vista materializada
CREATE OR REPLACE FUNCTION ActualizarPuntosPilotos()
RETURNS TRIGGER AS $$
BEGIN
    REFRESH MATERIALIZED VIEW PuntosPilotos;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Crear el trigger para actualizar la vista materializada
CREATE TRIGGER ActualizarPuntosLuegoDeInsertar
AFTER INSERT OR UPDATE OR DELETE ON ResultadosCarrera
FOR EACH STATEMENT
EXECUTE FUNCTION ActualizarPuntosPilotos();

CREATE OR REPLACE FUNCTION checkContratoActivoAndPilotosPorTemporada()
RETURNS TRIGGER AS $$
DECLARE
    numContratos INT;
    numPilotos INT;
BEGIN
    -- Verificar si el piloto tiene un contrato activo
    SELECT COUNT(*) INTO numContratos
    FROM PilotosPorEquipo
    WHERE idPiloto = NEW.idPiloto
    AND (fechaDesvinculacion IS NULL OR (fechaDesvinculacion IS NOT NULL AND CURRENT_DATE <= fechaDesvinculacion));

    -- Si existe un contrato activo, se lanza un error
    IF numContratos > 0 THEN
        RAISE EXCEPTION 'El piloto tiene un contrato activo y no puede registrarse en un nuevo equipo';
    END IF;

    -- Verificar si el equipo ya tiene dos pilotos en la misma temporada
    SELECT COUNT(*) INTO numPilotos
    FROM PilotosPorEquipo
    WHERE idEquipo = NEW.idEquipo
    AND temporada = NEW.temporada;

    -- Si el número de pilotos en la misma temporada es mayor o igual a 2, se lanza un error
    IF numPilotos >= 2 THEN
        RAISE EXCEPTION 'El equipo ya tiene dos pilotos registrados para esta temporada';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER beforeInsertPilotosporequipo
BEFORE INSERT ON PilotosPorEquipo
FOR EACH ROW
EXECUTE FUNCTION checkContratoActivoAndPilotosPorTemporada();

CREATE OR REPLACE FUNCTION checkLongitudCircuito()
RETURNS TRIGGER AS $$
DECLARE
    v_longitudMinima INT;
    v_longitudMaxima INT;
BEGIN
    SELECT tc.longitudMinima, tc.longitudMaxima
    INTO v_longitudMinima, v_longitudMaxima
    FROM TipoCircuitos tc
    WHERE tc.idTipoCircuito = NEW.idTipoCircuito;

    IF NEW.longitud < v_longitudMinima OR NEW.longitud > v_longitudMaxima THEN
        RAISE EXCEPTION 'La longitud del circuito no está dentro de los límites permitidos para el tipo de circuito %', NEW.idTipoCircuito;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER checkLongitudCircuitoTrigger
BEFORE INSERT OR UPDATE ON Circuitos
FOR EACH ROW
EXECUTE FUNCTION checkLongitudCircuito();

CREATE OR REPLACE FUNCTION check_event_association()
RETURNS TRIGGER AS $$
BEGIN
    -- Verificar si el evento ya está en GranPremio
    IF EXISTS (SELECT 1 FROM GranPremio WHERE idGranPremio = NEW.idSoporte) THEN
        RAISE EXCEPTION 'El evento ya está asociado a GranPremio';
    END IF;
    
    -- Verificar si el evento ya está en Benefico
    IF EXISTS (SELECT 1 FROM Benefico WHERE idBenefico = NEW.idSoporte) THEN
        RAISE EXCEPTION 'El evento ya está asociado a Benefico';
    END IF;
    
    -- Verificar si el evento ya está en Soporte
    IF EXISTS (SELECT 1 FROM Soporte WHERE idSoporte = NEW.idSoporte) THEN
        RAISE EXCEPTION 'El evento ya está asociado a Soporte';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Creación del trigger
CREATE TRIGGER trigger_check_event_association
BEFORE INSERT ON Soporte
FOR EACH ROW
EXECUTE FUNCTION check_event_association();
