docker exec -i postgres_local psql -U admin -d lab_tienda < schema_postgres.sql 
--INSERTS
INSERT INTO categories (name) VALUES 
('Electrónica'), ('Hogar'), ('Ropa'), ('Deportes'), ('Libros');

INSERT INTO products (name, price, category_id) VALUES 
('Laptop Dell', 1200.00, 1),
('Silla Ergonómica', 150.50, 2),
('Camiseta Algodón', 25.00, 3),
('Balón de Fútbol', 30.00, 4),
('Clean Code', 45.00, 5);

INSERT INTO users (username, email) VALUES 
('dev_master', 'dev@doublevistudio.com'),
('admin_sys', 'admin@empresa.com'),
('test_user', 'test@test.com'),
('linux_fan', 'linux@mint.com'),
('go_coder', 'backend@go.org');

INSERT INTO orders (user_id) VALUES 
(1), (2), (3), (4), (5);

INSERT INTO order_items (order_id, product_id, quantity, subtotal) VALUES 
(1, 1, 1, 1200.00),
(2, 2, 2, 301.00), 
(3, 3, 4, 100.00), 
(4, 4, 1, 30.00),  
(5, 5, 2, 90.00);