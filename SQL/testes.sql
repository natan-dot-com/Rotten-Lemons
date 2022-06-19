\i drop.sql
\i esquema.sql
\i dados.sql

-- Testes p/ tabela USUARIO
INSERT INTO USUARIO VALUES ('validuser', FALSE, 'invalidmail.br', 
    TO_DATE('31/12/1999', 'DD/MM/YYYY'), 'U'); --> E-mail inválido
INSERT INTO USUARIO VALUES ('validuser', FALSE, 'validmail@usp.br', 
    TO_DATE('31/12/1999', 'DD/MM/YYYY'), 'invalid'); --> Cargo inválido


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

-- Testes trigger TRIGGER_PERMISSAO_BAN()
\echo '-----------------------------------------------------'
\echo 'Testes Trigger permissao para banir'
\echo '\nCaso 1: Moderador banindo usuario normal (Válido)'
INSERT INTO BANIDO_POR VALUES ('usuario1', 'moderador1', current_date, 10);
SELECT * FROM BANIDO_POR;

\echo '\nCaso 2: Administrador banindo usuario normal (Válido)'
INSERT INTO BANIDO_POR VALUES ('usuario2', 'admin1', current_date, 10);
SELECT * FROM BANIDO_POR;

\echo '\nCaso 3: Moderador banindo administrador (Inválido)'
INSERT INTO BANIDO_POR VALUES ('admin1', 'moderador1', current_date, 10);
SELECT * FROM BANIDO_POR;

\echo '\nCaso 4: Administrador banindo moderador (Válido)'
INSERT INTO BANIDO_POR VALUES ('moderador1', 'admin1', current_date, 10);
SELECT * FROM BANIDO_POR;

\echo '\nCaso 5: Moderador banindo moderador (Inválido)'
INSERT INTO BANIDO_POR VALUES ('moderador1', 'moderador1', current_date, 10);
SELECT * FROM BANIDO_POR;

\echo '\nCaso 6: Administrador banindo administrador (Válido) ??'
INSERT INTO BANIDO_POR VALUES ('admin1', 'admin2', current_date, 10);
SELECT * FROM BANIDO_POR;
\echo '-----------------------------------------------------'


-- Testes TRIGGER_PERMISSAO_REMOVE_COMENTARIO()
-- Trigger para que usuarios banidos não comentem?
INSERT INTO COMENTARIO (USUARIO, DATA_PUBL, CONTEUDO, TIPO)
    VALUES ('usuario1', current_date, 'lorem ipsum', 'ARTISTA');
INSERT INTO COMENTARIO (USUARIO, DATA_PUBL, CONTEUDO, TIPO)
    VALUES ('usuario2', current_date, 'lorem ipsum', 'ARTISTA');
INSERT INTO COMENTARIO (USUARIO, DATA_PUBL, CONTEUDO, TIPO)
    VALUES ('usuario1', TO_DATE('31/12/2010', 'DD/MM/YYYY'), 'lorem ipsum', 'ALBUM');
INSERT INTO COMENTARIO (USUARIO, DATA_PUBL, CONTEUDO, TIPO)
    VALUES ('usuario2', TO_DATE('31/12/2010', 'DD/MM/YYYY'), 'lorem ipsum', 'ALBUM');
INSERT INTO COMENTARIO (USUARIO, DATA_PUBL, CONTEUDO, TIPO)
    VALUES ('usuario1', TO_DATE('31/12/1999', 'DD/MM/YYYY'), 'lorem ipsum', 'MUSICA');
INSERT INTO COMENTARIO (USUARIO, DATA_PUBL, CONTEUDO, TIPO)
    VALUES ('usuario2', TO_DATE('31/12/1999', 'DD/MM/YYYY'), 'lorem ipsum', 'MUSICA');

SELECT * FROM COMENTARIO;
\echo '-----------------------------------------------------'
\echo 'Testes permissao para remover comentario'
\echo '\nCaso 1: Moderador removendo um comentario'
INSERT INTO COMENTARIO_REMOVIDO VALUES (1, 'moderador1');

\echo '\nCaso 2: Admin removendo um comentario'
INSERT INTO COMENTARIO_REMOVIDO VALUES (2, 'admin1');

\echo '\nCaso 3: Usuario (não autor) removendo um comentario'
INSERT INTO COMENTARIO_REMOVIDO VALUES (3, 'usuario2');

\echo '\nCaso 4: Usuario (autor) removendo um comentario'
INSERT INTO COMENTARIO_REMOVIDO VALUES (5, 'usuario1');

\echo '\nCaso 5: Um moderador diferente removendo um mesmo comentario (inválido)'
INSERT INTO COMENTARIO_REMOVIDO VALUES (1, 'moderador2');

SELECT * FROM COMENTARIO_REMOVIDO;
\echo '-----------------------------------------------------'

-- Testes TRIGGER_ALBUM_CIRCULAR()
\echo '-----------------------------------------------------'
\echo 'Testes album circular'
INSERT INTO ARTISTA VALUES ('artista1');
INSERT INTO ARTISTA VALUES ('artista2');
INSERT INTO ARTISTA VALUES ('artista3');
INSERT INTO ARTISTA VALUES ('artista4');

INSERT INTO ALBUM (NOME_ALBUM, ARTISTA) VALUES ('album1', 'artista1');
INSERT INTO ALBUM (NOME_ALBUM, ARTISTA) VALUES ('album2', 'artista2');

SELECT * FROM ALBUM;

\echo '\nCaso 1: Inserindo artista participante válido'
INSERT INTO PARTICIPA_ALBUM VALUES (1, 'artista2');
INSERT INTO PARTICIPA_ALBUM VALUES (1, 'artista3');
INSERT INTO PARTICIPA_ALBUM VALUES (2, 'artista1');

\echo '\nCaso 2: Inserindo artista participante inválido'
INSERT INTO PARTICIPA_ALBUM VALUES (2, 'artista2');

SELECT * FROM PARTICIPA_ALBUM;
\echo '-----------------------------------------------------'

-- Testes TRIGGER_PERMISSAO_REMOVE_TAG()
\echo '-----------------------------------------------------'
\echo 'Testando TRIGGER_PERMISSAO_REMOVE_TAG'
\echo '\nCaso 1: Admin removendo tag:'
INSERT INTO TAG_REMOVIDA VALUES('Feliz', 'NatanSanches', 10);

\echo '\nCaso 2: Moderador removendo tag:'
INSERT INTO TAG_REMOVIDA VALUES('Triste', 'PauloSoares', 9);

\echo '\nCaso 3: Usuario comum removendo tag:'
INSERT INTO TAG_REMOVIDA VALUES('Pensativo', 'PedroAugusto', 7);
\echo '-----------------------------------------------------'

-- Testes TRIGGER_BLOQUEIA_BANIDOS()
\echo '-----------------------------------------------------'
\echo 'Testando TRIGGER_BLOQUEIA_BANIDOS'
\echo '\nCaso 1: Usuario não banido tentando classificar uma musica'
INSERT INTO CLASSIFICA_POR VALUES(10, 'Curioso', 'PedroAugusto');

\echo '\nCaso 2: Usuario banido tentando classificar uma musica'
INSERT INTO CLASSIFICA_POR VALUES(10, 'Curioso', 'GabrielDetoni');

\echo '\nCaso 3: Usuario não banido (com permissão) removendo uma tag'
INSERT INTO TAG_REMOVIDA VALUES ('Pensativo', 'AlvaroLopes', 6);

\echo '\nCaso 4: Usuario banido (com permissao) removendo uma tag'
INSERT INTO TAG_REMOVIDA VALUES ('Curioso', 'GabrielDetoni', 10);

\echo '\nCaso5: Usuario nao banido curtindo uma playlist'
INSERT INTO CURTE VALUES('PauloSoares', 2);

\echo '\nCaso6: Usuario banido curtindo uma playlist'
INSERT INTO CURTE VALUES ('GabrielDetoni', 2);

\echo '\nCaso 7: Usuario nao banido avaliando uma musica'
INSERT INTO AVALIA VALUES ('NatanSanches', 10, 2);

\echo '\nCaso 8: Usuario banido avaliando uma musica'
INSERT INTO AVALIA VALUES ('OsniBrito', 9, 5);
\echo '-----------------------------------------------------'


