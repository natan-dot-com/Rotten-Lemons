CREATE OR REPLACE FUNCTION TRIGGER_PERMISSAO_REMOVER_COMENTARIO()
    RETURNS TRIGGER
AS $$
DECLARE _CARGO_AUTOR      CHAR(1);
        _NOME_USUARIO     CHAR(50);
BEGIN
    SELECT U.CARGO INTO _CARGO_AUTOR FROM USUARIO U
        WHERE U.NOME_USUARIO = NEW.NOME_USUARIO;

    SELECT C.NOME_USUARIO INTO _NOME_USUARIO FROM
        COMENTARIO C WHERE C.ID_COMENTARIO = NEW.ID_COMENTARIO;

    IF (_CARGO_AUTOR IN ('M', 'A') OR _NOME_USUARIO = NEW.NOME_USUARIO) THEN
        RETURN NEW;
    END IF;

    RAISE EXCEPTION '% nao possui permissao para remover', 
        NEW.NOME_USUARIO;
    RETURN NULL;
END;
$$
LANGUAGE PLPGSQL;

CREATE OR REPLACE FUNCTION TRIGGER_TAG_REMOVER_PERMISSAO()
    RETURNS TRIGGER
AS $$
DECLARE _CARGO_AUTOR      CHAR(1);
BEGIN
    SELECT U.CARGO INTO _CARGO_AUTOR FROM USUARIO U
        WHERE U.NOME_USUARIO = NEW.NOME_USUARIO;

    IF (_CARGO_AUTOR NOT IN ('M', 'A')) THEN
        RAISE EXCEPTION 'Usuario % nao tem permissao de
            remover tag', NEW.NOME_USUARIO;
        RETURN NULL;
    END IF;

    DELETE FROM CLASSIFICA_POR CP WHERE 
        CP.TAG = NEW.TAG AND CP.ID_MUSICA = NEW.MUSICA;
    RETURN NEW;
END;
$$
LANGUAGE PLPGSQL;