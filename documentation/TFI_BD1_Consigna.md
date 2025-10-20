# 📚 Trabajo Final Integrador (TFI) — Bases de Datos I

**Resumen:** El TFI integra lo visto en Bases de Datos I con el sistema desarrollado en Programación II. Con el mismo equipo de trabajo de Programación II debés modelar e implementar una base de datos para uno o más procesos clave del sistema, realizar una carga masiva de datos (ver volumen recomendado en la CONSIGNA), producir consultas y vistas útiles, aplicar seguridad e integridad (usuarios/roles, ocultamiento de datos) y trabajar transacciones/concurrencia (niveles de aislamiento). Entregás PDF + scripts .sql + video.

En esta sección encontrás todo lo necesario para preparar tu TFI:

- [📚 Trabajo Final Integrador (TFI) — Bases de Datos I](#-trabajo-final-integrador-tfi--bases-de-datos-i)
  - [🎯 Objetivo del Trabajo](#-objetivo-del-trabajo)
  - [📚 Tema y Marco Referencial](#-tema-y-marco-referencial)
    - [Alcance mínimo sugerido:](#alcance-mínimo-sugerido)
  - [📦 Formato de Entrega](#-formato-de-entrega)
  - [📝 Proceso de Evaluación](#-proceso-de-evaluación)
  - [🕒 Encuentros Sincrónicos por no aprobar](#-encuentros-sincrónicos-por-no-aprobar)
  - [⚠️ Importante](#️-importante)
  - [🧪 Modalidad del Examen Final](#-modalidad-del-examen-final)
    - [Cuestionario en plataforma](#cuestionario-en-plataforma)
    - [Defensa oral](#defensa-oral)
  - [🧮 Rúbrica de Evaluación del TFI](#-rúbrica-de-evaluación-del-tfi)
  - [🎥 Guía para desarrollar el video](#-guía-para-desarrollar-el-video)

---

## 🎯 Objetivo del Trabajo

Integrar los contenidos de Bases de Datos I en un caso aplicado al sistema desarrollado en Programación II, demostrando competencias técnicas y capacidad de comunicación.

* **Modelado y constraints:** diseño relacional correcto (PK, FK, UNIQUE, CHECK) y validaciones.
* **Implementación y carga:** creación del esquema y carga masiva de datos con SQL.
* **Consultas y reportes:** consultas de negocio (JOIN, GROUP BY/HAVING, subconsultas) y vistas útiles.
* **Seguridad e integridad:** usuario con privilegios mínimos y protección de datos sensibles.
* **Concurrencia y transacciones:** manejo de transacciones, niveles de aislamiento y documentación de resultados.
* **Rendimiento (ver Etapa 3):** medición comparativa con/sin índices en consultas representativas (igualdad, rango, JOIN), según la metodología de la CONSIGNA.

---

## 📚 Tema y Marco Referencial

El trabajo se articula con el sistema desarrollado en Programación II. Consiste en **modelar e implementar** la base de datos que soporte uno o más procesos clave del sistema, documentando las **reglas de negocio** y las **decisiones de diseño**.

### Alcance mínimo sugerido:

* Dominio acotado (p. ej., ventas, turnos, stock, matriculación).
* Reglas de negocio explícitas (supuestos, restricciones, integridad).
* Volumen de datos y casos de uso que justifiquen consultas y reportes.

---

## 📦 Formato de Entrega

Debe incluir:

* 📄 **Carpeta digital** (subida en la plataforma):
    * **PDF (único):** portada, resumen ejecutivo (5–7 líneas), reglas de negocio, DER/MR, decisiones de diseño y constraints, evidencias (consultas/resultados, verificaciones de consistencia, comparación con/sin índice, concurrencia), **referencia cruzada a scripts** (p. ej., “ver `03_carga_masiva.sql`”), **anexo IA en texto** (no capturas), **enlace al video** (acceso no privado).
    * **ZIP de scripts `.sql`:**
        ```
        01_esquema.sql (PK/FK/UNIQUE/CHECK)
        02_catalogos.sql
        03_carga_masiva.sql
        04_indices.sql
        05_consultas.sql (+ 05_explain.sql)
        06_vistas.sql
        07_seguridad.sql
        08_transacciones.sql
        09_concurrencia_guiada.sql
        README.txt (orden y versión)
        ```
* **Requisito:** scripts idempotentes (usar `DROP IF EXISTS`).
* **Se considera entregado** cuando estén cargados *todos* los recursos: PDF + ZIP de scripts + video (ver fechas/hora en la sección Proceso de Evaluación).
* **Evidencia del uso de IA como tutoría:** anexo en formato texto (no capturas), organizado por Tema/Etapa. Puede ir al final del PDF o en un PDF complementario.
* **Nomenclatura:** `TFI_BDI_ComisionX_GrupoY_Apellidos.pdf` y `TFI_BDI_ComisionX_GrupoY_Apellidos.zip` (scripts).
* 🎥 **Video del equipo** (10–15 minutos). Ver indicaciones en la [Guía para desarrollar el video](#-guía-para-desarrollar-el-video). Incluir el enlace dentro del PDF y cargarlo en la plataforma.

---

## 📝 Proceso de Evaluación

1.  **Primera instancia – Presentación — Vto: 23-10**
    * Entrega de la **carpeta digital** y el **video** para evaluación.
    * La cátedra devuelve por plataforma uno de estos estados:
        * ✅ **Aprobado.**
        * 🔄 **Requiere correcciones** → continúa a la segunda instancia (recuperatorio).

2.  **Segunda instancia – Recuperatorio — Vto: 30-10**
    * Entrega de **nueva versión** de la carpeta y el video.
    * Resultados posibles:
        * ✅ **Aprobado.**
        * ❌ **No aprobado** → deberá **entregar otro TFI** antes del examen final para poder habilitarse.

3.  **Última instancia – Examen Final** (solo para quienes no aprobaron en 2ª instancia)
    * **Una semana antes** del final: entrega de carpeta y video **actualizados**.
    * La cátedra confirma por correo si el estudiante queda **habilitado** para rendir.
    * **Requisito obligatorio:** tener el **TFI aprobado** para presentarse al examen final.

---

## 🕒 Encuentros Sincrónicos por no aprobar

Destinados a equipos que obtuvieron **No aprobado** en la segunda instancia. El objetivo es orientar correcciones y definir un plan de reentrega previo al examen final.

* **Formato:** reunión breve por equipo (20–30 min) vía Meet/Zoom.
* **Requisito previo:** enviar por la plataforma, 24 horas antes, la carpeta y el video **actualizados** más una lista de dudas puntuales.
* **Franjas disponibles:**
    * Mañana: 9:00 a 12:00
    * Tarde: 14:00 a 17:00
    * Noche: 18:00 a 21:00
* **Reserva:** solicitar turno por la mensajería de la plataforma indicando comisión, grupo y franja preferida.
* **Resultado esperado:** checklist de correcciones acordado y fecha límite de reentrega.
* **Asistencia:** obligatoria para los integrantes del equipo.

---

## ⚠️ Importante

* **Grupos:** equipos de 4 integrantes (el mismo grupo de Programación II) (excepciones debidamente justificadas ante la cátedra).
* **Comunicación oficial:** exclusivamente por la plataforma institucional y el correo institucional.
* **Uso de IA:** admitido como apoyo/tutoría. Debe presentarse evidencia (PDF del intercambio) y reflexión propia. No se admiten voces generadas por IA en el video.
* **Autoría y honestidad académica:** el equipo debe comprender y defender lo producido. La cátedra puede solicitar defensa individual.
* **Privacidad y datos:** no usar datos personales reales sin consentimiento. En su lugar, anonimizar o usar datos sintéticos.
* **Plazos y versiones:** se considera “entregado” cuando están cargados **todos los recursos requeridos** (PDF, `.zip` con scripts `.sql` y video) en la plataforma.
* **Formato de archivos:** respetar la nomenclatura indicada en “Formato de Entrega”.

---

## 🧪 Modalidad del Examen Final

Aplica a estudiantes que no aprobaron en la segunda instancia o que deban rendir final según el calendario institucional.

### Cuestionario en plataforma

* 10–20 preguntas teórico-prácticas.
* Temas: modelado y normalización; SQL (JOIN, agregaciones, HAVING, subconsultas); vistas; seguridad (privilegios/roles); transacciones y niveles de aislamiento.
* **Nota mínima para habilitar la defensa oral:** 6 (seis).

### Defensa oral

* Coloquio individual por Meet/Zoom.
* Exposición y preguntas sobre el TFI y los contenidos clave de la materia.
* La cátedra puede solicitar demostraciones breves de consultas o justificación de decisiones de diseño.
* **Condición necesaria:** tener el **TFI aprobado** y entregado según el “Proceso de Evaluación”.
* **Fechas y horarios:** se publicarán en el aula virtual (Transparente Virtual) conforme al calendario de exámenes.

---

## 🧮 Rúbrica de Evaluación del TFI

Resumen (ponderaciones):

* **Etapa 1:** Modelado y constraints — 20%
* **Etapa 2:** Implementación y carga — 20%
* **Etapa 3:** Consultas y reportes — 25%
* **Etapa 4:** Seguridad e integridad — 15%
* **Etapa 5:** Concurrencia y transacciones — 20%

---

## 🎥 Guía para desarrollar el video

* ⏱️ **Duración:** 10–15 minutos.
* 👥 **Inicio:** cada integrante se presenta con cámara encendida y nombre completo.
* 📝 **Temática:** indicar claramente el caso del proyecto.
* 🎙️ **Desarrollo:** puede continuar con cámara apagada, pero siempre con **voz propia**. **No** se permiten voces generadas por IA.
* 🔗 **Enlace:** incluir el **link al video** dentro del PDF y cargar el archivo/enlace en la plataforma.
* 📌 **Estructura sugerida:**
    1.  👋 Presentación de integrantes
    2.  🔍 Introducción al tema y objetivos
    3.  📚 Marco teórico (conceptos/fundamentos)
    4.  🛠️ Caso práctico (modelo y base implementada)
    5.  📊 Consultas y resultados relevantes
    6.  🧠 Conclusiones (aprendizajes y mejoras)
* ✅ **Recomendación:** ensayar para respetar el tiempo y lograr una exposición clara. Se valora una **breve demostración** del esquema y al menos una consulta representativa.