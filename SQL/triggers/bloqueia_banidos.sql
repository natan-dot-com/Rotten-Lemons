CREATE OR REPLACE FUNCTION TRIGGER_BLOQUEIA_BANIDOS()
    RETURNS TRIGGER
AS $$
DECLARE
BEGIN
    IF EXISTS (SELECT * FROM BANIDO_POR BP
        WHERE BP.USUARIO_BANIDO = NEW.NOME_USUARIO) THEN
            RAISE EXCEPTION '...';
            RETURN NULL;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE PLPGSQL;
