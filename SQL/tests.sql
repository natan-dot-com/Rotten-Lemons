-- Testes p/ tabela USUARIO
INSERT INTO USUARIO VALUES ('validuser', FALSE, 'invalidmail.br', 
    TO_DATE('31/12/1999', 'DD/MM/YYYY'), 'U'); --> E-mail inválido
INSERT INTO USUARIO VALUES ('validuser', FALSE, 'validmail@usp.br', 
    TO_DATE('31/12/1999', 'DD/MM/YYYY'), 'invalid'); --> Cargo inválido


-- Testes trigger TRIGGER_PERMISSAO_BAN()
INSERT INTO USUARIO VALUES ('moderador1', FALSE, 'moderador1@rottenlemons.com', 
    TO_DATE('31/12/1999', 'DD/MM/YYYY'), 'M'); --> Usuario valido (moderador)
INSERT INTO USUARIO VALUES ('moderador2', FALSE, 'moderador2@rottenlemons.com', 
    TO_DATE('31/12/1999', 'DD/MM/YYYY'), 'M'); --> Usuario valido (moderador)
INSERT INTO USUARIO VALUES ('usuario1', FALSE, 'usuario1@rottenlemons.com', 
    TO_DATE('31/12/2010', 'DD/MM/YYYY'), 'U'); --> Usuario valido (usuario1)
INSERT INTO USUARIO VALUES ('usuario2', FALSE, 'usuario2@rottenlemons.com', 
    TO_DATE('11/12/2010', 'DD/MM/YYYY'), 'U'); --> Usuario valido (usuario1)
INSERT INTO USUARIO VALUES ('admin1', FALSE, 'admin1@rottenlemons.com', 
    TO_DATE('31/12/1999', 'DD/MM/YYYY'), 'A'); --> Usuario valido (administrador)
INSERT INTO USUARIO VALUES ('admin2', FALSE, 'admin2@rottenlemons.com', 
    TO_DATE('31/12/1999', 'DD/MM/YYYY'), 'A'); --> Usuario valido (administrador)

SELECT * FROM USUARIO;

-- Caso 1: Moderador banindo usuario normal (Válido)
INSERT INTO BANIDO_POR VALUES ('usuario1', 'moderador1', current_date, 10);
SELECT * FROM BANIDO_POR;

-- Caso 2: Administrador banindo usuario normal (Válido)
INSERT INTO BANIDO_POR VALUES ('usuario2', 'admin1', current_date, 10);
SELECT * FROM BANIDO_POR;

-- Caso 3: Moderador banindo administrador (Inválido)
INSERT INTO BANIDO_POR VALUES ('admin1', 'moderador1', current_date, 10);
SELECT * FROM BANIDO_POR;

-- Caso 4: Administrador banindo moderador (Válido)
INSERT INTO BANIDO_POR VALUES ('moderador1', 'admin1', current_date, 10);
SELECT * FROM BANIDO_POR;

-- Caso 5: Moderador banindo moderador (Inválido)
INSERT INTO BANIDO_POR VALUES ('moderador1', 'moderador1', current_date, 10);
SELECT * FROM BANIDO_POR;

-- Caso 6: Administrador banindo administrador (Válido) ??
INSERT INTO BANIDO_POR VALUES ('admin1', 'admin2', current_date, 10);
SELECT * FROM BANIDO_POR;