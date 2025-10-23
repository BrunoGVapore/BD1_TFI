# 📂 BD1_TFI - Trabajo Práctico Integrador (Bases de Datos I y Programación II)

## 📁 Índice

* 🚀 [Descripción del Proyecto](#-descripción-del-proyecto)
* 👥 [Integrantes del Equipo](#-integrantes-del-equipo)
* 🛠️ [Requisitos de Software](#%ef%b8%8f-requisitos-de-software)
* ⚙️ [Pasos para la Instalación y Ejecución](#%ef%b8%8f-pasos-para-la-instalación-y-ejecución)
* 🎥 [Video Explicativo](#-video-explicativo)

---

## 🚀 Descripción del Proyecto

Este trabajo integrador aplica los conocimientos de **Bases de Datos I** mediante la creación de una base de datos **MySQL 8**, diseñada para dar soporte a una aplicación **Java** que modela una **relación uno a uno unidireccional** entre *Empleado* y *Legajo*.
El proyecto simula un entorno real, utilizando **JDBC** y el **patrón DAO** para la persistencia, con manejo explícito de transacciones y una interfaz de consola para operaciones **CRUD**.

El desarrollo se abordó en cinco etapas clave:

* **Modelado e Implementación**
* **Carga masiva de datos**
* **Consultas avanzadas**
* **Seguridad**
* **Concurrencia**

Además, contó con el apoyo pedagógico de la **IA** durante todo el proceso.

### En la parte de Bases de Datos I se profundiza en:

**Modelado y Constraints:**
Diseño relacional robusto con claves primarias, foráneas, restricciones `UNIQUE`, `CHECK` y `ENUM`.

**Carga Masiva:**
Generación de un volumen significativo de datos (400.000 registros) usando SQL puro para simular un entorno realista.

**Consultas Avanzadas:**
Desarrollo de consultas complejas (`JOIN`, `GROUP BY`, `HAVING`, subconsultas) y creación de **Vistas** para análisis y reportes.

**Rendimiento:**
Análisis del impacto de los índices mediante el uso de `EXPLAIN`.

**Seguridad:**
Creación de usuarios con privilegios mínimos y uso de vistas para ocultar datos sensibles.

**Integridad:**
Pruebas para validar las restricciones de la base de datos.

**Prevención de SQL Injection:**
Implementación mediante un **Procedimiento Almacenado**.

**Concurrencia:**
Simulación de **deadlocks** y comparación de niveles de aislamiento, con manejo transaccional robusto (retry).

**Dominio específico:**
`Empleado → Legajo`

---

## 👥 Integrantes del Equipo

| Nombre y Apellido        | Email de Contacto                                                           | Comisión |
| ------------------------ | --------------------------------------------------------------------------- | -------- |
| Agustín Sotelo Carmelich | [agustinemiliano22@gmail.com](mailto:agustinemiliano22@gmail.com)           | 10       |
| Bruno Giuliano Vapore    | [brunogvapore@gmail.com](mailto:brunogvapore@gmail.com)                     | 10       |
| Diego Alejandro Velardes | [velardesdiego@gmail.com](mailto:velardesdiego@gmail.com)                   | 3        |
| Santiago Octavio Varela  | [santiago.varela@tupad.utn.edu.ar](mailto:santiago.varela@tupad.utn.edu.ar) | 14       |

---

## 🛠️ Requisitos de Software

* **MySQL Server 8.4.2**
* **Cliente SQL** (por ejemplo: *DBeaver*, *MySQL Workbench*)

---

## ⚙️ Pasos para la Instalación y Ejecución

### 1. Clonar el Repositorio

```bash
git clone https://github.com/BrunoGVapore/BD1_TFI.git
cd BD1_TFI
```

### 2. Configuración de la Base de Datos MySQL

Abre tu cliente SQL preferido (conectado a tu servidor **MySQL 8** como `root` o un usuario administrador).

Ejecuta los siguientes scripts en orden:

**a. Creación del esquema**

```
sql/01_esquema.sql
```

**b. Tablas semilla**

```
sql/02_catalogos.sql
```

**c. Carga masiva de datos** *(puede tardar unos minutos)*

```
sql/03_carga_masiva.sql
```

**d. (Opcional) Índices**

```
sql/04_indices.sql
```

**e. (Opcional) Vistas**

```
sql/06_vistas.sql
```

**f. (Opcional) Seguridad**

```
sql/07_seguridad.sql
```

**g. (Opcional) Transacciones**

```
sql/08_transacciones.sql
```
**g. (Opcional) Concurrencia**

```
sql/09_concurrencia_guiada.sql
```


> **Nota:**
> Por defecto, los scripts SQL asumen conexión como `root` para tareas administrativas.
> El usuario `tpi_bd` (creado en `07_seguridad.sql`) tiene contraseña `1234`.

---

## 🎥 Video Explicativo

| Condición         | Detalle                                                      |
| ----------------- | ------------------------------------------------------------ |
| **Grupo**         | 4 integrantes                                                |
| **Fecha Límite**  | 23 de Octubre 2025                                           |
| **Link al Video** | [https://youtu.be/JVb5A0feVII](https://youtu.be/JVb5A0feVII) |

---

**[UTN] - [2025]**
