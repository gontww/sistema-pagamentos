-- Testes do Sistema

SELECT '=== TESTE 1: Processar pagamento válido ===' as teste;
SELECT processar_pagamento(1, 1, 2, 'Cartão de Crédito', 'Compra online');

SELECT 'Vendas após pagamento:' as info;
SELECT 
    v.id,
    c.nome as cliente,
    p.nome as produto,
    v.quantidade,
    v.valor_total,
    v.status_pagamento,
    v.data_pagamento
FROM vendas v
JOIN clientes c ON v.cliente_id = c.id
JOIN produtos p ON v.produto_id = p.id
ORDER BY v.id DESC
LIMIT 3;

SELECT 'Estoque atualizado:' as info;
SELECT id, nome, estoque, categoria FROM produtos WHERE id = 1;

SELECT 'Log de estoque:' as info;
SELECT 
    l.id,
    p.nome as produto,
    l.estoque_anterior,
    l.estoque_novo,
    l.diferenca,
    l.tipo_operacao,
    l.data_operacao
FROM log_estoque l
JOIN produtos p ON l.produto_id = p.id
ORDER BY l.id DESC
LIMIT 5;

SELECT '=== TESTE 2: Tentar comprar mais que o estoque ===' as teste;
SELECT processar_pagamento(2, 1, 15, 'PIX', 'Compra grande');

SELECT '=== TESTE 3: Processar outro pagamento válido ===' as teste;
SELECT processar_pagamento(3, 2, 3, 'Boleto Bancário', 'Compra de periféricos');

SELECT '=== TESTE 4: Atualizar estoque manualmente ===' as teste;
UPDATE produtos SET estoque = estoque + 5 WHERE id = 1;

SELECT 'Log após atualização manual:' as info;
SELECT 
    l.id,
    p.nome as produto,
    l.estoque_anterior,
    l.estoque_novo,
    l.diferenca,
    l.tipo_operacao,
    l.observacao
FROM log_estoque l
JOIN produtos p ON l.produto_id = p.id
WHERE p.id = 1
ORDER BY l.id DESC
LIMIT 3;

SELECT '=== TESTE 5: Relatório de vendas ===' as info;
SELECT 
    c.nome as cliente,
    p.nome as produto,
    v.quantidade,
    v.valor_total,
    v.status_pagamento,
    v.metodo_pagamento,
    v.data_pagamento
FROM vendas v
JOIN clientes c ON v.cliente_id = c.id
JOIN produtos p ON v.produto_id = p.id
ORDER BY v.data_pagamento DESC;

SELECT '=== TESTE 6: Relatório de estoque ===' as info;
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

SELECT '=== TESTE 7: Histórico de movimentações ===' as info;
SELECT 
    p.nome as produto,
    l.tipo_operacao,
    l.estoque_anterior,
    l.estoque_novo,
    l.diferenca,
    l.data_operacao,
    l.observacao
FROM log_estoque l
JOIN produtos p ON l.produto_id = p.id
ORDER BY l.data_operacao DESC
LIMIT 10; 