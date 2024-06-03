
--1) Cuales son los Puntos totales de los pilotos??
SELECT * FROM PuntosPilotos
ORDER BY puntosTotales DESC;

--2) ¿Cuál es el piloto con más victorias (primer lugar) en carreras, y cuál es el equipo asociado a estas victorias?
CREATE OR REPLACE FUNCTION ObtenerPilotoConMasVictorias()
RETURNS TABLE (Piloto VARCHAR, Equipo VARCHAR, NumeroDeVictorias INT)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT p.nombre AS Piloto, e.nombre AS Equipo, COUNT(*)::integer AS NumeroDeVictorias
    --count devuelve un bigint, por eso se castea a integer
    FROM ResultadosCarrera rc
    JOIN Pilotos pi ON rc.idPiloto = pi.idPiloto
    JOIN Personas p ON pi.idPiloto = p.idPersona
    JOIN Equipos e ON rc.idEquipo = e.idEquipo
    WHERE rc.posicionFinal = 1
    GROUP BY p.nombre, e.nombre
    ORDER BY NumeroDeVictorias DESC
    LIMIT 1;
END;
$$;

SELECT * FROM ObtenerPilotoConMasVictorias();



--3)Cuales son los precios promedio de las boletas por evento? 
CREATE VIEW PreciosPromedioBoletasEvento AS
SELECT 
    ae.idActividad,
    e.nombre AS nombreEvento,
    tb.nombre AS tipoBoleta,
    AVG(ae.precioEntrada) AS precioPromedio
FROM 
    AficionadoEvento ae
JOIN 
    TipoBoleta tb ON ae.idTipoBoleta = tb.idTipoBoleta
JOIN 
    Eventos e ON ae.idActividad = e.idEvento
GROUP BY 
    ae.idActividad, e.nombre, tb.nombre;

SELECT * FROM PreciosPromedioBoletasEvento
ORDER BY precioPromedio DESC;

--4)¿Cuál es el equipo que ha tenido la mayor cantidad de cambios de neumáticos en 
--todas las actividades de un evento específico y cuál es el total de cambios de 
--neumáticos realizados por ese equipo?
CREATE OR REPLACE FUNCTION ObtenerEquipoConMasCambiosNeumaticos(idDelEvento INT)
RETURNS TABLE (Equipo VARCHAR, TotalCambios INT)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT e.nombre AS Equipo, COUNT(*)::integer AS TotalCambios
    FROM CambioNeumaticos cn
    JOIN Equipos e ON cn.idEquipo = e.idEquipo
    WHERE cn.idEvento = idDelEvento
    GROUP BY e.nombre
    ORDER BY TotalCambios DESC
    LIMIT 1;
END;
$$;


SELECT * FROM ObtenerEquipoConMasCambiosNeumaticos(1);

--5) Deseo Listar los equipos con el patrocinio continuo más largo por un solo patrocinador.
CREATE VIEW PatrociniosContinuos AS
SELECT 
    p.idEquipo,
    eq.nombre AS nombreEquipo,
    p.idPatrocinador,
    pat.nombre AS nombrePatrocinador,
    p.fechaInicio,
    p.fechaFinal,
    (p.fechaFinal - p.fechaInicio) AS duracion
FROM 
    Patrocinios p
JOIN 
    Equipos eq ON p.idEquipo = eq.idEquipo
JOIN 
    Patrocinadores pat ON p.idPatrocinador = pat.idPatrocinador;

SELECT * FROM PatrociniosContinuos;


--6)cuál es el país con el mayor número de pilotos que han participado en carreras de Fórmula 1

CREATE OR REPLACE FUNCTION PaisConMasPilotos()
RETURNS VARCHAR(255)
LANGUAGE plpgsql
AS $$
DECLARE
    max_count INT := 0;
    max_country VARCHAR(255);
BEGIN
    SELECT COUNT(*), p.nombre INTO max_count, max_country
    FROM Pilotos pi
    JOIN Personas pe ON pi.idPiloto = pe.idPersona
    JOIN Paises p ON pe.paisNacimiento = p.idPais
    GROUP BY p.nombre
    ORDER BY COUNT(*) DESC
    LIMIT 1;

    RETURN max_country;
END;
$$;

SELECT PaisConMasPilotos();


--7) Cuál es el equipo que ha logrado el mayor número de podios en las carreras de Fórmula 1
CREATE OR REPLACE VIEW PodiosPorEquipo AS
SELECT e.nombre AS equipo, COUNT(*)::integer AS num_podios
FROM ResultadosCarrera rc
JOIN Equipos e ON rc.idEquipo = e.idEquipo
WHERE rc.posicionFinal IN (1, 2, 3)
GROUP BY e.nombre;

SELECT equipo
FROM PodiosPorEquipo
ORDER BY num_podios DESC
LIMIT 1;


-- 8) Listar los eventos y sus fechas donde ha habido más de 3 incidentes:
SELECT e.nombre AS Evento, e.fechaInicio AS FechaInicio, COUNT(ic.idBandera) AS NumIncidentes
FROM IncidentesCarreras ic
JOIN Carreras c ON ic.idCarrera = c.idCarrera
JOIN Actividades act ON c.idCarrera = act.idActividad
JOIN Eventos e ON act.idEvento = e.idEvento
GROUP BY e.nombre, e.fechaInicio
HAVING COUNT(ic.idBandera) > 3;

CREATE VIEW VistaIncidentes AS
SELECT 
    e.nombre AS Evento, 
    e.fechaInicio AS FechaInicio, 
    ic.idBandera AS Incidente
FROM 
    IncidentesCarreras ic
JOIN 
    Carreras c ON ic.idCarrera = c.idCarrera
JOIN 
    Actividades act ON c.idCarrera = act.idActividad
JOIN 
    Eventos e ON act.idEvento = e.idEvento;
	
SELECT * 
FROM VistaIncidentes

--9) Obtener los nombres de los pilotos y sus tiempos de vuelta rápida en 
--carreras donde hicieron la vuelta rápida:
SELECT p.nombre AS Piloto, rc.tiempoVueltaRapida AS TiempoVueltaRapida
FROM ResultadosCarrera rc
JOIN Pilotos pi ON rc.idPiloto = pi.idPiloto
JOIN Personas p ON pi.idPiloto = p.idPersona
WHERE rc.tiempoVueltaRapida IS NOT NULL;

--10) Mostrar los nombres y fechas de los eventos donde se usó cada tipo de neumático, 
--y el número de vueltas en las que fueron cambiados:
SELECT tn.nombre AS TipoNeumatico, e.nombre AS Evento, e.fechaInicio AS Fecha, cn.vueltaCambio AS Vueltas
FROM CambioNeumaticos cn
JOIN TipoNeumatico tn ON cn.idNeumatico = tn.idNeumatico
JOIN Eventos e ON cn.idEvento = e.idEvento;

CREATE VIEW VistaCambiosNeumatico AS
SELECT 
    tn.nombre AS TipoNeumatico, 
    e.nombre AS Evento, 
    e.fechaInicio AS Fecha, 
    cn.vueltaCambio AS Vueltas
FROM 
    CambioNeumaticos cn
JOIN 
    TipoNeumatico tn ON cn.idNeumatico = tn.idNeumatico
JOIN 
    Eventos e ON cn.idEvento = e.idEvento;

select *
FROM VistaCambiosNeumatico

--11)Encontrar el promedio de la temperatura en eventos realizados en
--circuitos con capacidad mayor a 100,000 personas:
SELECT AVG(cl.temperatura) AS PromedioTemperatura
FROM RegistrosClimaticos cl
JOIN Actividades act ON cl.idRegistroClimatico = act.idRegistroClimatico
JOIN Eventos e ON act.idEvento = e.idEvento
JOIN Circuitos c ON e.idCircuito = c.idCircuito
WHERE c.capacidad > 100000;

--12)¿Cuáles fueron los tipos de neumáticos utilizados por los equipos 
--durante la carrera del "Gran Premio de Gran Bretaña"?
SELECT DISTINCT TipoNeumatico.nombre AS tipo_neumatico
FROM CambioNeumaticos
INNER JOIN TipoNeumatico ON CambioNeumaticos.idNeumatico = TipoNeumatico.idNeumatico
INNER JOIN Actividades ON CambioNeumaticos.idActividad = Actividades.idActividad
WHERE Actividades.idEvento = (SELECT idEvento FROM Eventos WHERE nombre = 'Gran Premio de Gran Bretaña');

CREATE OR REPLACE FUNCTION obtener_tipo_neumatico_por_gran_premio(gran_premio_nombre VARCHAR)
RETURNS TABLE(
    tipo_neumatico VARCHAR
) AS $$
BEGIN
    RETURN QUERY
    SELECT DISTINCT 
        TipoNeumatico.nombre AS tipo_neumatico
    FROM 
        CambioNeumaticos
    INNER JOIN 
        TipoNeumatico ON CambioNeumaticos.idNeumatico = TipoNeumatico.idNeumatico
    INNER JOIN 
        Actividades ON CambioNeumaticos.idActividad = Actividades.idActividad
    WHERE 
        Actividades.idEvento = (SELECT idEvento FROM Eventos WHERE nombre = gran_premio_nombre);
END;
$$ LANGUAGE plpgsql;

SELECT *
FROM obtener_tipo_neumatico_por_gran_premio('Gran Premio de Gran Bretaña');

--13) ¿Qué aficionados compraron boletas para el "Gran Premio de Gran Bretaña" y 
--qué tipo de boletas compraron?
SELECT Personas.nombre AS nombre_aficionado, TipoBoleta.nombre AS tipo_boleta
FROM AficionadoEvento
INNER JOIN Personas ON AficionadoEvento.idAficionado = Personas.idPersona
INNER JOIN TipoBoleta ON AficionadoEvento.idTipoBoleta = TipoBoleta.idTipoBoleta
INNER JOIN Actividades ON AficionadoEvento.idActividad = Actividades.idActividad
WHERE Actividades.idEvento = (SELECT idEvento FROM Eventos WHERE nombre = 'Gran Premio de Gran Bretaña');

CREATE OR REPLACE FUNCTION obtener_aficionados_gran_premio(nombre_gran_premio VARCHAR)
RETURNS TABLE (nombre_aficionado VARCHAR, tipo_boleta VARCHAR) AS
$$
BEGIN
    RETURN QUERY 
    SELECT 
        Personas.nombre AS nombre_aficionado, 
        TipoBoleta.nombre AS tipo_boleta
    FROM 
        AficionadoEvento
    INNER JOIN 
        Personas ON AficionadoEvento.idAficionado = Personas.idPersona
    INNER JOIN 
        TipoBoleta ON AficionadoEvento.idTipoBoleta = TipoBoleta.idTipoBoleta
    INNER JOIN 
        Actividades ON AficionadoEvento.idActividad = Actividades.idActividad
    WHERE 
        Actividades.idEvento = (SELECT idEvento FROM Eventos WHERE nombre = nombre_gran_premio);
END;
$$
LANGUAGE plpgsql;

SELECT * 
FROM obtener_aficionados_gran_premio('Gran Premio de Gran Bretaña');

--14) ¿Qué tipos de actividades se llevaron a cabo durante el "Gran Premio de Italia"?
SELECT DISTINCT TipoActividades.nombre AS tipo_actividad
FROM Actividades
INNER JOIN TipoActividades ON Actividades.idTipoActividad = TipoActividades.idTipoActividad
WHERE idEvento = (SELECT idEvento FROM Eventos WHERE nombre = 'Gran Premio de Gran Bretaña');

CREATE OR REPLACE FUNCTION obtener_actividades_gran_premio(nombre_gran_premio VARCHAR)
RETURNS TABLE (tipo_actividad VARCHAR) AS
$$
BEGIN
    RETURN QUERY 
    SELECT DISTINCT TipoActividades.nombre AS tipo_actividad
    FROM Actividades
    INNER JOIN TipoActividades ON Actividades.idTipoActividad = TipoActividades.idTipoActividad
    WHERE idEvento = (SELECT idEvento FROM Eventos WHERE nombre = nombre_gran_premio);
END;
$$
LANGUAGE PLPGSQL;

SELECT * 
FROM obtener_actividades_gran_premio('Gran Premio de Gran Bretaña');

CREATE VIEW VistaTipoActividadTodosGP AS
SELECT DISTINCT TipoActividades.nombre AS tipo_actividad, Eventos.nombre AS nombre_evento
FROM Actividades
INNER JOIN TipoActividades ON Actividades.idTipoActividad = TipoActividades.idTipoActividad
INNER JOIN Eventos ON Actividades.idEvento = Eventos.idEvento;

SELECT *
FROM VistaTipoActividadTodosGP, Actividades
INNER JOIN TipoActividades ON Actividades.idTipoActividad = TipoActividades.idTipoActividad
WHERE idEvento = (SELECT idEvento FROM Eventos WHERE nombre = 'Gran Premio de Gran Bretaña');

--15) ¿Cuál es la velocidad máxima registrada por cada piloto en cada evento y en qué actividad ocurrió?
CREATE VIEW VelocidadMaximaPorPilotoEvento AS
SELECT 
    e.nombre AS Evento,
    a.nombre AS Actividad,
    p.nombre AS Piloto,
    rv.velocidadMaxima
FROM 
    RegistrosVelocidad rv
    INNER JOIN Actividades a ON rv.idActividad = a.idActividad
    INNER JOIN Eventos e ON a.idEvento = e.idEvento
    INNER JOIN Personas p ON rv.idPiloto = p.idPersona;


--16) ¿Cuáles son los pilotos que han participado en carreras, su equipo, el evento en el que participaron, 
--el circuito, y el resultado final en términos de posición, tiempo de vuelta rápida y vueltas completadas, 
--incluyendo la condición climática en la que se desarrolló la carrera?

CREATE VIEW DetallesCarrerasPilotos AS
SELECT 
    p.nombre AS piloto,
    e.nombre AS equipo,
    ev.nombre AS evento,
    c.nombre AS circuito,
    r.posicionFinal,
    r.tiempoVueltaRapida,
    r.vueltasCompletadas,
    cc.nombre AS condicionClimatica
FROM 
    ResultadosCarrera r
JOIN 
    Carreras ca ON r.idCarrera = ca.idCarrera
JOIN 
    Actividades a ON ca.idCarrera = a.idActividad
JOIN 
    Eventos ev ON a.idEvento = ev.idEvento
JOIN 
    Circuitos c ON ev.idCircuito = c.idCircuito
JOIN 
    Ciudades ciu ON c.idCiudad = ciu.idCiudad
JOIN 
    Paises pa ON ciu.idPais = pa.idPais
JOIN 
    Pilotos pi ON r.idPiloto = pi.idPiloto
JOIN 
    Personas p ON pi.idPiloto = p.idPersona
JOIN 
    Equipos e ON r.idEquipo = e.idEquipo
LEFT JOIN 
    RegistrosClimaticos rc ON a.idRegistroClimatico = rc.idRegistroClimatico
LEFT JOIN 
    CondicionesClimaticas cc ON rc.idCondicion = cc.idCondicion;

SELECT * FROM DetallesCarrerasPilotos;

--17)¿Cuál es la relación entre el tiempo de la vuelta más 
--rápida y el número de vueltas completadas por cada piloto en cada carrera?

CREATE VIEW VistaResultadosCarrera AS
SELECT 
    r.idPiloto,
    r.idCarrera,
    r.tiempoVueltaRapida,
    r.vueltasCompletadas
FROM 
    ResultadosCarrera r;

SELECT 
    idPiloto,
    idCarrera,
    tiempoVueltaRapida,
    vueltasCompletadas
FROM 
    VistaResultadosCarrera;


--18) ¿Cuál es el promedio de tiempo de la vuelta más rápida y el número total de vueltas completadas por cada piloto en cada carrera, agrupado por el tipo de circuito?
CREATE OR REPLACE VIEW VistaDetallesCarrera AS
SELECT 
    rc.idCarrera,
    rc.idPiloto,
    c.idCircuito,
    tc.nombre AS tipoCircuito,
    rc.tiempoVueltaRapida,
    rc.vueltasCompletadas
FROM 
    ResultadosCarrera rc
INNER JOIN 
    Carreras cr ON rc.idCarrera = cr.idCarrera
INNER JOIN 
    Actividades a ON cr.idCarrera = a.idActividad
INNER JOIN 
    Circuitos c ON a.idEvento = c.idCircuito
INNER JOIN 
    TipoCircuitos tc ON c.idTipoCircuito = tc.idTipoCircuito;

SELECT 
    tipoCircuito,
    AVG(tiempoVueltaRapida) AS promedioTiempoVueltaRapida,
    SUM(vueltasCompletadas) AS totalVueltasCompletadas
FROM 
    VistaDetallesCarrera
GROUP BY 
    tipoCircuito;

--19) ¿Cuáles pilotos han participado en más de 5 eventos y cuál es su promedio de puntos por evento?

CREATE FUNCTION PilotosConMasDeCincoEventos() RETURNS TABLE(
    Piloto VARCHAR,
    NumeroDeEventos INT,
    PromedioDePuntos FLOAT
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        p.nombre AS Piloto,
        COUNT(DISTINCT e.idEvento) AS NumeroDeEventos,
        AVG(pc.puntosAsociados) AS PromedioDePuntos
    FROM 
        ResultadosCarrera rc
        INNER JOIN Pilotos p ON rc.idPiloto = p.idPiloto
        INNER JOIN Eventos e ON rc.idCarrera = e.idEvento
        INNER JOIN PuntosCarrera pc ON rc.posicionFinal = pc.posicionFinal
    GROUP BY 
        p.nombre
    HAVING 
        COUNT(DISTINCT e.idEvento) > 5;
END;
$$ LANGUAGE plpgsql;

--20) ¿Cuál es el tiempo total acumulado en sesiones de entrenamiento por cada piloto?

CREATE FUNCTION TiempoTotalEntrenamiento(idPiloto INT) RETURNS INTERVAL AS $$
DECLARE
    tiempoTotal INTERVAL;
BEGIN
    SELECT SUM(e.duracion)
    INTO tiempoTotal
    FROM ResultadosEntrenamiento re
    INNER JOIN Entrenamientos e ON re.idEntrenamiento = e.idEntrenamiento
    WHERE re.idPiloto = idPiloto;
    RETURN tiempoTotal;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION ActualizarTiempoTotalEntrenamiento() RETURNS TRIGGER AS $$
BEGIN
    UPDATE Pilotos
    SET tiempoTotalEntrenamiento = TiempoTotalEntrenamiento(NEW.idPiloto)
    WHERE idPiloto = NEW.idPiloto;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER TriggerActualizarTiempoTotalEntrenamiento
AFTER INSERT OR UPDATE ON ResultadosEntrenamiento
FOR EACH ROW
EXECUTE FUNCTION ActualizarTiempoTotalEntrenamiento();
