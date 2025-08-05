-- Trigger para Log de Estoque

CREATE OR REPLACE FUNCTION log_mudanca_estoque()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_tipo_operacao VARCHAR(20);
    v_observacao TEXT;
BEGIN
    IF TG_OP = 'INSERT' THEN
        v_tipo_operacao := 'ENTRADA';
        v_observacao := 'Produto adicionado ao estoque';
        
        INSERT INTO log_estoque (
            produto_id,
            estoque_anterior,
            estoque_novo,
            diferenca,
            tipo_operacao,
            observacao
        ) VALUES (
            NEW.id,
            0,
            NEW.estoque,
            NEW.estoque,
            v_tipo_operacao,
            v_observacao
        );
        
    ELSIF TG_OP = 'UPDATE' THEN
        IF OLD.estoque != NEW.estoque THEN
            IF NEW.estoque > OLD.estoque THEN
                v_tipo_operacao := 'ENTRADA';
                v_observacao := 'Estoque aumentado';
            ELSIF NEW.estoque < OLD.estoque THEN
                v_tipo_operacao := 'AJUSTE';
                v_observacao := 'Estoque reduzido';
            END IF;
            
            INSERT INTO log_estoque (
                produto_id,
                estoque_anterior,
                estoque_novo,
                diferenca,
                tipo_operacao,
                observacao
            ) VALUES (
                NEW.id,
                OLD.estoque,
                NEW.estoque,
                NEW.estoque - OLD.estoque,
                v_tipo_operacao,
                v_observacao || ' - Produto: ' || NEW.nome
            );
        END IF;
        
    ELSIF TG_OP = 'DELETE' THEN
        v_tipo_operacao := 'AJUSTE';
        v_observacao := 'Produto removido do estoque';
        
        INSERT INTO log_estoque (
            produto_id,
            estoque_anterior,
            estoque_novo,
            diferenca,
            tipo_operacao,
            observacao
        ) VALUES (
            OLD.id,
            OLD.estoque,
            0,
            -OLD.estoque,
            v_tipo_operacao,
            v_observacao || ' - Produto: ' || OLD.nome
        );
    END IF;
    
    RETURN COALESCE(NEW, OLD);
END;
$$;

CREATE TRIGGER trigger_log_estoque
    AFTER INSERT OR UPDATE OR DELETE ON produtos
    FOR EACH ROW
    EXECUTE FUNCTION log_mudanca_estoque(); 