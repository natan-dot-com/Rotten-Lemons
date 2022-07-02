-- C1: Consultar as tags mais populares de cada música
-- Retorno: | Nome do Artista | Nome do Álbum | Nome da Música | Nome da Tag mais popular | Número de vezes utilizada |
\echo 'Consulta 1: Consultar as tags mais populares de cada música. Citar também as músicas sem tags classificadas.'

SELECT DISTINCT ON (TMP.NOME_MUSICA) AR.NOME_ARTISTA, AL.NOME_ALBUM, TMP.NOME_MUSICA, 
    TAG_POPULAR, CONTAGEM_UTILIZACOES 
        FROM ARTISTA AR
        JOIN ALBUM AL ON (AR.NOME_ARTISTA = AL.ARTISTA)
        RIGHT JOIN (
            SELECT M.NOME_MUSICA, M.ALBUM, COALESCE(CP.TAG, '-') AS TAG_POPULAR, 
                COUNT(CP.TAG) AS CONTAGEM_UTILIZACOES
                    FROM MUSICA M
                    LEFT JOIN CLASSIFICA_POR CP ON (M.ID_MUSICA = CP.ID_MUSICA)
                    GROUP BY M.NOME_MUSICA, CP.TAG, M.ALBUM
                    ORDER BY M.NOME_MUSICA, COUNT(CP.TAG) DESC
        ) TMP ON (TMP.ALBUM = AL.ID_ALBUM)
        ORDER BY TMP.NOME_MUSICA;

-- C2: Selecionar músicas que foram classificadas com todas as tags disponíveis
-- Retorno: | Nome do Artista | Nome do Álbum | Nome da Música |
\echo 'Consulta 2: Selecionar músicas que foram classificadas com todas as tags disponíveis'

SELECT DISTINCT AR.NOME_ARTISTA, AL.NOME_ALBUM, M.NOME_MUSICA
    FROM ARTISTA AR
    JOIN ALBUM AL ON (AL.ARTISTA = AR.NOME_ARTISTA)
    JOIN MUSICA M ON (M.ALBUM = AL.ID_ALBUM)
    WHERE NOT EXISTS (
        (SELECT * FROM TAG)
        EXCEPT
        (SELECT CP.TAG FROM CLASSIFICA_POR CP WHERE CP.ID_MUSICA = M.ID_MUSICA)
    );

-- C3: Recuperar os comentários de críticos referentes a músicas
-- Retorno: | Nome de usuário | Conteúdo | Nome da Música | Nome do Álbum | Nome do Artista |
\echo 'Consulta 3: Recuperar os comentários de críticos referentes a músicas'

SELECT U.NOME_USUARIO, C.CONTEUDO, M.NOME_MUSICA, A.NOME_ALBUM, A.ARTISTA FROM 
    COMENTARIO_MUSICA CM NATURAL JOIN COMENTARIO C 
    NATURAL JOIN USUARIO U
    JOIN MUSICA M ON M.ID_MUSICA = CM.ID_MUSICA
    JOIN ALBUM A ON A.ID_ALBUM = M.ALBUM
    WHERE U.EH_CRITICO = TRUE;

-- C4: Visualizar as notas médias dos artistas (sendo eles as notas médias dos álbuns,
-- que por consequência são as notas das músicas do álbum).
-- Retorno: | Nome do Artista | Nota Média do Artista |
\echo 'Consulta 4: Visualizar as notas médias dos artistas'

SELECT AR.NOME_ARTISTA, ROUND(AVG(NOTA_ALBUM), 3) AS NOTA_ARTISTA
FROM ARTISTA AR, (
    SELECT AL.NOME_ALBUM, AL.ARTISTA, ROUND(AVG(NOTA_MUSICA), 3) AS NOTA_ALBUM
    FROM ALBUM AL, (
        SELECT M.ID_MUSICA, M.ALBUM, ROUND(AVG(A.ESTRELAS), 3) AS NOTA_MUSICA
        FROM MUSICA M, AVALIA A
        WHERE M.ID_MUSICA = A.ID_MUSICA
        GROUP BY (M.ID_MUSICA, M.ALBUM)
    ) NOTAS_M
    WHERE NOTAS_M.ALBUM = AL.ID_ALBUM
    GROUP BY (AL.NOME_ALBUM, AL.ARTISTA)
) NOTAS_AL
WHERE NOTAS_AL.ARTISTA = AR.NOME_ARTISTA
GROUP BY (AR.NOME_ARTISTA)
ORDER BY (NOTA_ARTISTA) DESC;

-- C5: Selecionar o nome e artista principal das músicas com o maior número bruto de tags classificadas.
-- Retorno: | Nome da Música | Nome do Autor | Número de tags classificadas |
\echo 'Consulta 5: Selecionar o nome e o artista principal das músicas com o maior número bruto de tags classificadas'

SELECT M.NOME_MUSICA, AR.NOME_ARTISTA, COUNT(CP.TAG) AS CONTAGEM
    FROM MUSICA M 
    NATURAL JOIN CLASSIFICA_POR CP
    JOIN ALBUM AL ON (M.ALBUM = AL.ID_ALBUM)
    JOIN ARTISTA AR ON (AL.ARTISTA = AR.NOME_ARTISTA)
    GROUP BY M.NOME_MUSICA, AR.NOME_ARTISTA
    ORDER BY (CONTAGEM) DESC;

