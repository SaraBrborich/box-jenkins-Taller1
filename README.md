# Taller 1 - Metodología de Box-Jenkins 📊

Este repositorio contiene la solución completa del **Taller 1** de **Macroeconomía Avanzada** de la **Universidad San Francisco de Quito**. El objetivo principal ha sido **implementar desde cero la metodología de Box-Jenkins** para el análisis y modelado de series de tiempo, evitando el uso de funciones preconstruidas en paquetes estadísticos.

## 📀 **Objetivos**
El taller ha permitido:
1. **Construcción de funciones** que implementan **paso a paso la metodología de Box-Jenkins**, programando manualmente los procesos estadísticos involucrados.
2. **Análisis de series de tiempo** para determinar su proceso generador de datos.
3. **Evaluación de modelos ARMA** mediante criterios de información (AIC y BIC) y diagnóstico de residuos.
4. **Validación de la capacidad predictiva** de los modelos con forecasting dentro de la muestra.

---

## 💡 **Estado Final**
| **Tarea** | **Estado** |
|----------------------------|-----------------|
| 📀 Planteamiento del problema | ✅ Completo |
| 📀 Estructura del código y flujo lógico | ✅ Completo |
| 📊 Gráfico de la serie | ✅ Implementado |
| 📈 Cálculo y gráficos de ACF y PACF | ✅ Implementado |
| 🎯 Cálculo de AIC y BIC | ✅ Implementado |
| ⚙️ Selección de modelo basado en ACF/PACF | ✅ Implementado |
| 🛠️ Estimación del modelo ARMA | ✅ Implementado |
| 📊 Diagnóstico de residuos y prueba de ruido blanco | ✅ Completo |
| 🔮 Evaluación del poder predictivo (forecasting) | ✅ Completo |

---

## 📊 **Funciones Implementadas**

Se han desarrollado dos funciones principales para implementar la metodología de **Box-Jenkins** de manera manual:

### 1. `acf_pacf_manual()`
**Propósito:**
- Calcula manualmente la **función de autocorrelación (ACF)** y la **función de autocorrelación parcial (PACF)** de una serie de tiempo.
- Identifica rezagos significativos utilizando intervalos de confianza manuales.
- Ajusta modelos **AR(p)**, **MA(q)** y **ARMA(p,q)** según los rezagos identificados.
- Calcula los criterios de información **AIC y BIC** para cada modelo.
- Evalúa la calidad del ajuste del modelo mediante el **estadístico Q de Ljung-Box** sobre los residuos.
- Genera gráficos de ACF y PACF con comparación a las funciones predefinidas de R.

### 2. `analisis_residuos_prediccion()`
**Propósito:**
- Evalúa si los residuos de un modelo seleccionado son **ruido blanco**.
- Calcula el **estadístico Q de Ljung-Box** para verificar la independencia de los residuos.
- Genera un **histograma de los residuos** con comparación a una distribución normal.
- Realiza un **forecasting dentro de la muestra**, eliminando los últimos valores y generando predicciones para esos periodos.
- Calcula el **Mean Squared Prediction Error (MSPE)** del modelo.
- Genera un gráfico de la **evolución de la serie original y sus predicciones**, incluyendo intervalos de confianza.

**Nota 1:** El archivo `Taller1_Sol.ipynb` contiene una explicación detallada de las ecuaciones y el proceso teórico utilizado en cada una de estas funciones.

**Nota 2:** El archivo `Taller1_Functions.R` contiene las dos funciones defindas.

---

📘 **Referencias:** 
- Enders, W. (2014). *Applied Econometric Time Series*. Wiley.
- Box, G. E., & Jenkins, G. M. (1970). *Time Series Analysis: Forecasting and Control*.

