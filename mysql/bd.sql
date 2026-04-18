-- DDL: Esquema MySQL
CREATE TABLE categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    category_id INT,
    FOREIGN KEY (category_id) REFERENCES categories(id)
);

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE order_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT NOT NULL CHECK (quantity > 0),
    subtotal DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);

--TRIGGER
DELIMITER //
CREATE TRIGGER trg_check_subtotal_mysql
BEFORE INSERT ON order_items
FOR EACH ROW
BEGIN
    DECLARE v_price DECIMAL(10,2);
    SELECT price INTO v_price FROM products WHERE id = NEW.product_id;
    
    IF NEW.subtotal != (v_price * NEW.quantity) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: El subtotal ingresado no coincide con el cálculo (precio * cantidad).';
    END IF;
END;//
DELIMITER ;



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
(1, 1, 1, 1200.00), -- 1200 * 1
(2, 2, 2, 301.00),  -- 150.50 * 2
(3, 3, 4, 100.00),  -- 25 * 4
(4, 4, 1, 30.00),   -- 30 * 1
(5, 5, 2, 90.00);   -- 45 * 2