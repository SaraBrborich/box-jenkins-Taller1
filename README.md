# Taller 1 - Metodología de Box-Jenkins 📊

Este repositorio contiene la solución en desarrollo para el **Taller 1** de **Macroeconomía Avanzada** en la **Universidad San Francisco de Quito**. El objetivo principal es **implementar desde cero la metodología de Box-Jenkins** para el análisis y modelado de series de tiempo, evitando el uso de funciones preconstruidas en paquetes estadísticos.

## 📌 **Objetivos**
El taller tiene como finalidad:
1. **Construcción de funciones** que implementen **paso a paso la metodología de Box-Jenkins**, programando manualmente los procesos estadísticos involucrados.
2. **Análisis de series de tiempo** y determinación de su proceso generador de datos.
3. **Evaluación de modelos ARMA** mediante criterios de información (AIC y SBC) y diagnóstico de residuos.
4. **Validación de la capacidad predictiva** de los modelos con forecasting dentro de la muestra.

---

## 🏗 **Estado de Avance**
| **Tarea** | **Estado** |
|----------------------------|-----------------|
| 📌 Planteamiento del problema | ✅ Completo |
| 📌 Estructura del código y flujo lógico | ✅ Completo |
| 📊 Gráfico de la serie | ✅ Implementado |
| 📈 Cálculo y gráficos de ACF y PACF | ✅ Implementado |
| 🏆 Cálculo de AIC y SBC | ✅ Implementado |
| ⚙️ Selección de modelo basado en ACF/PACF | ✅ Implementado |
| 🛠 Estimación del modelo ARMA | ✅ Implementado |
| 📊 Diagnóstico de residuos y prueba de ruido blanco | 🔄 En proceso |
| 🔮 Evaluación del poder predictivo (forecasting) | ⏳ Pendiente |

---

## 📈 **Metodología Implementada**
Se ha desarrollado un enfoque manual para la implementación de la metodología de **Box-Jenkins**, permitiendo el análisis de series de tiempo sin depender de funciones predefinidas en paquetes estadísticos. 

Las funcionalidades implementadas incluyen:
- **Visualización de la serie** para identificar tendencias y patrones.
- **Cálculo y gráficos de la ACF y PACF** con intervalos de confianza para guiar la selección del modelo.
- **Identificación de rezagos significativos** y elección entre modelos AR, MA o ARMA.
- **Estimación de modelos ARMA** utilizando **Máxima Verosimilitud (MLE)**.
- **Cálculo manual de los criterios de información** (AIC y BIC) bajo estimaciones por MLE y Mínimos Cuadrados Ordinarios (MCO).

### 🔄 **Próximos Pasos**
- **Diagnóstico de residuos** mediante:
  - Prueba de **Ljung-Box** para evaluar la independencia de los residuos.
  - Gráficos de **ACF y PACF de los residuos** para verificar la presencia de correlación.
  - Análisis de la **media y varianza de los residuos** para detectar heterocedasticidad.
- **Generación de pronósticos** en diferentes horizontes de tiempo.
- Incorporar la comparación de modelos ARMA en base a sus errores de predicción.
- Ajustar la presentación de resultados con visualizaciones mejoradas para facilitar el análisis.

---
