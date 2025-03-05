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
| 🏆 Cálculo de AIC y SBC | 🔄 En proceso |
| ⚙️ Selección de modelo basado en ACF/PACF | 🔄 En proceso |
| 🛠 Estimación del modelo ARMA | ⏳ Pendiente |
| 📊 Diagnóstico de residuos y prueba de ruido blanco | ⏳ Pendiente |
| 🔮 Evaluación del poder predictivo (forecasting) | ⏳ Pendiente |

---

## 📈 **Metodología Implementada**
Hasta el momento, se han desarrollado funciones para:
- **Graficar la serie** para inspección visual de tendencias y estacionalidad.
- **Calcular y graficar la ACF y PACF** con intervalos de confianza para la selección del modelo.
- **Identificar rezagos significativos** y guiar la elección entre modelos AR, MA o ARMA.

### 🔄 **Próximos Pasos**
- Implementar el cálculo manual de **AIC y BIC** para evaluar modelos.
- Ajustar modelos ARMA utilizando **MCO y Máxima Verosimilitud**.
- Validar modelos con diagnóstico de residuos y forecasting.

---
