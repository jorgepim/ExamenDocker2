-- 1. PRUEBA DE INSERCIÓN 
SELECT 'Paso 1: Registros actuales en tablas' AS info;
SELECT COUNT(*) FROM categories;
SELECT COUNT(*) FROM products;

-- 2. CONSULTA COMPARATIVA (Requerimiento V.2)
SELECT 'Paso 2: Total vendido por categoría' AS info;
SELECT 
    c.name AS categoria, 
    SUM(oi.subtotal) AS total_vendido
FROM categories c
JOIN products p ON c.id = p.category_id
JOIN order_items oi ON p.id = oi.product_id
GROUP BY c.name
ORDER BY total_vendido DESC;

-- 3. PRUEBA DE TRIGGER (Requerimiento V.3)
SELECT 'Paso 3: Prueba de Trigger' AS info;
INSERT INTO order_items (order_id, product_id, quantity, subtotal) 
VALUES (1, 1, 1, 9.99);