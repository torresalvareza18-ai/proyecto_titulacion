# 🦅 Tablón Quetzal - Centralización de Notificaciones Académicas

[![Descargar APK](https://img.shields.io/badge/Descargar%20APK-v1.0.0-success?style=for-the-badge&logo=android)](https://github.com/torresalvareza18-ai/proyecto_titulacion/releases/download/apk/app-release.apk)**

**Proyecto de Titulación - UPIICSA (IPN)**
*Prototipo para la centralización de notificaciones académicas (Grupo 8NM80).*c

---

## Sobre el proyecto
**Tablón Quetzal** es una aplicación móvil diseñada para centralizar la información académica dispersa. Su objetivo principal es permitir a la comunidad de estudiante de Ingenieria en Informatica **consultar y mantenerse al día** con los comunicados oficiales desde una única fuente confiable.

### 🚀 Funcionalidades Principales

* **Visualización de Noticias:** Feed centralizado de comunicados oficiales mediante **AWS AppSync** (GraphQL).
* **Guardado de Interés:** Los usuarios pueden marcar publicaciones importantes para lectura posterior (`UserSavedPost`).
* **Categorización:** Filtrado de avisos mediante un catálogo de etiquetas (`TagCatalog`).
* **Alertas:** Sistema de notificaciones (`Notifications`) para avisos urgentes o relevantes.
* **Acceso Seguro:** Autenticación de usuarios para el acceso a la información mediante **Amazon Cognito**.

⚠️ **ADVERTENCIA:** Este proyecto requiere versiones EXACTAS de Flutter y herramientas. No intentes usar tu versión global o romperás el código.

## 1. Prerrequisitos (Instalar antes de empezar)
* **Java 17 (JDK):** Requerido. Verifica con `java -version`.
* **Node.js v24 (o v18+):** Requerido. Verifica con `node -v`.
* **FVM (Gestor de Flutter):**
    Ejecuta en tu terminal:
    ```bash
    dart pub global activate fvm
    ```

### 🚨 IMPORTANTE PARA USUARIOS WINDOWS:
Para que FVM funcione correctamente, debes activar el **"Modo para desarrolladores"**:
1.  Ve a **Configuración** de Windows -> **Privacidad y seguridad** -> **Para programadores**.
2.  Activa el interruptor **"Modo para desarrolladores"**.
*(Esto permite crear los enlaces simbólicos de la carpeta .fvm sin errores).*

---

## 2. Instalación Rápida
Sigue estos pasos en orden dentro de la carpeta del proyecto:

1.  **Instalar dependencias de Flutter (Versión 3.38.2):**
    ```bash
    fvm install
    ```
    *Si te pregunta si quieres configurar el path, di que sí.*

2.  **Instalar dependencias de Amplify (Versión 14.2.2):**
    ```bash
    npm install
    ```

3.  **Descargar Configuración de Nube (AWS):**
    ```bash
    npx amplify pull --appId d25fyq0w2m0x1q --envName dev
    ```

---

## 3. Configura tu Android Studio (OBLIGATORIO)

Si no haces esto, el IDE no reconocerá el código.

1.  Ve a **Settings** (Mac) o **File > Settings** (Windows).
2.  Ve a **Languages & Frameworks** > **Flutter**.
3.  En **Flutter SDK Path**, cambia la ruta. NO uses tu instalación global.
    * **Windows:** Busca la carpeta `.fvm\flutter_sdk` dentro de este proyecto. (Si no ves la carpeta `.fvm` es porque está oculta, escribe la ruta manualmente o activa "Mostrar archivos ocultos").
    * **Mac/Linux:** Selecciona `.fvm/flutter_sdk`.
4.  Dale **Apply**.

---

## 4. Cómo trabajar (Comandos Diarios)

Usa siempre el prefijo `fvm` en la terminal para asegurar que usas la versión correcta.

* **Correr la app:**
  `fvm flutter run`
* **Instalar librerías:**
  `fvm flutter pub get`
* **Genera modelo (Si la app falla):**
  `npx amplify codegen models`
  `npx amplify push`

---
**Tabla de Versiones Estrictas:**
* Flutter: 3.38.2
* Amplify CLI: 14.2.2
* Java: 17