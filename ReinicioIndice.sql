-- Reiniciar la secuencia de Paises
SELECT pg_get_serial_sequence('Paises', 'idpais');
ALTER SEQUENCE Paises_idPais_seq RESTART WITH 1;

-- Reiniciar la secuencia de Ciudades
SELECT pg_get_serial_sequence('Ciudades', 'idciudad');
ALTER SEQUENCE Ciudades_idCiudad_seq RESTART WITH 1;

-- Reiniciar la secuencia de TipoCircuitos
SELECT pg_get_serial_sequence('TipoCircuitos', 'idtipocircuito');
ALTER SEQUENCE TipoCircuitos_idTipoCircuito_seq RESTART WITH 1;

-- Reiniciar la secuencia de Circuitos
SELECT pg_get_serial_sequence('Circuitos', 'idcircuito');
ALTER SEQUENCE Circuitos_idCircuito_seq RESTART WITH 1;

-- Reiniciar la secuencia de TipoEventos
SELECT pg_get_serial_sequence('TipoEventos', 'idtipoevento');
ALTER SEQUENCE TipoEventos_idTipoEvento_seq RESTART WITH 1;

-- Reiniciar la secuencia de Eventos
SELECT pg_get_serial_sequence('Eventos', 'idevento');
ALTER SEQUENCE Eventos_idEvento_seq RESTART WITH 1;

-- Reiniciar la secuencia de TipoPersona
SELECT pg_get_serial_sequence('TipoPersona', 'idtipopersona');
ALTER SEQUENCE TipoPersona_idTipoPersona_seq RESTART WITH 1;

-- Reiniciar la secuencia de Personas
SELECT pg_get_serial_sequence('Personas', 'idpersona');
ALTER SEQUENCE Personas_idPersona_seq RESTART WITH 1;

-- Reiniciar la secuencia de Equipos
SELECT pg_get_serial_sequence('Equipos', 'idequipo');
ALTER SEQUENCE Equipos_idEquipo_seq RESTART WITH 1;

-- Reiniciar la secuencia de TipoActividades
SELECT pg_get_serial_sequence('TipoActividades', 'idtipoactividad');
ALTER SEQUENCE TipoActividades_idTipoActividad_seq RESTART WITH 1;

-- Reiniciar la secuencia de CondicionesClimaticas
SELECT pg_get_serial_sequence('CondicionesClimaticas', 'idcondicion');
ALTER SEQUENCE CondicionesClimaticas_idCondicion_seq RESTART WITH 1;

-- Reiniciar la secuencia de RegistroClimatico
SELECT pg_get_serial_sequence('RegistrosClimaticos', 'idregistroclimatico');
ALTER SEQUENCE RegistrosClimaticos_idRegistroClimatico_seq RESTART WITH 1;

-- Reiniciar la secuencia de Actividades
SELECT pg_get_serial_sequence('Actividades', 'idactividad');
ALTER SEQUENCE Actividades_idActividad_seq RESTART WITH 1;

-- Reiniciar la secuencia de BanderasIncidentes
SELECT pg_get_serial_sequence('BanderasIncidentes', 'idbandera');
ALTER SEQUENCE BanderasIncidentes_idBandera_seq RESTART WITH 1;

-- Reiniciar la secuencia de TipoBoleta
SELECT pg_get_serial_sequence('TipoBoleta', 'idtipoboleta');
ALTER SEQUENCE TipoBoleta_idTipoBoleta_seq RESTART WITH 1;

-- Reiniciar la secuencia de TipoNeumatico
SELECT pg_get_serial_sequence('TipoNeumatico', 'idneumatico');
ALTER SEQUENCE TipoNeumatico_idNeumatico_seq RESTART WITH 1;

-- Reiniciar la secuencia de RegistroVelocidad
SELECT pg_get_serial_sequence('RegistrosVelocidad', 'idregistro');
ALTER SEQUENCE RegistrosVelocidad_idRegistro_seq RESTART WITH 1;

-- Reiniciar la secuencia de Patrocinadores
SELECT pg_get_serial_sequence('Patrocinadores', 'idpatrocinador');
ALTER SEQUENCE Patrocinadores_idPatrocinador_seq RESTART WITH 1;

-- Reiniciar la secuencia de Patrocinios
SELECT pg_get_serial_sequence('Patrocinios', 'idpatrocinio');
ALTER SEQUENCE Patrocinios_idPatrocinio_seq RESTART WITH 1;

-- Reiniciar la secuencia de Monoplazas
SELECT pg_get_serial_sequence('Monoplazas', 'idmonoplaza');
ALTER SEQUENCE Monoplazas_idMonoplaza_seq RESTART WITH 1;