-- C1: Consultar a quantidade de estrelas (1,2,3,4,5) para cada música de um artista 
-- Separar contagem para criticos para usuarios comuns.
-- Retorno: | Musica | Tipo de usuario | Contagem | Quantidade de estrelas |
-- Uso de GROUP BY

-- C2: Visualizar todos os comentários feitos por críticos. 
-- Retorno: | Usuario | Conteúdo do Comentário | Tipo do Comentário |

-- C3: Visualizar as notas médias dos artistas (sendo eles as notas médias dos álbuns,
-- que por consequência são as notas das músicas do álbum).
-- Retorno: | Nome do Artista | Nota Média do Artista |
SELECT AR.NOME_ARTISTA, ROUND(AVG(NOTA_ALBUM), 2) AS NOTA_ARTISTA
FROM ARTISTA AR, (
    SELECT AL.NOME_ALBUM, AL.ARTISTA, ROUND(AVG(NOTA_MUSICA), 2) AS NOTA_ALBUM
    FROM ALBUM AL, (
        SELECT M.ID_MUSICA, M.ALBUM, ROUND(AVG(A.ESTRELAS), 2) AS NOTA_MUSICA
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

-- C4:
