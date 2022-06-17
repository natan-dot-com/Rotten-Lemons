-- Testes p/ tabela USUARIO
INSERT INTO USUARIO VALUES ('validuser', FALSE, 'invalidmail.br', 
    TO_DATE('31/12/1999', 'DD/MM/YYYY', 'U')); --> E-mail inválido
INSERT INTO USUARIO VALUES ('validuser', FALSE, 'validmail@usp.br', 
    TO_DATE('31/12/1999', 'DD/MM/YYYY', 'invalid')); --> Cargo inválido 