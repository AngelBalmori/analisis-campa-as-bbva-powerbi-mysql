-- --------------------------------------------
-- 📁 Proyecto: Análisis de campañas BBVA
-- 📊 Autor: Ángel Balmori
-- 🛠️ Herramientas: MySQL + Power BI
-- --------------------------------------------

-- ================================
-- 1. Simulación de estructura base
-- ================================

CREATE TABLE productos_enlatados (
  idproductos_enlatados INT PRIMARY KEY,
  marca VARCHAR(100),
  nombre_producto VARCHAR(100)
);

CREATE TABLE ventas (
  id_venta INT PRIMARY KEY,
  id_producto INT,
  cantidad INT,
  fecha DATE,
  FOREIGN KEY (id_producto) REFERENCES productos_enlatados(idproductos_enlatados)
);

-- ... (Agrega aquí las otras tablas: campañas, anuncios, resultados, audiencias, agencias)


-- ================================
-- 2. Consultas analíticas
-- ================================

-- Total de unidades vendidas por marca (proyecto de productos)
SELECT 
  p.marca,
  SUM(v.cantidad) AS total_vendido
FROM ventas v
JOIN productos_enlatados p ON v.id_producto = p.idproductos_enlatados
GROUP BY p.marca
ORDER BY total_vendido DESC;

-- ---------------------------------------------------------

-- Desempeño por campaña (campañas + anuncios + resultados)
SELECT 
  c.nombre AS nombre_campaña,
  c.canal,
  c.presupuesto_mxn,
  SUM(r.impresiones) AS total_impresiones,
  SUM(r.clics) AS total_clics,
  SUM(r.conversiones) AS total_conversiones,
  SUM(r.costo_mxn) AS total_costo
FROM campañas_bbva.campañas c
JOIN campañas_bbva.anuncios a ON c.id_campaña = a.id_campaña
JOIN campañas_bbva.resultados r ON a.id_anuncio = r.id_anuncio
GROUP BY c.id_campaña, c.nombre, c.canal, c.presupuesto_mxn;

-- ---------------------------------------------------------

-- Desempeño por segmento, ciudad y género
SELECT 
  c.nombre AS nombre_campaña,
  au.ciudad,
  au.segmento,
  au.genero,
  SUM(r.conversiones) AS total_conversiones,
  SUM(r.clics) AS total_clics,
  SUM(r.impresiones) AS total_impresiones
FROM campañas_bbva.audiencias au
JOIN campañas_bbva.campañas c ON au.id_campaña = c.id_campaña
JOIN campañas_bbva.anuncios a ON c.id_campaña = a.id_campaña
JOIN campañas_bbva.resultados r ON a.id_anuncio = r.id_anuncio
GROUP BY c.nombre, au.ciudad, au.segmento, au.genero;

-- ---------------------------------------------------------

-- Desempeño por agencia (Join entre campañas y agencias)
SELECT 
  ag.nombre_agencia,
  ag.tipo_medios,
  ag.responsable,
  SUM(r.impresiones) AS total_impresiones,
  SUM(r.clics) AS total_clics,
  SUM(r.conversiones) AS total_conversiones,
  SUM(r.costo_mxn) AS total_costo
FROM campañas_bbva.resultados r
JOIN campañas_bbva.anuncios a ON r.id_anuncio = a.id_anuncio
JOIN campañas_bbva.campañas c ON a.id_campaña = c.id_campaña
JOIN campañas_bbva.agencias ag ON c.id_campaña = ag.id_agencia
GROUP BY ag.nombre_agencia, ag.tipo_medios, ag.responsable;








