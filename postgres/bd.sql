-- DDL: Esquema PostgreSQL
CREATE TABLE categories (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    category_id INT,
    FOREIGN KEY (category_id) REFERENCES categories(id)
);

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    user_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE order_items (
    id SERIAL PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT NOT NULL CHECK (quantity > 0),
    subtotal DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);

--TRIGGER
CREATE OR REPLACE FUNCTION fn_check_subtotal_pg()
RETURNS TRIGGER AS $$
DECLARE
    v_price DECIMAL(10,2);
BEGIN
    SELECT price INTO v_price FROM products WHERE id = NEW.product_id;
    
    IF NEW.subtotal != (v_price * NEW.quantity) THEN
        RAISE EXCEPTION 'Error: El subtotal ingresado no coincide con el cálculo (precio * cantidad).';
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_check_subtotal_postgres
BEFORE INSERT ON order_items
FOR EACH ROW
EXECUTE FUNCTION fn_check_subtotal_pg();



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