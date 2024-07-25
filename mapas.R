rm(list=ls())
library(tidyverse)
setwd("~/Documentos/Concursos/Finanzas Publicas/")
datos = read.csv("porcentaje_no_moratoria_pcia.csv")
summary(datos)
library(sf)
mapa = st_read("provincias_sin_antartida.geojson")
library(mapview)
mapa = rename(mapa, Provincia = NOMBRE)
mapa$Provincia = ifelse(mapa$Provincia == "Ciudad Autónoma de Buenos Aires",
                        "CABA", mapa$Provincia)
mapa$Provincia = ifelse(mapa$Provincia == "Tierra del Fuego, Antártida e Islas del Atlántico Sur",
                        "Tierra del Fuego", mapa$Provincia)
mapa = left_join(mapa, datos)
mapa
summary(mapa$Regulares)
mapa$Moratoria = 1 - mapa$Regulares
summary(mapa$Moratoria)
mapview(mapa, zcol = "Moratoria", at = c(0,0.5,0.6,0.7,1),
        col.regions = rev(RColorBrewer::brewer.pal(4, "Spectral")))

# Haberes medios de los beneficios de jubilaciones del SIPA (NO MORATORIA, marzo 2024) en relación a 
# Salario promedio de los asalariados registrados del sector privado (noviembre de 2023)
datos = read.csv("cociente_haberes_salarios_pcias.csv")
datos$cociente = datos$Haber / datos$Salario
mapa = left_join(mapa, datos)
summary(mapa$cociente)
mapview(mapa, zcol = "cociente", at = c(0,0.7,0.8,0.9,1),
        col.regions = rev(RColorBrewer::brewer.pal(4, "Spectral")))
