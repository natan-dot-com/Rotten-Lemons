-- Tabela USUARIO
INSERT INTO USUARIO VALUES ('NatanSanches', false, 'natansanches@rottenlemons.com',
    TO_DATE('18-01-2001', 'DD-MM-YYYY'), 'A');
INSERT INTO USUARIO VALUES ('AlvaroLopes', false, 'alvarolopes@rottenlemons.com',
    TO_DATE('18-03-2000', 'DD-MM-YYYY'), 'A');
INSERT INTO USUARIO VALUES ('PauloSoares', true, 'psoares@rottenlemons.com',
    TO_DATE('23-05-1998', 'DD-MM-YYYY'), 'M');
INSERT INTO USUARIO VALUES ('GabrielDetoni', true, 'detoni@rottenlemons.com',
    TO_DATE('09-05-2001', 'DD-MM-YYYY'), 'M');
INSERT INTO USUARIO VALUES ('OsniBrito', false, 'brito56@gmail.com',
    TO_DATE('21-07-2000', 'DD-MM-YYYY'), 'U');
INSERT INTO USUARIO VALUES ('AndreMoreira', false, 'andre@outlook.com',
    TO_DATE('26-10-1996', 'DD-MM-YYYY'), 'U');
INSERT INTO USUARIO VALUES ('ElaineParros', true, 'elaine@outlook.com',
    TO_DATE('22-12-1981', 'DD-MM-YYYY'), 'U');
INSERT INTO USUARIO VALUES ('PedroAugusto', false, 'pedroaugusto@gmail.com',
    TO_DATE('26-08-2000', 'DD-MM-YYYY'), 'U');

-- Tabela TAG
INSERT INTO TAG VALUES ('Feliz');
INSERT INTO TAG VALUES ('Triste');
INSERT INTO TAG VALUES ('Pensativo');
INSERT INTO TAG VALUES ('Curioso');
INSERT INTO TAG VALUES ('Raiva');

-- Tabela ARTISTA
INSERT INTO ARTISTA VALUES ('Nightwish', 'Power metal');
INSERT INTO ARTISTA VALUES ('La Femme', 'Punk rock');
INSERT INTO ARTISTA VALUES ('Ednaldo Pereira', 'Pagode');
INSERT INTO ARTISTA VALUES ('Akon', 'Club');
INSERT INTO ARTISTA VALUES ('Arianne', 'Contemporary');
INSERT INTO ARTISTA VALUES ('Megumi H.', 'Contemporary');
INSERT INTO ARTISTA VALUES ('Pink Floyd', 'Rock');


-- Tabela SEGUE
INSERT INTO SEGUE VALUES ('NatanSanches', 'AlvaroLopes');
INSERT INTO SEGUE VALUES ('NatanSanches', 'PauloSoares');
INSERT INTO SEGUE VALUES ('NatanSanches', 'ElaineParros');
INSERT INTO SEGUE VALUES ('AlvaroLopes', 'GabrielDetoni');
INSERT INTO SEGUE VALUES ('GabrielDetoni', 'OsniBrito');
INSERT INTO SEGUE VALUES ('GabrielDetoni', 'ElaineParros');
INSERT INTO SEGUE VALUES ('AlvaroLopes', 'NatanSanches');
INSERT INTO SEGUE VALUES ('AndreMoreira', 'OsniBrito');

-- Tabela ALBUM
INSERT INTO ALBUM (NOME_ALBUM, ARTISTA) VALUES ('Imaginaerum', 'Nightwish');
INSERT INTO ALBUM (NOME_ALBUM, ARTISTA) VALUES ('Century Child', 'Nightwish');
INSERT INTO ALBUM (NOME_ALBUM, ARTISTA) VALUES ('Chance', 'Ednaldo Pereira');
INSERT INTO ALBUM (NOME_ALBUM, ARTISTA) VALUES ('Invencao', 'Ednaldo Pereira');
INSERT INTO ALBUM (NOME_ALBUM, ARTISTA) VALUES ('Psycho Tropical Berlin', 'La Femme');
INSERT INTO ALBUM (NOME_ALBUM, ARTISTA) VALUES ('Mystere', 'La Femme');
INSERT INTO ALBUM (NOME_ALBUM, ARTISTA) VALUES ('Konvicted', 'Akon');
INSERT INTO ALBUM (NOME_ALBUM, ARTISTA) VALUES ('Freedom', 'Akon');
INSERT INTO ALBUM (NOME_ALBUM, ARTISTA) VALUES ('Evangelion Family', 'Megumi H.');
INSERT INTO ALBUM (NOME_ALBUM, ARTISTA) VALUES ('The Wall', 'Pink Floyd');

-- Tabela PARTICIPA_ALBUM
INSERT INTO PARTICIPA_ALBUM VALUES (3, 'Nightwish');
INSERT INTO PARTICIPA_ALBUM VALUES (7, 'Ednaldo Pereira');
INSERT INTO PARTICIPA_ALBUM VALUES (1, 'La Femme');
INSERT INTO PARTICIPA_ALBUM VALUES (4, 'Akon');
INSERT INTO PARTICIPA_ALBUM VALUES (9, 'Arianne');

-- Tabela MUSICA
INSERT INTO MUSICA (NOME_MUSICA, ALBUM, DURACAO) VALUES ('The End of All Hope', 2, 234);
INSERT INTO MUSICA (NOME_MUSICA, ALBUM, DURACAO) VALUES ('Imaginaerum', 1, 304);
INSERT INTO MUSICA (NOME_MUSICA, ALBUM, DURACAO) VALUES ('Ou va le monde', 6, 289);
INSERT INTO MUSICA (NOME_MUSICA, ALBUM, DURACAO) VALUES ('Sur la planche 2013', 5, 324);
INSERT INTO MUSICA (NOME_MUSICA, ALBUM, DURACAO) VALUES ('Antitaxi', 5, 189);
INSERT INTO MUSICA (NOME_MUSICA, ALBUM, DURACAO) VALUES ('Vale Nada Vale Tudo', 3, 274);
INSERT INTO MUSICA (NOME_MUSICA, ALBUM, DURACAO) VALUES ('God is Good', 3, 267);
INSERT INTO MUSICA (NOME_MUSICA, ALBUM, DURACAO) VALUES ('Lonely', 7, 235);
INSERT INTO MUSICA (NOME_MUSICA, ALBUM, DURACAO) VALUES ('Dont Matter', 7, 293);
INSERT INTO MUSICA (NOME_MUSICA, ALBUM, DURACAO) VALUES ('Right Now', 8, 304);
INSERT INTO MUSICA (NOME_MUSICA, ALBUM, DURACAO) VALUES ('Komm, Susser Tod', 9, 392);
INSERT INTO MUSICA (NOME_MUSICA, ALBUM, DURACAO) VALUES ('What is the brother', 3, 213);
INSERT INTO MUSICA (NOME_MUSICA, ALBUM, DURACAO) VALUES ('TSUBASA WO KUDASAI', 9, 287);
INSERT INTO MUSICA (NOME_MUSICA, ALBUM, DURACAO) VALUES ('The Cruel Angels Thesis', 9, 203);
INSERT INTO MUSICA (NOME_MUSICA, ALBUM, DURACAO) VALUES ('FLY ME TO THE MOON', 9, 244);
INSERT INTO MUSICA (NOME_MUSICA, ALBUM, DURACAO) VALUES ('Smack That', 7, 247);
INSERT INTO MUSICA (NOME_MUSICA, ALBUM, DURACAO) VALUES ('I Wanna Love You', 7, 301);
INSERT INTO MUSICA (NOME_MUSICA, ALBUM, DURACAO) VALUES ('Mama Africa', 7, 312);
INSERT INTO MUSICA (NOME_MUSICA, ALBUM, DURACAO) VALUES ('The Rain', 7, 298);
INSERT INTO MUSICA (NOME_MUSICA, ALBUM, DURACAO) VALUES ('Troublemaker', 8, 267);
INSERT INTO MUSICA (NOME_MUSICA, ALBUM, DURACAO) VALUES ('Sunny Day', 8, 207);
INSERT INTO MUSICA (NOME_MUSICA, ALBUM, DURACAO) VALUES ('Freedom', 8, 309);
INSERT INTO MUSICA (NOME_MUSICA, ALBUM, DURACAO) VALUES ('Packshot', 5, 222);
INSERT INTO MUSICA (NOME_MUSICA, ALBUM, DURACAO) VALUES ('Amour dans le motu', 5, 252);
INSERT INTO MUSICA (NOME_MUSICA, ALBUM, DURACAO) VALUES ('Its Time To Wake Up 2023', 5, 275);
INSERT INTO MUSICA (NOME_MUSICA, ALBUM, DURACAO) VALUES ('Song of Myself', 1, 724);
INSERT INTO MUSICA (NOME_MUSICA, ALBUM, DURACAO) VALUES ('Last Ride of The Day', 1, 337);
INSERT INTO MUSICA (NOME_MUSICA, ALBUM, DURACAO) VALUES ('Storytime', 1, 278);
INSERT INTO MUSICA (NOME_MUSICA, ALBUM, DURACAO) VALUES ('Arabesque', 1, 194);
INSERT INTO MUSICA (NOME_MUSICA, ALBUM, DURACAO) VALUES ('I Want My Tears Back', 1, 324);
INSERT INTO MUSICA (NOME_MUSICA, ALBUM, DURACAO) VALUES ('Who is the Sister', 3, 211);
INSERT INTO MUSICA (NOME_MUSICA, ALBUM, DURACAO) VALUES ('Se', 3, 142);
INSERT INTO MUSICA (NOME_MUSICA, ALBUM, DURACAO) VALUES ('Importancia', 3, 244);
INSERT INTO MUSICA (NOME_MUSICA, ALBUM, DURACAO) VALUES ('Fleig', 4, 233);
INSERT INTO MUSICA (NOME_MUSICA, ALBUM, DURACAO) VALUES ('Banido Desbanido', 4, 212);
INSERT INTO MUSICA (NOME_MUSICA, ALBUM, DURACAO) VALUES ('Invencao', 4, 194);
INSERT INTO MUSICA (NOME_MUSICA, ALBUM, DURACAO) VALUES ('In The Flash?', 10, 242);
INSERT INTO MUSICA (NOME_MUSICA, ALBUM, DURACAO) VALUES ('Comfortably Numb', 10, 352);
INSERT INTO MUSICA (NOME_MUSICA, ALBUM, DURACAO) VALUES ('Mother', 10, 172);
INSERT INTO MUSICA (NOME_MUSICA, ALBUM, DURACAO) VALUES ('Another Brick in the Wall, Part 1', 10, 341);
INSERT INTO MUSICA (NOME_MUSICA, ALBUM, DURACAO) VALUES ('Another Brick in the Wall, Part 2', 10, 277);
INSERT INTO MUSICA (NOME_MUSICA, ALBUM, DURACAO) VALUES ('Young Lust', 10, 382);
INSERT INTO MUSICA (NOME_MUSICA, ALBUM, DURACAO) VALUES ('Hey You', 10, 199);

-- Tabela AVALIA
INSERT INTO AVALIA VALUES ('NatanSanches', 3, 5);
INSERT INTO AVALIA VALUES ('GabrielDetoni', 6, 5);
INSERT INTO AVALIA VALUES ('NatanSanches', 1, 4);
INSERT INTO AVALIA VALUES ('PauloSoares', 10, 2);
INSERT INTO AVALIA VALUES ('OsniBrito', 10, 5);
INSERT INTO AVALIA VALUES ('AlvaroLopes', 6, 5);
INSERT INTO AVALIA VALUES ('GabrielDetoni', 7, 5);
INSERT INTO AVALIA VALUES ('NatanSanches', 6, 4);
INSERT INTO AVALIA VALUES ('AndreMoreira', 8, 1);
INSERT INTO AVALIA VALUES ('AndreMoreira', 3, 2);
INSERT INTO AVALIA VALUES ('PauloSoares', 2, 5);
INSERT INTO AVALIA VALUES ('NatanSanches', 11, 5);
INSERT INTO AVALIA VALUES ('PedroAugusto', 24, 3);
INSERT INTO AVALIA VALUES ('AlvaroLopes', 4, 5);
INSERT INTO AVALIA VALUES ('GabrielDetoni', 42, 3);
INSERT INTO AVALIA VALUES ('AlvaroLopes', 25, 5);
INSERT INTO AVALIA VALUES ('OsniBrito', 7, 4);
INSERT INTO AVALIA VALUES ('PedroAugusto', 26, 4);
INSERT INTO AVALIA VALUES ('OsniBrito', 38, 5);
INSERT INTO AVALIA VALUES ('ElaineParros', 36, 5);
INSERT INTO AVALIA VALUES ('AndreMoreira', 22, 4);
INSERT INTO AVALIA VALUES ('NatanSanches', 13, 3);
INSERT INTO AVALIA VALUES ('PauloSoares', 18, 3);
INSERT INTO AVALIA VALUES ('GabrielDetoni', 27, 1);
INSERT INTO AVALIA VALUES ('PauloSoares', 12, 2);
INSERT INTO AVALIA VALUES ('AlvaroLopes', 29, 4);
INSERT INTO AVALIA VALUES ('AndreMoreira', 21, 4);
INSERT INTO AVALIA VALUES ('AndreMoreira', 26, 2);
INSERT INTO AVALIA VALUES ('ElaineParros', 35, 5);
INSERT INTO AVALIA VALUES ('GabrielDetoni', 38, 1);
INSERT INTO AVALIA VALUES ('AlvaroLopes', 8, 5);
INSERT INTO AVALIA VALUES ('ElaineParros', 20, 1);
INSERT INTO AVALIA VALUES ('ElaineParros', 28, 4);
INSERT INTO AVALIA VALUES ('AlvaroLopes', 11, 3);
INSERT INTO AVALIA VALUES ('NatanSanches', 21, 3);
INSERT INTO AVALIA VALUES ('PauloSoares', 35, 1);
INSERT INTO AVALIA VALUES ('NatanSanches', 15, 2);
INSERT INTO AVALIA VALUES ('GabrielDetoni', 19, 5);
INSERT INTO AVALIA VALUES ('NatanSanches', 12, 3);
INSERT INTO AVALIA VALUES ('NatanSanches', 22, 1);
INSERT INTO AVALIA VALUES ('OsniBrito', 30, 4);
INSERT INTO AVALIA VALUES ('AndreMoreira', 2, 1);
INSERT INTO AVALIA VALUES ('AndreMoreira', 16, 1);
INSERT INTO AVALIA VALUES ('AlvaroLopes', 9, 2);
INSERT INTO AVALIA VALUES ('PedroAugusto', 22, 3);
INSERT INTO AVALIA VALUES ('AlvaroLopes', 20, 3);
INSERT INTO AVALIA VALUES ('OsniBrito', 37, 3);
INSERT INTO AVALIA VALUES ('PauloSoares', 23, 1);
INSERT INTO AVALIA VALUES ('AlvaroLopes', 26, 5);
INSERT INTO AVALIA VALUES ('AlvaroLopes', 31, 4);
INSERT INTO AVALIA VALUES ('ElaineParros', 25, 1);
INSERT INTO AVALIA VALUES ('ElaineParros', 39, 1);
INSERT INTO AVALIA VALUES ('OsniBrito', 22, 4);
INSERT INTO AVALIA VALUES ('PedroAugusto', 25, 2);
INSERT INTO AVALIA VALUES ('GabrielDetoni', 31, 5);
INSERT INTO AVALIA VALUES ('GabrielDetoni', 14, 1);
INSERT INTO AVALIA VALUES ('PedroAugusto', 42, 3);
INSERT INTO AVALIA VALUES ('AlvaroLopes', 34, 4);
INSERT INTO AVALIA VALUES ('GabrielDetoni', 24, 3);
INSERT INTO AVALIA VALUES ('AlvaroLopes', 12, 2);
INSERT INTO AVALIA VALUES ('ElaineParros', 15, 5);
INSERT INTO AVALIA VALUES ('ElaineParros', 40, 4);
INSERT INTO AVALIA VALUES ('GabrielDetoni', 9, 2);
INSERT INTO AVALIA VALUES ('OsniBrito', 42, 5);
INSERT INTO AVALIA VALUES ('NatanSanches', 30, 3);
INSERT INTO AVALIA VALUES ('PedroAugusto', 43, 3);
INSERT INTO AVALIA VALUES ('PauloSoares', 3, 2);
INSERT INTO AVALIA VALUES ('NatanSanches', 16, 4);
INSERT INTO AVALIA VALUES ('ElaineParros', 14, 2);
INSERT INTO AVALIA VALUES ('OsniBrito', 1, 4);
INSERT INTO AVALIA VALUES ('NatanSanches', 23, 4);
INSERT INTO AVALIA VALUES ('ElaineParros', 33, 5);
INSERT INTO AVALIA VALUES ('NatanSanches', 40, 4);
INSERT INTO AVALIA VALUES ('OsniBrito', 31, 1);
INSERT INTO AVALIA VALUES ('NatanSanches', 31, 4);
INSERT INTO AVALIA VALUES ('OsniBrito', 24, 5);
INSERT INTO AVALIA VALUES ('GabrielDetoni', 34, 3);
INSERT INTO AVALIA VALUES ('NatanSanches', 29, 3);
INSERT INTO AVALIA VALUES ('ElaineParros', 24, 4);
INSERT INTO AVALIA VALUES ('PedroAugusto', 21, 2);
INSERT INTO AVALIA VALUES ('ElaineParros', 7, 3);
INSERT INTO AVALIA VALUES ('AndreMoreira', 37, 4);
INSERT INTO AVALIA VALUES ('OsniBrito', 34, 2);
INSERT INTO AVALIA VALUES ('OsniBrito', 12, 5);
INSERT INTO AVALIA VALUES ('GabrielDetoni', 16, 2);
INSERT INTO AVALIA VALUES ('NatanSanches', 37, 2);
INSERT INTO AVALIA VALUES ('NatanSanches', 4, 2);
INSERT INTO AVALIA VALUES ('PedroAugusto', 11, 3);
INSERT INTO AVALIA VALUES ('NatanSanches', 14, 1);
INSERT INTO AVALIA VALUES ('NatanSanches', 7, 5);
INSERT INTO AVALIA VALUES ('AlvaroLopes', 5, 5);
INSERT INTO AVALIA VALUES ('ElaineParros', 32, 1);
INSERT INTO AVALIA VALUES ('PauloSoares', 33, 3);
INSERT INTO AVALIA VALUES ('PedroAugusto', 4, 1);
INSERT INTO AVALIA VALUES ('PauloSoares', 29, 1);
INSERT INTO AVALIA VALUES ('AlvaroLopes', 10, 5);
INSERT INTO AVALIA VALUES ('GabrielDetoni', 2, 1);
INSERT INTO AVALIA VALUES ('OsniBrito', 2, 4);
INSERT INTO AVALIA VALUES ('AndreMoreira', 7, 5);
INSERT INTO AVALIA VALUES ('PedroAugusto', 1, 4);
INSERT INTO AVALIA VALUES ('GabrielDetoni', 10, 4);
INSERT INTO AVALIA VALUES ('AndreMoreira', 38, 3);
INSERT INTO AVALIA VALUES ('PedroAugusto', 17, 5);
INSERT INTO AVALIA VALUES ('AndreMoreira', 17, 5);
INSERT INTO AVALIA VALUES ('AlvaroLopes', 2, 5);
INSERT INTO AVALIA VALUES ('AlvaroLopes', 1, 2);

-- Tabela PLAYLIST
INSERT INTO PLAYLIST (DATA_CRIACAO, TAG_PLAYLIST) 
    VALUES (CURRENT_DATE, 'Feliz');
INSERT INTO PLAYLIST (DATA_CRIACAO, TAG_PLAYLIST) 
    VALUES (TO_DATE('19-03-2019', 'DD-MM-YYYY'),'Curioso');

-- Tabela PLAYLIST_CONTEM
INSERT INTO PLAYLIST_CONTEM VALUES (6, 1);
INSERT INTO PLAYLIST_CONTEM VALUES (7, 1);
INSERT INTO PLAYLIST_CONTEM VALUES (1, 1);
INSERT INTO PLAYLIST_CONTEM VALUES (2, 2);
INSERT INTO PLAYLIST_CONTEM VALUES (5, 2);
INSERT INTO PLAYLIST_CONTEM VALUES (9, 2);
INSERT INTO PLAYLIST_CONTEM VALUES (10, 2);
INSERT INTO PLAYLIST_CONTEM VALUES (30, 2);
INSERT INTO PLAYLIST_CONTEM VALUES (4, 1);
INSERT INTO PLAYLIST_CONTEM VALUES (31, 1);
INSERT INTO PLAYLIST_CONTEM VALUES (22, 2);
INSERT INTO PLAYLIST_CONTEM VALUES (12, 1);
INSERT INTO PLAYLIST_CONTEM VALUES (19, 1);
INSERT INTO PLAYLIST_CONTEM VALUES (5, 1);
INSERT INTO PLAYLIST_CONTEM VALUES (41, 2);
INSERT INTO PLAYLIST_CONTEM VALUES (37, 2);
INSERT INTO PLAYLIST_CONTEM VALUES (14, 2);
INSERT INTO PLAYLIST_CONTEM VALUES (24, 1);
INSERT INTO PLAYLIST_CONTEM VALUES (39, 1);
INSERT INTO PLAYLIST_CONTEM VALUES (20, 2);
INSERT INTO PLAYLIST_CONTEM VALUES (8, 1);

--Tabela CURTE
INSERT INTO CURTE VALUES ('NatanSanches', 1);
INSERT INTO CURTE VALUES ('AlvaroLopes', 1);
INSERT INTO CURTE VALUES ('AndreMoreira', 2);
INSERT INTO CURTE VALUES ('GabrielDetoni', 1);
INSERT INTO CURTE VALUES ('NatanSanches', 2);
INSERT INTO CURTE VALUES ('ElaineParros', 2);

-- Tabela CLASSIFICA_POR
INSERT INTO CLASSIFICA_POR VALUES (3, 'Feliz', 'NatanSanches');
INSERT INTO CLASSIFICA_POR VALUES (1, 'Feliz', 'PauloSoares');
INSERT INTO CLASSIFICA_POR VALUES (6, 'Feliz', 'GabrielDetoni');
INSERT INTO CLASSIFICA_POR VALUES (5, 'Curioso', 'NatanSanches');
INSERT INTO CLASSIFICA_POR VALUES (6, 'Pensativo', 'OsniBrito');
INSERT INTO CLASSIFICA_POR VALUES (1, 'Triste', 'AndreMoreira');
INSERT INTO CLASSIFICA_POR VALUES (2, 'Feliz', 'PauloSoares');
INSERT INTO CLASSIFICA_POR VALUES (2, 'Pensativo', 'NatanSanches');
INSERT INTO CLASSIFICA_POR VALUES (10, 'Feliz', 'OsniBrito');
INSERT INTO CLASSIFICA_POR VALUES (7, 'Pensativo', 'AlvaroLopes');
INSERT INTO CLASSIFICA_POR VALUES (9, 'Triste', 'OsniBrito');
INSERT INTO CLASSIFICA_POR VALUES (40, 'Feliz', 'ElaineParros');
INSERT INTO CLASSIFICA_POR VALUES (6, 'Curioso', 'PedroAugusto');
INSERT INTO CLASSIFICA_POR VALUES (13, 'Pensativo', 'PedroAugusto');
INSERT INTO CLASSIFICA_POR VALUES (40, 'Raiva', 'PauloSoares');
INSERT INTO CLASSIFICA_POR VALUES (40, 'Pensativo', 'PauloSoares');
INSERT INTO CLASSIFICA_POR VALUES (29, 'Triste', 'PedroAugusto');
INSERT INTO CLASSIFICA_POR VALUES (31, 'Triste', 'ElaineParros');
INSERT INTO CLASSIFICA_POR VALUES (21, 'Feliz', 'NatanSanches');
INSERT INTO CLASSIFICA_POR VALUES (10, 'Raiva', 'PauloSoares');
INSERT INTO CLASSIFICA_POR VALUES (32, 'Triste', 'PauloSoares');
INSERT INTO CLASSIFICA_POR VALUES (32, 'Raiva', 'ElaineParros');
INSERT INTO CLASSIFICA_POR VALUES (17, 'Feliz', 'GabrielDetoni');
INSERT INTO CLASSIFICA_POR VALUES (11, 'Raiva', 'PedroAugusto');
INSERT INTO CLASSIFICA_POR VALUES (38, 'Raiva', 'PedroAugusto');
INSERT INTO CLASSIFICA_POR VALUES (37, 'Raiva', 'PauloSoares');
INSERT INTO CLASSIFICA_POR VALUES (40, 'Curioso', 'AlvaroLopes');
INSERT INTO CLASSIFICA_POR VALUES (30, 'Pensativo', 'OsniBrito');
INSERT INTO CLASSIFICA_POR VALUES (9, 'Triste', 'AlvaroLopes');
INSERT INTO CLASSIFICA_POR VALUES (28, 'Feliz', 'NatanSanches');
INSERT INTO CLASSIFICA_POR VALUES (10, 'Raiva', 'ElaineParros');
INSERT INTO CLASSIFICA_POR VALUES (33, 'Pensativo', 'PauloSoares');
INSERT INTO CLASSIFICA_POR VALUES (21, 'Raiva', 'AlvaroLopes');
INSERT INTO CLASSIFICA_POR VALUES (13, 'Triste', 'GabrielDetoni');
INSERT INTO CLASSIFICA_POR VALUES (31, 'Triste', 'PedroAugusto');
INSERT INTO CLASSIFICA_POR VALUES (42, 'Curioso', 'OsniBrito');
INSERT INTO CLASSIFICA_POR VALUES (31, 'Curioso', 'PedroAugusto');
INSERT INTO CLASSIFICA_POR VALUES (37, 'Curioso', 'AndreMoreira');
INSERT INTO CLASSIFICA_POR VALUES (30, 'Triste', 'AlvaroLopes');
INSERT INTO CLASSIFICA_POR VALUES (36, 'Triste', 'OsniBrito');
INSERT INTO CLASSIFICA_POR VALUES (33, 'Raiva', 'AlvaroLopes');
INSERT INTO CLASSIFICA_POR VALUES (36, 'Triste', 'PedroAugusto');
INSERT INTO CLASSIFICA_POR VALUES (7, 'Raiva', 'PauloSoares');
INSERT INTO CLASSIFICA_POR VALUES (3, 'Raiva', 'AlvaroLopes');
INSERT INTO CLASSIFICA_POR VALUES (36, 'Curioso', 'AndreMoreira');
INSERT INTO CLASSIFICA_POR VALUES (35, 'Curioso', 'PauloSoares');
INSERT INTO CLASSIFICA_POR VALUES (6, 'Raiva', 'NatanSanches');
INSERT INTO CLASSIFICA_POR VALUES (8, 'Curioso', 'ElaineParros');
INSERT INTO CLASSIFICA_POR VALUES (5, 'Curioso', 'GabrielDetoni');
INSERT INTO CLASSIFICA_POR VALUES (8, 'Pensativo', 'NatanSanches');
INSERT INTO CLASSIFICA_POR VALUES (28, 'Feliz', 'PauloSoares');
INSERT INTO CLASSIFICA_POR VALUES (2, 'Curioso', 'AndreMoreira');
INSERT INTO CLASSIFICA_POR VALUES (15, 'Curioso', 'PauloSoares');
INSERT INTO CLASSIFICA_POR VALUES (1, 'Curioso', 'PedroAugusto');
INSERT INTO CLASSIFICA_POR VALUES (37, 'Feliz', 'ElaineParros');
INSERT INTO CLASSIFICA_POR VALUES (15, 'Raiva', 'NatanSanches');
INSERT INTO CLASSIFICA_POR VALUES (10, 'Triste', 'ElaineParros');
INSERT INTO CLASSIFICA_POR VALUES (30, 'Feliz', 'NatanSanches');
INSERT INTO CLASSIFICA_POR VALUES (31, 'Curioso', 'GabrielDetoni');
INSERT INTO CLASSIFICA_POR VALUES (19, 'Raiva', 'AndreMoreira');
INSERT INTO CLASSIFICA_POR VALUES (37, 'Feliz', 'PedroAugusto');
INSERT INTO CLASSIFICA_POR VALUES (39, 'Pensativo', 'AndreMoreira');
INSERT INTO CLASSIFICA_POR VALUES (33, 'Pensativo', 'OsniBrito');
INSERT INTO CLASSIFICA_POR VALUES (23, 'Raiva', 'PauloSoares');
INSERT INTO CLASSIFICA_POR VALUES (20, 'Raiva', 'PauloSoares');
INSERT INTO CLASSIFICA_POR VALUES (22, 'Triste', 'PedroAugusto');
INSERT INTO CLASSIFICA_POR VALUES (24, 'Pensativo', 'PedroAugusto');
INSERT INTO CLASSIFICA_POR VALUES (28, 'Pensativo', 'PauloSoares');
INSERT INTO CLASSIFICA_POR VALUES (34, 'Triste', 'PauloSoares');
INSERT INTO CLASSIFICA_POR VALUES (38, 'Raiva', 'GabrielDetoni');
INSERT INTO CLASSIFICA_POR VALUES (27, 'Pensativo', 'PedroAugusto');
INSERT INTO CLASSIFICA_POR VALUES (14, 'Feliz', 'ElaineParros');
INSERT INTO CLASSIFICA_POR VALUES (33, 'Curioso', 'PauloSoares');
INSERT INTO CLASSIFICA_POR VALUES (33, 'Raiva', 'ElaineParros');
INSERT INTO CLASSIFICA_POR VALUES (20, 'Triste', 'OsniBrito');
INSERT INTO CLASSIFICA_POR VALUES (29, 'Pensativo', 'GabrielDetoni');
INSERT INTO CLASSIFICA_POR VALUES (19, 'Triste', 'PedroAugusto');
INSERT INTO CLASSIFICA_POR VALUES (33, 'Triste', 'PauloSoares');
INSERT INTO CLASSIFICA_POR VALUES (23, 'Triste', 'AndreMoreira');
INSERT INTO CLASSIFICA_POR VALUES (27, 'Triste', 'PauloSoares');
INSERT INTO CLASSIFICA_POR VALUES (16, 'Triste', 'AndreMoreira');
INSERT INTO CLASSIFICA_POR VALUES (22, 'Feliz', 'PauloSoares');
INSERT INTO CLASSIFICA_POR VALUES (14, 'Feliz', 'PedroAugusto');
INSERT INTO CLASSIFICA_POR VALUES (14, 'Triste', 'AndreMoreira');
INSERT INTO CLASSIFICA_POR VALUES (30, 'Raiva', 'PedroAugusto');
INSERT INTO CLASSIFICA_POR VALUES (8, 'Feliz', 'PauloSoares');
INSERT INTO CLASSIFICA_POR VALUES (10, 'Feliz', 'AndreMoreira');
INSERT INTO CLASSIFICA_POR VALUES (21, 'Curioso', 'ElaineParros');
INSERT INTO CLASSIFICA_POR VALUES (21, 'Curioso', 'PauloSoares');
INSERT INTO CLASSIFICA_POR VALUES (10, 'Curioso', 'OsniBrito');
INSERT INTO CLASSIFICA_POR VALUES (12, 'Pensativo', 'AndreMoreira');
INSERT INTO CLASSIFICA_POR VALUES (9, 'Raiva', 'ElaineParros');
INSERT INTO CLASSIFICA_POR VALUES (27, 'Pensativo', 'PauloSoares');
INSERT INTO CLASSIFICA_POR VALUES (7, 'Curioso', 'NatanSanches');
INSERT INTO CLASSIFICA_POR VALUES (17, 'Pensativo', 'PedroAugusto');
INSERT INTO CLASSIFICA_POR VALUES (6, 'Curioso', 'ElaineParros');
INSERT INTO CLASSIFICA_POR VALUES (26, 'Pensativo', 'ElaineParros');
INSERT INTO CLASSIFICA_POR VALUES (30, 'Triste', 'PauloSoares');
INSERT INTO CLASSIFICA_POR VALUES (40, 'Curioso', 'OsniBrito');
INSERT INTO CLASSIFICA_POR VALUES (1, 'Pensativo', 'AndreMoreira');
INSERT INTO CLASSIFICA_POR VALUES (38, 'Curioso', 'PedroAugusto');
INSERT INTO CLASSIFICA_POR VALUES (31, 'Triste', 'NatanSanches');
INSERT INTO CLASSIFICA_POR VALUES (28, 'Triste', 'GabrielDetoni');
INSERT INTO CLASSIFICA_POR VALUES (12, 'Triste', 'OsniBrito');
INSERT INTO CLASSIFICA_POR VALUES (5, 'Pensativo', 'PauloSoares');
INSERT INTO CLASSIFICA_POR VALUES (3, 'Curioso', 'PedroAugusto');
INSERT INTO CLASSIFICA_POR VALUES (36, 'Feliz', 'AndreMoreira');
INSERT INTO CLASSIFICA_POR VALUES (40, 'Triste', 'PedroAugusto');
INSERT INTO CLASSIFICA_POR VALUES (3, 'Raiva', 'OsniBrito');
INSERT INTO CLASSIFICA_POR VALUES (4, 'Pensativo', 'NatanSanches');
INSERT INTO CLASSIFICA_POR VALUES (30, 'Curioso', 'GabrielDetoni');
INSERT INTO CLASSIFICA_POR VALUES (24, 'Curioso', 'ElaineParros');
INSERT INTO CLASSIFICA_POR VALUES (10, 'Pensativo', 'AndreMoreira');
INSERT INTO CLASSIFICA_POR VALUES (27, 'Raiva', 'NatanSanches');
INSERT INTO CLASSIFICA_POR VALUES (29, 'Feliz', 'OsniBrito');
INSERT INTO CLASSIFICA_POR VALUES (10, 'Pensativo', 'ElaineParros');
INSERT INTO CLASSIFICA_POR VALUES (28, 'Raiva', 'OsniBrito');
INSERT INTO CLASSIFICA_POR VALUES (8, 'Feliz', 'AndreMoreira');
INSERT INTO CLASSIFICA_POR VALUES (26, 'Feliz', 'AndreMoreira');
INSERT INTO CLASSIFICA_POR VALUES (14, 'Feliz', 'NatanSanches');
INSERT INTO CLASSIFICA_POR VALUES (27, 'Triste', 'OsniBrito');
INSERT INTO CLASSIFICA_POR VALUES (1, 'Raiva', 'NatanSanches');
INSERT INTO CLASSIFICA_POR VALUES (2, 'Triste', 'OsniBrito');
INSERT INTO CLASSIFICA_POR VALUES (10, 'Feliz', 'GabrielDetoni');
INSERT INTO CLASSIFICA_POR VALUES (11, 'Triste', 'NatanSanches');
INSERT INTO CLASSIFICA_POR VALUES (11, 'Triste', 'OsniBrito');
INSERT INTO CLASSIFICA_POR VALUES (11, 'Triste', 'AndreMoreira');
INSERT INTO CLASSIFICA_POR VALUES (2, 'Curioso', 'PedroAugusto');
INSERT INTO CLASSIFICA_POR VALUES (8, 'Raiva', 'PedroAugusto');
INSERT INTO CLASSIFICA_POR VALUES (6, 'Curioso', 'OsniBrito');
INSERT INTO CLASSIFICA_POR VALUES (37, 'Raiva', 'OsniBrito');
INSERT INTO CLASSIFICA_POR VALUES (35, 'Raiva', 'GabrielDetoni');
INSERT INTO CLASSIFICA_POR VALUES (31, 'Pensativo', 'OsniBrito');
INSERT INTO CLASSIFICA_POR VALUES (31, 'Pensativo', 'PedroAugusto');
INSERT INTO CLASSIFICA_POR VALUES (10, 'Curioso', 'ElaineParros');
INSERT INTO CLASSIFICA_POR VALUES (5, 'Raiva', 'GabrielDetoni');
INSERT INTO CLASSIFICA_POR VALUES (16, 'Raiva', 'PauloSoares');
INSERT INTO CLASSIFICA_POR VALUES (29, 'Triste', 'PauloSoares');

-- Tabelas relacionadas a COMENTARIO
INSERT INTO COMENTARIO (NOME_USUARIO, DATA_PUBL, CONTEUDO, TIPO) 
    VALUES ('NatanSanches', NOW(), 'Musicas inspiradoras.', 'Artista');
INSERT INTO COMENTARIO_ARTISTA VALUES (1, 'Ednaldo Pereira');

INSERT INTO COMENTARIO (NOME_USUARIO, DATA_PUBL, CONTEUDO, TIPO) 
    VALUES ('PauloSoares', NOW(), 'Overrated.', 'Artista');
INSERT INTO COMENTARIO_ARTISTA VALUES (2, 'Akon');
    
INSERT INTO COMENTARIO (NOME_USUARIO, DATA_PUBL, CONTEUDO, TIPO) 
    VALUES ('OsniBrito', NOW(), 'RAPAAAAAZ Muito bom!!!', 'Musica');
INSERT INTO COMENTARIO_MUSICA VALUES (3, 7);

INSERT INTO COMENTARIO (NOME_USUARIO, DATA_PUBL, CONTEUDO, TIPO) 
    VALUES ('GabrielDetoni', NOW(), 'Nao gostei', 'Musica');
INSERT INTO COMENTARIO_MUSICA VALUES (4, 1);

INSERT INTO COMENTARIO (NOME_USUARIO, DATA_PUBL, CONTEUDO, TIPO) 
    VALUES ('NatanSanches', NOW(), 'Um classico', 'Album');
INSERT INTO COMENTARIO_ALBUM VALUES (5, 3);

INSERT INTO COMENTARIO (NOME_USUARIO, DATA_PUBL, CONTEUDO, TIPO) 
    VALUES ('AndreMoreira', NOW(), 'Ouco dia e noite', 'Album');
INSERT INTO COMENTARIO_ALBUM VALUES (6, 1);

-- Tabela COMENTARIO_REMOVIDO
INSERT INTO COMENTARIO_REMOVIDO VALUES (5, 'NatanSanches');
INSERT INTO COMENTARIO_REMOVIDO VALUES (2, 'AlvaroLopes');

-- Tabela TAG_REMOVIDA
INSERT INTO TAG_REMOVIDA VALUES ('Feliz', 'NatanSanches', 1);
INSERT INTO TAG_REMOVIDA VALUES ('Curioso', 'GabrielDetoni', 5);

-- Tabela BANIDO_POR
INSERT INTO BANIDO_POR VALUES ('GabrielDetoni', 'AlvaroLopes', CURRENT_DATE, 'Cara chato');
INSERT INTO BANIDO_POR VALUES ('OsniBrito', 'PauloSoares', CURRENT_DATE, 'Fez comentarios ofensivos');
