# Función para calcular la ACF y PACF y compararla con las funciones de R
acf_pacf_manual <- function(series, plot = TRUE, crit_info = TRUE) {
    library(ggplot2)
    library(gridExtra)
    library(dplyr)
    library(tidyr)
    library(kableExtra)

    # Convertir a vector numérico en caso de que sea data.frame o lista
    if (is.data.frame(series)) {
        series <- as.numeric(series[[2]]) # Selecciona la columna con datos
    } else {
        series <- as.numeric(series) # Convierte cualquier otro formato a numérico
    }

    T <- length(series)
    max_lag <- floor(T / 4) # Número máximo de rezagos a calcular

    # Cálculo media
    mean_y <- mean(series)

    # Cálculo varianza
    var_y <- var(series)

    # Cálculo manual de la ACF
    acf_values <- numeric(max_lag)
    for (s in 1:max_lag) {
        numerator <- sum((series[(s + 1):T] - mean_y) * (series[1:(T - s)] - mean_y))
        denominator <- sum((series - mean_y)^2)
        acf_values[s] <- numerator / denominator
    }

    # Cálculo de los intervalos de confianza para la ACF
    acf_var <- numeric(max_lag)
    acf_var[1] <- 1 / T # Para s = 1
    for (s in 2:max_lag) {
        acf_var[s] <- (1 / T) * (1 + 2 * sum(acf_values[1:(s - 1)]^2))
    }
    acf_sd <- sqrt(acf_var)
    acf_threshold_value <- min(acf_sd[-1]) * 2

    # Identificar rezagos significativos para la ACF
    significant_acf_lags <- which(abs(acf_values) > acf_threshold_value)

    # Cálculo manual de la PACF
    pacf_values <- numeric(max_lag)
    phi <- matrix(0, nrow = max_lag, ncol = max_lag) # Matriz de coeficientes parciales

    # Caso base: el primer coeficiente PACF es la primera ACF
    pacf_values[1] <- acf_values[1]
    phi[1, 1] <- acf_values[1]

    pacf_values[1] <- acf_values[1] # Caso base
    phi[1, 1] <- acf_values[1]

    for (s in 2:max_lag) {
        if (s == 2) {
            phi[s, s] <- (acf_values[s] - acf_values[1]^2) / (1 - acf_values[1]^2)
        } else {
            sum_num <- sum(phi[s - 1, 1:(s - 1)] * acf_values[rev(1:(s - 1))])
            sum_den <- sum(phi[s - 1, 1:(s - 1)] * acf_values[1:(s - 1)])
            phi[s, s] <- (acf_values[s] - sum_num) / (1 - sum_den)
        }

        for (j in 1:(s - 1)) {
            phi[s, j] <- phi[s - 1, j] - phi[s, s] * phi[s - 1, s - j]
        }

        pacf_values[s] <- phi[s, s]
    }

    # Intervalos de confianza para la PACF, 95% de confianza
    pacf_threshold <- 2 * (T^(-0.5))

    # Identificar rezagos significativos para la PACF
    significant_pacf_lags <- which(abs(pacf_values) > pacf_threshold)

    # Comparación con funciones de R
    acf_r <- acf(series, lag.max = max_lag + 1, plot = FALSE)$acf
    pacf_r <- pacf(series, lag.max = max_lag + 1, plot = FALSE)$acf

    # Definir el tamaño mínimo entre los cálculos manuales y las funciones de R
    common_lag <- min(length(acf_values), length(acf_r), length(pacf_values), length(pacf_r))

    # Ajustar el tamaño de los vectores para que coincidan
    acf_values <- acf_values[1:common_lag]
    pacf_values <- pacf_values[1:common_lag]
    acf_r <- acf_r[1:common_lag]
    pacf_r <- pacf_r[1:common_lag]

    # Crear la tabla de comparación con los valores ajustados
    comparison_table <- data.frame(
        Lag = 1:common_lag,
        ACF_Manual = round(acf_values, 4),
        ACF_R = round(acf_r, 4),
        PACF_Manual = round(pacf_values, 4),
        PACF_R = round(pacf_r, 4)
    )

    # print(comparison_table, row.names = FALSE, quote = FALSE)

    # Crear una tabla con los rezagos significativos
    significant_lags_table <- data.frame(
        Lag = c(significant_acf_lags, significant_pacf_lags),
        Type = c(rep("ACF", length(significant_acf_lags)), rep("PACF", length(significant_pacf_lags)))
    )

    # Imprimir la tabla de rezagos significativos si existen
    if (nrow(significant_lags_table) > 0) {
        # cat("\nRezagos Significativos en ACF y PACF:\n")
        # print(significant_lags_table, row.names = FALSE, quote = FALSE)
    } else {
        cat("\nNo hay rezagos significativos detectados en ACF o PACF.\n")
    }

    if (plot) {
        # Función para graficar la comparación
        plot_comparison <- function(manual_values, r_values, title) {
            df <- data.frame(Lag = 1:max_lag, Manual = manual_values, R_Function = r_values)

            ggplot(df, aes(x = Lag)) +
                geom_line(aes(y = Manual, color = "Manual"), linewidth = 1) +
                geom_line(aes(y = R_Function, color = "R Function"), linewidth = 1, linetype = "dashed") +
                theme_minimal() +
                labs(title = title, x = "Rezago", y = "Valor") +
                theme(plot.title = element_text(hjust = 0.5))
        }

        # Crear gráficos de comparación
        plot_acf_comparison <- plot_comparison(acf_values, acf_r, "Comparación ACF")
        plot_pacf_comparison <- plot_comparison(pacf_values, pacf_r, "Comparación PACF")

        # Ajustar tamaño del gráfico
        options(repr.plot.width = 16, repr.plot.height = 8)

        # Mostrar gráficos comparativos
        # grid.arrange(plot_acf_comparison, plot_pacf_comparison, ncol = 2)

        # Graficar la ACF
        acf_plot <- ggplot(data.frame(Lag = 1:max_lag, ACF = acf_values), aes(x = Lag, y = ACF)) +
            geom_bar(stat = "identity", fill = "blue", color = "black") +
            geom_hline(yintercept = c(-acf_threshold_value, acf_threshold_value), linetype = "dashed", color = "red") +
            theme_minimal() +
            labs(title = "Función de Autocorrelación (ACF)", x = "Rezago", y = "ACF") +
            theme(plot.title = element_text(hjust = 0.5))

        # Graficar la PACF
        pacf_plot <- ggplot(data.frame(Lag = 1:max_lag, PACF = pacf_values), aes(x = Lag, y = PACF)) +
            geom_bar(stat = "identity", fill = "green", color = "black") +
            geom_hline(yintercept = c(-pacf_threshold, pacf_threshold), linetype = "dashed", color = "red") +
            theme_minimal() +
            labs(title = "Función de Autocorrelación Parcial (PACF)", x = "Rezago", y = "PACF") +
            theme(plot.title = element_text(hjust = 0.5))

        grid.arrange(pacf_plot, acf_plot, ncol = 2)
    }

    # Definir modelos candidatos
    models <- list()
    model_names <- c()

    # Modelos AR(p)
    if (length(significant_pacf_lags) > 0) {
        for (p in head(significant_pacf_lags, 3)) {
            model_name <- paste0("AR(", p, ")")
            models[[model_name]] <- arima(series, order = c(p, 0, 0))
            model_names <- c(model_names, model_name)
        }
    }

    # Modelos MA(q)
    if (length(significant_acf_lags) > 0) {
        for (q in head(significant_acf_lags, 3)) {
            model_name <- paste0("MA(", q, ")")
            models[[model_name]] <- arima(series, order = c(0, 0, q))
            model_names <- c(model_names, model_name)
        }
    }

    # Modelos ARMA(p, q)
    if (length(significant_pacf_lags) > 0 & length(significant_acf_lags) > 0) {
        for (p in head(significant_pacf_lags, 3)) {
            for (q in head(significant_acf_lags, 3)) {
                model_name <- paste0("ARMA(", p, ",", q, ")")
                models[[model_name]] <- arima(series, order = c(p, 0, q))
                model_names <- c(model_names, model_name)
            }
        }
    }

    # Crear tabla de resultados
    results <- data.frame()
    coefficients_list <- list()
    Q_stats <- c(NA, NA, NA)

    i <- 1
    for (model_name in names(models)) {
        model <- models[[model_name]]
        residuals <- residuals(model)
        sigma_sq <- sum(residuals^2) / T
        log_lik_r <- as.numeric(logLik(model))

        n_params <- length(coef(model))
        aic_mco <- T * log(sigma_sq) + 2 * n_params
        bic_mco <- T * log(sigma_sq) + n_params * log(T)
        aic_mle <- (-2 * log_lik_r) / T + (2 * n_params) / T
        bic_mle <- (-2 * log_lik_r) / T + (n_params * log(T)) / T
        aic_r <- AIC(model)
        bic_r <- BIC(model)

        # Guardar coeficientes del modelo
        coefficients_list[[model_name]] <- coef(model)

        # Calcular Q para los residuos de cada modelo
        if (length(significant_acf_lags) > 0 || length(significant_pacf_lags) > 0) {
            Q_stats <- sapply(c(8, 16, 24), function(s) {
                sum((acf(residuals, plot = FALSE, lag.max = s)$acf)^2 / (T - (1:s))) * T * (T + 2)
            })
            p_values <- 1 - pchisq(Q_stats, df = c(8, 16, 24))
        } else {
            Q_stats <- c(NA, NA, NA)
            cat("\nNo hay rezagos significativos, el estadístico Q de Ljung-Box no se calcula.\n")
        }

        results <- rbind(results, data.frame(
            Model = model_names[i],
            AIC_MCO = round(aic_mco, 2),
            BIC_MCO = round(bic_mco, 2),
            AIC_MLE = round(aic_mle, 2),
            BIC_MLE = round(bic_mle, 2),
            # AIC_R = round(aic_r, 2),
            # BIC_R = round(bic_r, 2),
            Ljung_Box_Q8 = paste0(round(Q_stats[1], 2), " (", round(p_values[1], 3), ")"),
            Ljung_Box_Q16 = paste0(round(Q_stats[2], 2), " (", round(p_values[2], 3), ")"),
            Ljung_Box_Q24 = paste0(round(Q_stats[3], 2), " (", round(p_values[3], 3), ")")
        ))
        i <- i + 1
    }

    # Mostrar tabla de resultados
    if (crit_info) {
        cat("\n\nResultados estimaciones AIC y BIC:\n")
        print(results, row.names = FALSE, quote = FALSE)
        # print(tabla_latex)
    }

    return(list(
        ACF_Manual = acf_values,
        PACF_Manual = pacf_values,
        ACF_R = acf_r,
        PACF_R = pacf_r,
        Models = models,
        Residuals = lapply(models, residuals),
        Coefficients = coefficients_list,
        Q_Estadistico = Q_stats
    ))
}

# Usar la función para calcular la ACF y PACF
results <- acf_pacf_manual(my_data$y, plot = TRUE, crit_info = TRUE)

# Función para análisis de residuos y predicción
analisis_residuos_prediccion <- function(series, p, d, q, H, alpha = 0.95, plot = TRUE) {
    library(ggplot2)
    library(gridExtra)
    library(dplyr)
    library(tidyr)
    library(forecast)
    library(TSA)

    T <- length(series)

    # Convertir la serie en un vector numérico en caso de que sea un objeto ts
    series <- as.numeric(series)

    # Ajustar el modelo ARIMA completo para extraer residuos
    model <- Arima(series, order = c(p, d, q))

    # Extraer residuos del modelo
    residuos <- residuals(model)

    # Calcular estadísticas básicas de los residuos
    mean_res <- mean(residuos)
    var_res <- var(residuos)

    cat("\nMedia de los residuos:", mean_res)
    cat("\nVarianza de los residuos:", var_res, "\n")

    # Calcular ACF y PACF manualmente sin generar gráficos
    acf_pacf_residuos <- acf_pacf_manual(residuos, plot = FALSE, crit_info = FALSE)

    # Extraer el estadístico Q de Ljung-Box
    if (!all(is.na(acf_pacf_residuos$Q_Estadistico))) {
        cat("\nEstadístico Q de Ljung-Box para residuos:\n")
        print(acf_pacf_residuos$Q_Estadistico)
    } else {
        cat("\nNo se calculó el estadístico Q de Ljung-Box porque no hay rezagos significativos.\n")
    }

    # Histograma de los residuos con distribución normal superpuesta
    hist_residuos <- ggplot(data.frame(Residuos = residuos), aes(x = Residuos)) +
        geom_histogram(aes(y = after_stat(density)), fill = "gray", color = "black", bins = 30) +
        stat_function(fun = dnorm, args = list(mean = mean_res, sd = sqrt(var_res)), color = "red", linetype = "dashed") +
        theme_minimal() +
        labs(title = "Histograma de los Residuos con Distribución Normal", x = "Residuos", y = "Densidad")

    # Predicción dentro de la muestra (eliminando los últimos H valores)
    series_train <- series[1:(T - H)]
    model_train <- Arima(series_train, order = c(p, d, q))

    # Predicción de los últimos H valores
    pred <- predict(model_train, n.ahead = H)
    pred_values <- pred$pred
    pred_se <- pred$se

    # Calcular los errores de predicción
    errores <- series[(T - H + 1):T] - pred_values
    MSPE <- mean(errores^2)

    # Construcción de intervalos de confianza
    z_value <- qnorm(1 - (1 - alpha) / 2)
    lower_bound <- pred_values - z_value * pred_se
    upper_bound <- pred_values + z_value * pred_se

    # DataFrame para visualización de predicción
    df_pred <- data.frame(
        Time = (T - H + 1):T,
        Observado = series[(T - H + 1):T],
        Predicho = pred_values,
        Lower = lower_bound,
        Upper = upper_bound
    )

    # Crear un DataFrame con toda la serie y las predicciones
    df_full <- data.frame(
        Time = 1:T,
        Observado = series,
        Predicho = c(rep(NA, T - H), pred_values),
        Lower = c(rep(NA, T - H), lower_bound),
        Upper = c(rep(NA, T - H), upper_bound)
    )

    # Gráfico de la serie original y la predicción usando toda la serie
    pred_plot <- ggplot(df_full, aes(x = Time)) +
        geom_line(aes(y = Observado, color = "Observado"), linewidth = 1) +
        geom_line(aes(y = Predicho, color = "Predicho"), linewidth = 1, linetype = 1) +
        geom_ribbon(aes(ymin = Lower, ymax = Upper), alpha = 0.2, fill = "blue") +
        theme_minimal() +
        labs(title = "Predicción dentro de la Muestra", x = "Tiempo", y = "Valor") +
        theme(plot.title = element_text(hjust = 0.5))

    # Mostrar gráficos
    if (plot) {
        print(hist_residuos)
        print(pred_plot)
    }

    # Devolver resultados
    return(list(
        Residuos = residuos,
        Media_Residuos = mean_res,
        Varianza_Residuos = var_res,
        ACF_Residuos = acf_pacf_residuos$ACF_Manual,
        PACF_Residuos = acf_pacf_residuos$PACF_Manual,
        Q_Estadistico = acf_pacf_residuos$Q_Estadistico,
        Errores = errores,
        MSPE = MSPE,
        Predicciones = df_pred
    ))
}


# Estimar usando la funcion analisis_residuos_prediccion
results2 <- analisis_residuos_prediccion(my_data$y, p = 3, d = 0, q = 3, H = 8)
