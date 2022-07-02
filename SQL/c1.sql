-- C1: Recupera os comentários de críticos referentes a músicas
-- Retorno:  nome_usuario  |  conteudo  |     nome_musica     |  nome_album   |  artista
SELECT U.NOME_USUARIO, C.CONTEUDO, M.NOME_MUSICA, A.NOME_ALBUM, A.ARTISTA FROM 
    COMENTARIO_MUSICA CM NATURAL JOIN COMENTARIO C 
    NATURAL JOIN USUARIO U
    JOIN MUSICA M ON M.ID_MUSICA = CM.ID_MUSICA
    JOIN ALBUM A ON A.ID_ALBUM = M.ALBUM
    WHERE U.EH_CRITICO = TRUE;