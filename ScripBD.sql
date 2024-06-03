CREATE TABLE Paises (
    idPais SERIAL PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL
);

CREATE TABLE Ciudades (
    idCiudad SERIAL PRIMARY KEY,
    idPais INT NOT NULL,
    nombre VARCHAR(255) NOT NULL,
    FOREIGN KEY (idPais) REFERENCES Paises(idPais)
);

CREATE TABLE TipoCircuitos (
    idTipoCircuito SERIAL PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    longitudMinima INT NOT NULL,
    longitudMaxima INT NOT NULL,
    CONSTRAINT tipoNombreUnico UNIQUE (nombre),
    CONSTRAINT tipoValido CHECK (nombre IN ('Urbano', 'Permanente', 'Mixto'))
);


CREATE TABLE Circuitos (
    idCircuito SERIAL PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    idCiudad INT NOT NULL,
    longitud INT NOT NULL,
    fechaInauguracion DATE NOT NULL,
    idTipoCircuito INT NOT NULL,
    capacidad INT,
    FOREIGN KEY (idCiudad) REFERENCES Ciudades(idCiudad),
    FOREIGN KEY (idTipoCircuito) REFERENCES TipoCircuitos(idTipoCircuito)
);


CREATE TABLE TipoEventos (
    idTipoEvento SERIAL PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL
);

CREATE TABLE Eventos (
    idEvento SERIAL PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    fechaInicio DATE NOT NULL,
    fechaFinal DATE NOT NULL,
    horaInicio TIME NOT NULL,
    horaFin TIME NOT NULL,
    idTipoEvento INT NOT NULL,
    idCircuito INT NOT NULL,
    FOREIGN KEY (idTipoEvento) REFERENCES TipoEventos(idTipoEvento),
    FOREIGN KEY (idCircuito) REFERENCES Circuitos(idCircuito)
);

CREATE TABLE GranPremio (
    idGranPremio INT PRIMARY KEY,
    FOREIGN KEY (idGranPremio) REFERENCES Eventos(idEvento)
);

CREATE TABLE Benefico (
    idBenefico INT PRIMARY KEY,
    FOREIGN KEY (idBenefico) REFERENCES Eventos(idEvento)
);

CREATE TABLE Soporte (
    idSoporte INT PRIMARY KEY,
    FOREIGN KEY (idSoporte) REFERENCES Eventos(idEvento)
);

CREATE TABLE TipoPersona (
    idTipoPersona SERIAL PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL
);

CREATE TABLE Personas (
    idPersona SERIAL PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    paisNacimiento INT NOT NULL,
    fechaNacimiento DATE NOT NULL,
    idTipoPersona INT NOT NULL,
    FOREIGN KEY (paisNacimiento) REFERENCES Paises(idPais),
    FOREIGN KEY (idTipoPersona) REFERENCES TipoPersona(idTipoPersona)
);

CREATE TABLE Pilotos (
    idPiloto INT PRIMARY KEY,
    FOREIGN KEY (idPiloto) REFERENCES Personas(idPersona)
);

CREATE TABLE Aficionados (
    idAficionado INT PRIMARY KEY,
    genero VARCHAR(255),
    FOREIGN KEY (idAficionado) REFERENCES Personas(idPersona)
);

CREATE TABLE Equipos (
    idEquipo SERIAL PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL UNIQUE,
    fechaDeFundacion DATE NOT NULL,
    ciudadDeOperaciones INT NOT NULL,
    FOREIGN KEY (ciudadDeOperaciones) REFERENCES Ciudades(idCiudad)
);

CREATE TABLE PilotosPorEquipo (
    idPiloto INT NOT NULL,
    idEquipo INT NOT NULL,
    fechaVinculacion DATE,
    fechaDesvinculacion DATE,
    temporada INT NOT NULL,
    PRIMARY KEY (idPiloto, idEquipo),
    FOREIGN KEY (idPiloto) REFERENCES Pilotos(idPiloto),
    FOREIGN KEY (idEquipo) REFERENCES Equipos(idEquipo)
);


CREATE TABLE TipoActividades (
    idTipoActividad SERIAL PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL
);

CREATE TABLE CondicionesClimaticas (
    idCondicion SERIAL PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL
);


CREATE TABLE RegistrosClimaticos (
    idRegistroClimatico SERIAL PRIMARY KEY,
    fecha DATE NOT NULL,
    temperatura INT NOT NULL,
    idCondicion INT NOT NULL,
    FOREIGN KEY (idCondicion) REFERENCES CondicionesClimaticas(idCondicion)
);


CREATE TABLE Actividades (
    idActividad SERIAL PRIMARY KEY,
    idEvento INT NOT NULL,
    nombre VARCHAR(255) NOT NULL,
    horaInicio TIME NOT NULL,
    fecha DATE NOT NULL,
    idTipoActividad INT NOT NULL,
    idRegistroClimatico INT,
    FOREIGN KEY (idEvento) REFERENCES Eventos(idEvento),
    FOREIGN KEY (idTipoActividad) REFERENCES TipoActividades(idTipoActividad),
    FOREIGN KEY (idRegistroClimatico) REFERENCES RegistrosClimaticos(idRegistroClimatico)
);

CREATE TABLE Calificaciones (
    idCalificacion INT PRIMARY KEY,
    FOREIGN KEY (idCalificacion) REFERENCES Actividades(idActividad)
);

CREATE TABLE Entrenamientos (
    idEntrenamiento INT PRIMARY KEY,
    duracion TIME,
    numeroSesion VARCHAR(255),
    FOREIGN KEY (idEntrenamiento) REFERENCES Actividades(idActividad)
);

CREATE TABLE Carreras (
    idCarrera INT PRIMARY KEY,
    numeroDeVueltas INT,
    FOREIGN KEY (idCarrera) REFERENCES Actividades(idActividad)
);

CREATE TABLE ResultadosCarrera (
    idCarrera INT NOT NULL,
    idPiloto INT NOT NULL,
    idEquipo INT NOT NULL,
    posicionFinal INT,
    tiempoVueltaRapida TIME,
    vueltasCompletadas INT,
    PRIMARY KEY (idCarrera, idPiloto, idEquipo),
    FOREIGN KEY (idCarrera) REFERENCES Carreras(idCarrera),
    FOREIGN KEY (idPiloto) REFERENCES Pilotos(idPiloto), 
    FOREIGN KEY (idEquipo) REFERENCES Equipos(idEquipo)
);


CREATE TABLE ResultadosCalificacion (
    idCalificacion INT NOT NULL,
    idPiloto INT NOT NULL,
    idEquipo INT NOT NULL,
    tiempoQ1 INT,
    tiempoQ2 INT,
    tiempoQ3 INT,
    PRIMARY KEY (idCalificacion, idPiloto),
    FOREIGN KEY (idCalificacion) REFERENCES Calificaciones(idCalificacion),
    FOREIGN KEY (idPiloto) REFERENCES Pilotos(idPiloto),
    FOREIGN KEY (idEquipo) REFERENCES Equipos(idEquipo)
);

CREATE TABLE ResultadosEntrenamiento (
    idEntrenamiento INT NOT NULL,
    idPiloto INT NOT NULL,
    idEquipo INT NOT NULL,
    vueltasRealizadas INT,
    incidente BOOLEAN,
    comentarios TEXT,
    PRIMARY KEY (idEntrenamiento, idPiloto, idEquipo),
    FOREIGN KEY (idEntrenamiento) REFERENCES Entrenamientos(idEntrenamiento),
    FOREIGN KEY (idPiloto) REFERENCES Pilotos(idPiloto),
    FOREIGN KEY (idEquipo) REFERENCES Equipos(idEquipo)
);

CREATE TABLE BanderasIncidentes (
    idBandera SERIAL PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    colorPrincipal VARCHAR(255) NOT NULL,
    colorSecundario VARCHAR(255),
    significado TEXT NOT NULL
);

CREATE TABLE IncidentesCarreras (
    idBandera INT NOT NULL,
    idCarrera INT NOT NULL,
    idPiloto INT NOT NULL,
    vueltaIncidente INT NOT NULL,
    PRIMARY KEY (idBandera, idCarrera, idPiloto),
    FOREIGN KEY (idBandera) REFERENCES BanderasIncidentes(idBandera),
    FOREIGN KEY (idCarrera) REFERENCES Carreras(idCarrera),
    FOREIGN KEY (idPiloto) REFERENCES Pilotos(idPiloto)
);

CREATE TABLE TipoBoleta (
    idTipoBoleta SERIAL PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    descripcion VARCHAR(255) NOT NULL
);

CREATE TABLE AficionadoEvento (
    idActividad INT NOT NULL,
    idAficionado INT NOT NULL,
    idTipoBoleta INT NOT NULL,
    numeroEntrada INT UNIQUE,
    precioEntrada FLOAT,
    PRIMARY KEY (idActividad, idAficionado, idTipoBoleta),
    FOREIGN KEY (idActividad) REFERENCES Actividades(idActividad),
    FOREIGN KEY (idAficionado) REFERENCES Aficionados(idAficionado),
    FOREIGN KEY (idTipoBoleta) REFERENCES TipoBoleta(idTipoBoleta)
);
CREATE TABLE TipoNeumatico (
    idNeumatico SERIAL PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL CHECK (nombre IN ('Blando', 'Medio', 'Duro', 'Lluvia extrema', 'Lluvia intermedia')),
    color VARCHAR(255) NOT NULL,
    caracteristicas VARCHAR(255) NOT NULL,
    temperaturaFuncionamientoOptimo VARCHAR(255) NOT NULL,
    CONSTRAINT nombreUnico UNIQUE (nombre),
    CONSTRAINT colorUnico UNIQUE (color)
);


CREATE TABLE CambioNeumaticos (
    idEvento INT NOT NULL,
    idActividad INT NOT NULL,
    idEquipo INT NOT NULL,
    idPiloto INT NOT NULL,
    idNeumatico INT NOT NULL,
    vueltaCambio INT NOT NULL,
    PRIMARY KEY (idEvento, idActividad, idEquipo, idPiloto, idNeumatico),
    FOREIGN KEY (idEvento) REFERENCES Eventos(idEvento),
    FOREIGN KEY (idActividad) REFERENCES Actividades(idActividad),
    FOREIGN KEY (idEquipo) REFERENCES Equipos(idEquipo),
    FOREIGN KEY (idPiloto) REFERENCES Pilotos(idPiloto),
    FOREIGN KEY (idNeumatico) REFERENCES TipoNeumatico(idNeumatico)
);

CREATE TABLE RegistrosVelocidad (
    idRegistro SERIAL PRIMARY KEY,
    idActividad INT NOT NULL,
    velocidadMaxima VARCHAR(255) NOT NULL,
    idPiloto INT NOT NULL,
    FOREIGN KEY (idActividad) REFERENCES Actividades(idActividad),
    FOREIGN KEY (idPiloto) REFERENCES Pilotos(idPiloto)
);

CREATE TABLE Patrocinadores (
    idPatrocinador SERIAL PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    tipoPatrocinio VARCHAR(255) NOT NULL
);

CREATE TABLE Patrocinios (
    idPatrocinio SERIAL PRIMARY KEY,
    idPatrocinador INT NOT NULL,
    idEvento INT,
    idEquipo INT,
    montoPatrocinio FLOAT NOT NULL,
    fechaInicio DATE NOT NULL,
    fechaFinal DATE NOT NULL,
    FOREIGN KEY (idPatrocinador) REFERENCES Patrocinadores(idPatrocinador),
    FOREIGN KEY (idEvento) REFERENCES Eventos(idEvento),
    FOREIGN KEY (idEquipo) REFERENCES Equipos(idEquipo),
    CONSTRAINT fechaInicioMenorAFechaFinal CHECK (fechaInicio < fechaFinal)
);

CREATE TABLE Monoplazas (
    idMonoplaza SERIAL PRIMARY KEY,
    numeroChasis VARCHAR(255) NOT NULL,
    modelo VARCHAR(255) NOT NULL,
    temporada VARCHAR(255) NOT NULL,
    idEquipo INT NOT NULL,
    FOREIGN KEY (idEquipo) REFERENCES Equipos(idEquipo)
);



