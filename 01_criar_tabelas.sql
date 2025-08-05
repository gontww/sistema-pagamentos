-- Criando as tabelas principais

CREATE TABLE produtos (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT,
    preco DECIMAL(10,2) NOT NULL CHECK (preco > 0),
    estoque INTEGER NOT NULL DEFAULT 0 CHECK (estoque >= 0),
    categoria VARCHAR(50),
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    data_atualizacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE clientes (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    cpf VARCHAR(14) UNIQUE NOT NULL,
    telefone VARCHAR(20),
    endereco TEXT,
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ativo BOOLEAN DEFAULT TRUE
);

CREATE TABLE vendas (
    id SERIAL PRIMARY KEY,
    cliente_id INTEGER NOT NULL REFERENCES clientes(id),
    produto_id INTEGER NOT NULL REFERENCES produtos(id),
    quantidade INTEGER NOT NULL CHECK (quantidade > 0),
    preco_unitario DECIMAL(10,2) NOT NULL,
    valor_total DECIMAL(10,2) NOT NULL,
    status_pagamento VARCHAR(20) DEFAULT 'PENDENTE' CHECK (status_pagamento IN ('PENDENTE', 'APROVADO', 'REJEITADO', 'CANCELADO')),
    metodo_pagamento VARCHAR(50),
    data_venda TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    data_pagamento TIMESTAMP,
    observacoes TEXT
);

CREATE TABLE log_estoque (
    id SERIAL PRIMARY KEY,
    produto_id INTEGER NOT NULL REFERENCES produtos(id),
    estoque_anterior INTEGER NOT NULL,
    estoque_novo INTEGER NOT NULL,
    diferenca INTEGER NOT NULL,
    tipo_operacao VARCHAR(20) NOT NULL CHECK (tipo_operacao IN ('VENDA', 'AJUSTE', 'ENTRADA')),
    data_operacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    usuario_operacao VARCHAR(50) DEFAULT 'SISTEMA',
    observacao TEXT
);
