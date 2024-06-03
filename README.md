### README.md

---

# Formula 1 Database Project

Welcome to the Formula 1 Database Project! This repository contains the SQL scripts to create and manage a comprehensive database designed for storing and querying information related to Formula 1 events, teams, drivers, and more.

## Table of Contents

- [Introduction](#introduction)
- [Database Schema](#database-schema)
- [Entities and Relationships](#entities-and-relationships)

## Introduction

The Formula 1 Database Project aims to provide a detailed and organized structure for managing data associated with Formula 1 racing events. This includes information about countries, cities, circuits, events, people (drivers, fans), teams, and various specific activities and results within the racing events.

## Database Schema

The database schema is designed with a focus on clarity, efficiency, and normalization. Below is a brief overview of the main tables and their relationships:

1. **Paises (Countries)**
2. **Ciudades (Cities)**
3. **TipoCircuitos (Circuit Types)**
4. **Circuitos (Circuits)**
5. **TipoEventos (Event Types)**
6. **Eventos (Events)**
7. **TipoPersona (Person Types)**
8. **Personas (People)**
9. **Pilotos (Drivers)**
10. **Aficionados (Fans)**
11. **Equipos (Teams)**
12. **PilotosPorEquipo (Drivers by Team)**
13. **TipoActividades (Activity Types)**
14. **CondicionesClimaticas (Weather Conditions)**
15. **RegistroClimatico (Weather Records)**
16. **Actividades (Activities)**
17. **Calificaciones (Qualifying)**
18. **Entrenamientos (Training)**
19. **Carreras (Races)**
20. **ResultadosCarrera (Race Results)**
21. **ResultadosCalificacion (Qualifying Results)**
22. **ResultadosEntrenamiento (Training Results)**
23. **BanderasIncidentes (Incident Flags)**
24. **IncidentesCarreras (Race Incidents)**
25. **TipoBoleta (Ticket Types)**
26. **AficionadoEvento (Fan Event Attendance)**
27. **TipoNeumatico (Tire Types)**
28. **CambioNeumaticos (Tire Changes)**
29. **RegistroVelocidad (Speed Records)**
30. **Patrocinadores (Sponsors)**
31. **Patrocinios (Sponsorships)**
32. **Monoplazas (Single-seaters)**
33. **GranPremio (Grand Prix Events)**
34. **Benefico (Charity Events)**
35. **Soporte (Support Events)**

## Entities and Relationships
![Map](./Entidades.png)

### Key Entities

- **Paises**: Stores information about countries.
- **Ciudades**: Stores information about cities, related to countries.
- **TipoCircuitos**: Stores types of circuits.
- **Circuitos**: Stores information about circuits, related to cities and circuit types.
- **TipoEventos**: Stores types of events.
- **Eventos**: Stores event information, related to circuit types and event types.
- **TipoPersona**: Stores types of people (e.g., driver, fan).
- **Personas**: Stores personal information, related to person types and countries.
- **Pilotos**: Specializes in drivers, inheriting from people.
- **Aficionados**: Specializes in fans, inheriting from people.
- **Equipos**: Stores information about teams.
- **PilotosPorEquipo**: Links drivers to teams, with details about their tenure.

### Specialized Tables and Relationships

- **Actividades**: General table for activities during events.
- **Calificaciones**, **Entrenamientos**, **Carreras**: Specific types of activities.
- **ResultadosCarrera**, **ResultadosCalificacion**, **ResultadosEntrenamiento**: Store results for different activity types.
- **BanderasIncidentes**, **IncidentesCarreras**: Manage race incidents and flags.
- **Patrocinadores**, **Patrocinios**: Manage sponsorship information.
- **CambioNeumaticos**: Tracks tire changes during events.
- **RegistroVelocidad**: Tracks speed records.
- **Monoplazas**: Manages information about single-seater cars.

---

Feel free to customize this README.md to better fit your specific project details and usage instructions.
