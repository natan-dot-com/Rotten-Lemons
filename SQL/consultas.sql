-- C1: Consultar a quantidade de estrelas (1,2,3,4,5) para cada música de um artista 
-- Separar contagem para criticos para usuarios comuns.
-- Retorno: | Musica | Tipo de usuario | Contagem | Quantidade de estrelas |

-- C2: Visualizar todos os comentários feitos por críticos. 
-- Retorno: | Usuario | Conteúdo do Comentário | Tipo do Comentário |

-- C3: Consulta todos os comentários sobre artistas feito por críticos
SELECT CCAA.NOME_USUARIO, CCAA.CONTEUDO, CCAA.ARTISTA_COMENTARIO AS ARTISTA  FROM 
((SELECT U.NOME_USUARIO, U.EH_CRITICO, C.CONTEUDO, C.TIPO, C.ID_COMENTARIO
FROM (SELECT * FROM USUARIO WHERE EH_CRITICO = TRUE) U
JOIN (SELECT * FROM COMENTARIO WHERE TIPO = 'Artista') C 
ON C.NOME_USUARIO = U.NOME_USUARIO) CCA 
JOIN COMENTARIO_ARTISTA CA ON CA.ID_COMENTARIO = CCA.ID_COMENTARIO) CCAA;

-- C3: Consulta todos os comentários sobre músicas feito por críticos
-- Faz join USUARIO(filtrando os criticos) com COMENTARIO (filtrando os referentes a musicas)
-- Com o resultado faz join com COMENTARIO_MUSICA
-- Em seguida faz join com MUSICA
-- Por fim com ALBUM.
SELECT _CCMNA.AUTOR, _CCMNA.CONTEUDO, _CCMNA.NOME_MUSICA, _CCMNA.NOME_ALBUM, _CCMNA.ARTISTA FROM
    ((SELECT _CCMN.AUTOR, _CCMN.CONTEUDO, _CCMN.NOME_MUSICA, _CCMN.ALBUM  FROM
        ((SELECT _CCM.AUTOR, _CCM.CONTEUDO, _CCM.ID_MUSICA  FROM
            (   (SELECT _CC.AUTOR, _CC.CONTEUDO, _CC.ID_COMENTARIO AS ID_COM  FROM
                (   (SELECT U.NOME_USUARIO FROM USUARIO U WHERE U.EH_CRITICO = TRUE) U
                    JOIN 
                    (SELECT C.CONTEUDO, C.ID_COMENTARIO, C.NOME_USUARIO AS AUTOR FROM COMENTARIO C WHERE C.TIPO = 'Musica') C
                    ON C.AUTOR = U.NOME_USUARIO 
                ) _CC ) CC -- Comentario de Criticos
                JOIN 
                COMENTARIO_MUSICA CM 
                ON CM.ID_COMENTARIO = CC.ID_COM
            ) _CCM ) CCM -- Comentario de um Critico em uma Musica
        JOIN 
        MUSICA M
        ON M.ID_MUSICA = CCM.ID_MUSICA ) _CCMN ) CCMN -- Comentario de um Critico em uma musica com nome
    JOIN
    ALBUM A 
    ON A.ID_ALBUM = CCMN.ALBUM ) _CCMNA; -- Comentario de um Critico em uma música com nome e album

-- C4: Visualizar as notas médias dos artistas (sendo eles as notas médias dos álbuns,
-- que por consequência são as notas das músicas do álbum).
-- Retorno: | Nome do Artista | Nota Média do Artista |
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

-- C5: 
