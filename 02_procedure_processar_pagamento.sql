-- Procedure para Processar Pagamentos

CREATE OR REPLACE FUNCTION processar_pagamento(
    p_cliente_id INTEGER,
    p_produto_id INTEGER,
    p_quantidade INTEGER,
    p_metodo_pagamento VARCHAR(50),
    p_observacoes TEXT DEFAULT NULL
)
RETURNS JSON
LANGUAGE plpgsql
AS $$
DECLARE
    v_produto RECORD;
    v_cliente RECORD;
    v_valor_total DECIMAL(10,2);
    v_venda_id INTEGER;
    v_resultado JSON;
    v_estoque_anterior INTEGER;
    v_estoque_novo INTEGER;
BEGIN
    BEGIN
        -- Validar cliente
        SELECT * INTO v_cliente 
        FROM clientes 
        WHERE id = p_cliente_id AND ativo = TRUE;
        
        IF NOT FOUND THEN
            RAISE EXCEPTION 'Cliente não encontrado ou inativo';
        END IF;
        
        -- Validar produto
        SELECT * INTO v_produto 
        FROM produtos 
        WHERE id = p_produto_id;
        
        IF NOT FOUND THEN
            RAISE EXCEPTION 'Produto não encontrado';
        END IF;
        
        IF v_produto.estoque < p_quantidade THEN
            RAISE EXCEPTION 'Estoque insuficiente. Disponível: %, Solicitado: %', 
                          v_produto.estoque, p_quantidade;
        END IF;
        
        -- Calcular valor total
        v_valor_total := v_produto.preco * p_quantidade;
        
        -- Salvar estoque anterior
        v_estoque_anterior := v_produto.estoque;
        v_estoque_novo := v_produto.estoque - p_quantidade;
        
        -- Inserir venda
        INSERT INTO vendas (
            cliente_id, 
            produto_id, 
            quantidade, 
            preco_unitario, 
            valor_total, 
            status_pagamento, 
            metodo_pagamento, 
            data_pagamento, 
            observacoes
        ) VALUES (
            p_cliente_id,
            p_produto_id,
            p_quantidade,
            v_produto.preco,
            v_valor_total,
            'APROVADO',
            p_metodo_pagamento,
            CURRENT_TIMESTAMP,
            p_observacoes
        ) RETURNING id INTO v_venda_id;
        
        -- Atualizar estoque
        UPDATE produtos 
        SET estoque = v_estoque_novo,
            data_atualizacao = CURRENT_TIMESTAMP
        WHERE id = p_produto_id;
        
        -- Registrar log
        INSERT INTO log_estoque (
            produto_id,
            estoque_anterior,
            estoque_novo,
            diferenca,
            tipo_operacao,
            observacao
        ) VALUES (
            p_produto_id,
            v_estoque_anterior,
            v_estoque_novo,
            -p_quantidade,
            'VENDA',
            'Venda processada - Venda ID: ' || v_venda_id
        );
        
        -- Preparar resultado
        v_resultado := json_build_object(
            'success', true,
            'venda_id', v_venda_id,
            'cliente', v_cliente.nome,
            'produto', v_produto.nome,
            'quantidade', p_quantidade,
            'valor_total', v_valor_total,
            'status', 'APROVADO',
            'estoque_restante', v_estoque_novo,
            'data_pagamento', CURRENT_TIMESTAMP
        );
        
        RETURN v_resultado;
        
    EXCEPTION
        WHEN OTHERS THEN
            RAISE;
    END;
END;
$$; 