-- Dados de Exemplo

INSERT INTO produtos (nome, descricao, preco, estoque, categoria) VALUES
('Notebook Dell Inspiron', 'Notebook Dell Inspiron 15 polegadas, 8GB RAM, 256GB SSD', 2999.99, 10, 'Eletrônicos'),
('Mouse Gamer Logitech', 'Mouse gamer com 6 botões programáveis e RGB', 199.99, 25, 'Periféricos'),
('Teclado Mecânico', 'Teclado mecânico com switches Cherry MX Blue', 399.99, 15, 'Periféricos'),
('Monitor LG 24"', 'Monitor LG 24 polegadas Full HD, 75Hz', 899.99, 8, 'Monitores'),
('SSD Kingston 500GB', 'SSD Kingston A2000 500GB NVMe M.2', 299.99, 30, 'Armazenamento'),
('Memória RAM 16GB', 'Memória RAM DDR4 16GB 3200MHz', 199.99, 20, 'Componentes'),
('Placa de Vídeo RTX 3060', 'Placa de vídeo NVIDIA RTX 3060 12GB', 2499.99, 5, 'Componentes'),
('Processador Intel i5', 'Processador Intel Core i5-10400F 6 cores', 899.99, 12, 'Componentes');

INSERT INTO clientes (nome, email, cpf, telefone, endereco) VALUES
('João Silva', 'joao.silva@email.com', '123.456.789-01', '(11) 99999-1111', 'Rua das Flores, 123 - São Paulo/SP'),
('Maria Santos', 'maria.santos@email.com', '987.654.321-09', '(11) 88888-2222', 'Av. Paulista, 456 - São Paulo/SP'),
('Pedro Oliveira', 'pedro.oliveira@email.com', '456.789.123-45', '(11) 77777-3333', 'Rua Augusta, 789 - São Paulo/SP'),
('Ana Costa', 'ana.costa@email.com', '789.123.456-78', '(11) 66666-4444', 'Rua Oscar Freire, 321 - São Paulo/SP'),
('Carlos Ferreira', 'carlos.ferreira@email.com', '321.654.987-32', '(11) 55555-5555', 'Alameda Santos, 654 - São Paulo/SP');

SELECT 'Produtos inseridos:' as info;
SELECT id, nome, preco, estoque, categoria FROM produtos ORDER BY id;

SELECT 'Clientes inseridos:' as info;
SELECT id, nome, email, cpf FROM clientes ORDER BY id; 