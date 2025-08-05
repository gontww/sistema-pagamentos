# Sistema de Processamento de Pagamentos

Sistema de processamento de pagamentos com controle de estoque e auditoria.

## Estrutura

### Tabelas
- **produtos** - Cadastro de produtos com controle de estoque
- **clientes** - Cadastro de clientes
- **vendas** - Registro de vendas e pagamentos
- **log_estoque** - Auditoria de movimentações de estoque

### Funcionalidades
- Processamento de pagamentos com validações
- Trigger de auditoria de estoque
- Integridade transacional
- Validações de segurança

## Arquivos

1. `01_criar_tabelas.sql` - Criação das tabelas
2. `02_procedure_processar_pagamento.sql` - Procedure para processar pagamentos
3. `03_trigger_log_estoque.sql` - Trigger para auditoria de estoque
4. `04_dados_exemplo.sql` - Dados de exemplo
5. `05_testes_sistema.sql` - Testes do sistema

## Instalação

### 1. Criar banco de dados
```sql
CREATE DATABASE sistema_pagamentos;
```

### 2. Executar scripts
```bash
psql -d sistema_pagamentos

\i 01_criar_tabelas.sql
\i 02_procedure_processar_pagamento.sql
\i 03_trigger_log_estoque.sql
\i 04_dados_exemplo.sql
\i 05_testes_sistema.sql
```

## Uso

### Processar pagamento
```sql
SELECT processar_pagamento(
    cliente_id => 1,
    produto_id => 1,
    quantidade => 2,
    metodo_pagamento => 'Cartão de Crédito',
    observacoes => 'Compra online'
);
```

### Validações automáticas
- Cliente existe e está ativo
- Produto existe
- Estoque suficiente
- Transação atômica

### Auditoria de estoque
O trigger registra automaticamente:
- Entradas de produtos
- Saídas por vendas
- Ajustes manuais
- Remoções de produtos

## Relatórios

### Vendas
```sql
SELECT 
    c.nome as cliente,
    p.nome as produto,
    v.quantidade,
    v.valor_total,
    v.status_pagamento,
    v.data_pagamento
FROM vendas v
JOIN clientes c ON v.cliente_id = c.id
JOIN produtos p ON v.produto_id = p.id
ORDER BY v.data_pagamento DESC;
```

### Estoque
```sql
SELECT 
    p.nome,
    p.categoria,
    p.preco,
    p.estoque,
    CASE 
        WHEN p.estoque = 0 THEN 'ESGOTADO'
        WHEN p.estoque <= 5 THEN 'BAIXO'
        ELSE 'NORMAL'
    END as status_estoque
FROM produtos p
ORDER BY p.estoque ASC;
```

### Movimentações
```sql
SELECT 
    p.nome as produto,
    l.tipo_operacao,
    l.estoque_anterior,
    l.estoque_novo,
    l.diferenca,
    l.data_operacao
FROM log_estoque l
JOIN produtos p ON l.produto_id = p.id
ORDER BY l.data_operacao DESC;
```

## Segurança

### Validações
- Estoque: Não permite vendas com estoque insuficiente
- Cliente: Verifica se cliente existe e está ativo
- Transações: Rollback automático em caso de erro
- Auditoria: Log completo de todas as operações

### Constraints
- Preços positivos
- Quantidades positivas
- Estoque não negativo
- Status de pagamento válidos
- CPF e email únicos

## Testes

O arquivo `05_testes_sistema.sql` inclui testes para:
- Processamento de pagamento válido
- Validação de estoque insuficiente
- Múltiplas vendas
- Atualização manual de estoque
- Relatórios de vendas
- Relatórios de estoque
- Histórico de movimentações

## Requisitos

- PostgreSQL 12 ou superior
- Encoding UTF-8
- Timezone UTC 