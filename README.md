# Laboratorio: Implementación Multimodal de Bases de Datos (MySQL & PostgreSQL)

Este repositorio contiene la arquitectura y los scripts necesarios para el diseño e implementación de un esquema relacional de 5 tablas sobre contenedores Docker independientes.

## 📂 Estructura del Proyecto

* **`mysql/`**: Contiene la configuración de orquestación y esquemas específicos para el motor MySQL.
    * `.env`: Variables de entorno para credenciales y base de datos.
    * `docker-compose.yml`: Definición del servicio y volumen de persistencia para MySQL.
    * `schema_mysql.sql`: Script DDL (Data Definition Language) adaptado a MySQL con Triggers.
    * `mysql_inserts.sql`: Inserción de los 5 registros base requeridos.
* **`postgres/`**: Contiene la configuración de orquestación y esquemas específicos para el motor PostgreSQL.
    * `.env`: Variables de entorno para credenciales y base de datos.
    * `docker-compose.yml`: Definición del servicio y volumen de persistencia para PostgreSQL.
    * `schema_postgres.sql`: Script DDL adaptado a PostgreSQL con funciones y Triggers.
    * `postgres_inserts.sql`: Inserción de los 5 registros base requeridos.
* **`scripts_validacion/`**: Carpeta con consultas DML para la defensa de la nota.
    * `Validaciones.sql`: Scripts para probar JOINs, agregaciones y el rechazo del Trigger ante subtotales incorrectos.

---

## 🛠️ Configuración de Credenciales (.env)

Asegúrate de configurar los archivos `.env` con los siguientes valores para cumplir con la integridad del laboratorio:

**MySQL:**
```env
MYSQL_ROOT_PASSWORD=root123
MYSQL_DATABASE=lab_tienda
MYSQL_USER=admin
MYSQL_PASSWORD=123321

## 🛠️ Configuración de Credenciales (.env)

Asegúrate de configurar los archivos `.env` con los siguientes valores para cumplir con la integridad del laboratorio:

**MySQL:**
```env
MYSQL_ROOT_PASSWORD=root123
MYSQL_DATABASE=lab_tienda
MYSQL_USER=admin
MYSQL_PASSWORD=123321
```

**PostgreSQL:**
```env
POSTGRES_USER=admin
POSTGRES_PASSWORD=123321
POSTGRES_DB=lab_tienda
```

---

## 🚀 Instrucciones de Despliegue y Validación

### 1. Levantar Contenedores
Desde la raíz del proyecto, entra en cada carpeta y levanta los servicios:
```bash
# Para MySQL
cd mysql && docker compose up -d && cd ..
# Para PostgreSQL
cd postgres && docker compose up -d && cd ..
```

### 2. Carga de Esquemas e Inserciones
Ejecuta los siguientes comandos en tu terminal Kitty para poblar las bases de datos:

**MySQL:**
```bash
docker exec -i mysql_local mysql -u root -proot123 lab_tienda < mysql/schema_mysql.sql
docker exec -i mysql_local mysql -u root -proot123 lab_tienda < mysql/mysql_inserts.sql
```

**PostgreSQL:**
```bash
docker exec -i postgres_local psql -U admin -d lab_tienda < postgres/schema_postgres.sql
docker exec -i postgres_local psql -U admin -d lab_tienda < postgres/postgres_inserts.sql
```

### 3. Ejecución de Validaciones
[cite_start]Para demostrar el funcionamiento de los **Triggers** y las **Consultas Complejas**[cite: 20, 31]:
```bash
# Validación en MySQL
docker exec -i mysql_local mysql -u admin -p123321 lab_tienda < scripts_validacion/Validaciones.sql

# Validación en PostgreSQL
docker exec -i postgres_local psql -U admin -d lab_tienda < scripts_validacion/Validaciones.sql
```

---

[cite_start]**Nota Técnica:** El sistema rechazará cualquier intento de inserción en `order_items` donde el `subtotal` no sea exactamente igual a `precio * cantidad`, lanzando un error definido en el Trigger de cada motor[cite: 22, 23, 36].