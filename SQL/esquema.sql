\i triggers/permissao_ban.sql
\i triggers/album_circular.sql
\i triggers/permissao_remover.sql
\i triggers/bloqueia_banidos.sql
\i triggers/tag_remover_consistente.sql
\i triggers/classifica_por_tag_removida.sql

/*
*   Tabela USUARIO: Armazena os dados relativos aos usuários do sistema,
*     englobando desde usuários comuns, a moderadores e administradores.
*
*   - NOME_USUARIO: Identificador de cada usuário.
*   - EH_CRITICO: Identificador sobre o cargo de 'Crítico' para um usuário.
*   - EMAIL: E-mail vinculado ao usuário.
*   - DATA_NASCIMENTO: Data de nascimento do usuário.
*   - CARGO: [C]omum, [M]oderador ou [A]dministrador.
*/
CREATE TABLE USUARIO (
    NOME_USUARIO    VARCHAR(50),
    EH_CRITICO      BOOLEAN     NOT NULL,
    EMAIL           VARCHAR(70) NOT NULL,
    DATA_NASCIMENTO DATE        NOT NULL,
    CARGO           CHAR(1)     NOT NULL    DEFAULT 'U',

    CONSTRAINT PK_USUARIO PRIMARY KEY (NOME_USUARIO),
    CONSTRAINT UN_USUARIO UNIQUE (EMAIL),
    CONSTRAINT CK_EMAIL_USUARIO CHECK(EMAIL ~ '^\w+@[a-zA-Z_]+?\.[a-zA-Z]{2,3}$'),
    CONSTRAINT CK_CARGO_USUARIO CHECK(UPPER(CARGO) IN ('U', 'M', 'A'))
);

/*
*   Tabela SEGUE: Armazena a relação de usuários que seguem outros usuários.
*     Moderadores e administradores também podem ser seguidores e serem seguidos.
*     Seguidor --(segue)--> Seguido
*
*   - NOME_USUARIO: Caracteriza o seguidor da relação.
*   - NOME_USUARIO_SEGUIDO: Caracteriza o usuário seguido na relação.
*/
CREATE TABLE SEGUE (
    NOME_USUARIO                VARCHAR(50),
    NOME_USUARIO_SEGUIDO        VARCHAR(50),

    CONSTRAINT PK_SEGUE PRIMARY KEY (NOME_USUARIO, NOME_USUARIO_SEGUIDO),
    CONSTRAINT FK1_SEGUE FOREIGN KEY (NOME_USUARIO) REFERENCES 
        USUARIO (NOME_USUARIO) ON DELETE CASCADE,
    CONSTRAINT FK2_SEGUE FOREIGN KEY (NOME_USUARIO_SEGUIDO) REFERENCES 
        USUARIO (NOME_USUARIO) ON DELETE CASCADE,
    CONSTRAINT CK_SEGUE CHECK(UPPER(NOME_USUARIO_SEGUIDO) <> UPPER(NOME_USUARIO))
);

-- Bloqueia a permissão de usuários banidos de seguirem outros usuários.
CREATE TRIGGER BLOQUEIA_BANIDOS_SEGUIR  
    BEFORE INSERT ON SEGUE
    FOR EACH ROW EXECUTE PROCEDURE TRIGGER_BLOQUEIA_BANIDOS();

/*
*   Tabela BANIDO_POR: Armazena o histórico de usuários banidos por um superior.
*     Um usuário comum pode ser banido por um moderador ou administrador, enquanto
*     um moderador pode ser banido apenas por um administrador.
*
*   - USUARIO_BANIDO: Nome do usuário banido. Pode ser usuário comum ou moderador.
*   - MODERADOR: Moderador encarregado de banir o usuário. Pode ser usuário moderador
*       ou administrador.
*   - DATA_BANIMENTO: Data em que ocorreu o banimento.
*   - MOTIVO: Breve descrição que levou ao banimento.
*/
CREATE TABLE BANIDO_POR (
    USUARIO_BANIDO  VARCHAR(50),
    MODERADOR       VARCHAR(50),
    DATA_BANIMENTO  DATE            DEFAULT NOW(),
    MOTIVO          VARCHAR(100),

    CONSTRAINT PK_BANIDOPOR PRIMARY KEY (USUARIO_BANIDO),
    CONSTRAINT FK1_BANIDOPOR FOREIGN KEY (USUARIO_BANIDO) REFERENCES 
        USUARIO (NOME_USUARIO) ON DELETE CASCADE,
    CONSTRAINT FK2_BANIDOPOR FOREIGN KEY (MODERADOR) REFERENCES 
        USUARIO (NOME_USUARIO)
);

-- Configura as permissões de banimento: moderadores podem banir apenas
--   usuários comuns, enquanto moderadores podem banir moderadores e 
--   usuários comuns.
CREATE TRIGGER PERMISSAO_BANIMENTO  
    BEFORE INSERT ON BANIDO_POR
    FOR EACH ROW EXECUTE PROCEDURE TRIGGER_PERMISSAO_BAN();

/*
*   Tabela COMENTARIO: Armazena, de forma genérica, os comentários dos
*     usuários na base de dados. Essa tabela está relacionada com outras
*     três tabelas: COMENTARIO_ARTISTA, COMENTARIO_ALBUM e COMENTARIO_MUSICA,
*     que ligam o registro do comentário diretamente à entidade a que está
*     relacionado.
*
*   - ID_COMENTARIO: Identificador único que descreve cada comentário.
*   - NOME_USUARIO: Usuário autor do comentário.
*   - DATA_PUBL: Data de publicação do comentário.
*   - CONTEUDO: Conteúdo do comentário, escrito pelo autor.
*   - TIPO: A que tipo de entidade o comentário se refere (álbum, música
*       ou artista).
*/
CREATE TABLE COMENTARIO (
    ID_COMENTARIO   INTEGER         GENERATED ALWAYS AS IDENTITY,
    NOME_USUARIO    VARCHAR(50)     NOT NULL,
    DATA_PUBL       TIMESTAMP       NOT NULL                        DEFAULT NOW(),
    CONTEUDO        VARCHAR(300)    NOT NULL,
    TIPO            VARCHAR(7)      NOT NULL,

    -- DETONI: tratar em aplicação a inserção casada de COMENTARIO em suas subtabelas
    CONSTRAINT PK_COMENTARIO PRIMARY KEY (ID_COMENTARIO),
    CONSTRAINT UN_COMENTARIO UNIQUE (NOME_USUARIO, DATA_PUBL),
    CONSTRAINT FK_COMENTARIO FOREIGN KEY (NOME_USUARIO) REFERENCES
        USUARIO (NOME_USUARIO) ON DELETE CASCADE,
    CONSTRAINT CK_COMENTARIO CHECK(UPPER(TIPO) IN ('ARTISTA', 'ALBUM', 'MUSICA'))
);

-- Bloqueia a permissão de usuários banidos cadastrarem comentários.
CREATE TRIGGER BLOQUEIA_BANIDOS_COMENTARIO
    BEFORE INSERT ON COMENTARIO
    FOR EACH ROW EXECUTE PROCEDURE TRIGGER_BLOQUEIA_BANIDOS();

/*
*   Tabela COMENTARIO_REMOVIDO: Armazena o histórico de comentários que foram
*     removidos. Um usuário pode remover seu próprio comentário, enquanto um
*     moderador/administrador pode remover quaisquer comentários.
*
*   - ID_COMENTARIO: Referencia o identificador do comentário removido.
*   - NOME_USUARIO: Usuário autor da remoção do comentário.
*/
CREATE TABLE COMENTARIO_REMOVIDO (
    ID_COMENTARIO      INTEGER,
    NOME_USUARIO       VARCHAR(50),

    CONSTRAINT PK_COMENTARIOREMOVIDO PRIMARY KEY (ID_COMENTARIO),
    CONSTRAINT FK1_COMENTARIOREMOVIDO FOREIGN KEY (ID_COMENTARIO) REFERENCES
        COMENTARIO (ID_COMENTARIO) ON DELETE CASCADE,
    CONSTRAINT FK2_COMENTARIOREMOVIDO FOREIGN KEY (NOME_USUARIO) REFERENCES
        USUARIO (NOME_USUARIO)
);

-- Bloqueia a permissão de usuários banidos de removerem comentários
CREATE TRIGGER BLOQUEIA_BANIDOS_COMENTARIO_REMOVIDO
    BEFORE INSERT ON COMENTARIO_REMOVIDO
    FOR EACH ROW EXECUTE PROCEDURE TRIGGER_BLOQUEIA_BANIDOS();

-- Administra a permissão do usuário que tenta remover um comentário, de
--   acordo com o definido na descrição da tabela.
CREATE TRIGGER PERMISSAO_REMOVER_COMENTARIO
    BEFORE INSERT ON COMENTARIO_REMOVIDO
    FOR EACH ROW EXECUTE PROCEDURE TRIGGER_PERMISSAO_REMOVER_COMENTARIO();

/*
*   Tabela TAG: Tabela que armazena as tags disponíveis para serem
*     classificadoras de músicas.
*/
CREATE TABLE TAG (
    NOME_TAG    VARCHAR(30),

    CONSTRAINT PK_TAG PRIMARY KEY (NOME_TAG)
);

/*
*   - Tabela PLAYLIST: Armazena a relação de cada playlist com a tag
*       que a caracteriza. Playlists são geradas a partir de tags, que
*       possuem músicas classificadas com a tag característica.       
*
*   - ID_PLAYLIST: Identificador único para cada playlist.
*   - DATA_CRIACAO: Data de criação da playlist.
*   - TAG_PLAYLIST: Tag que a deu origem.
*/
CREATE TABLE PLAYLIST (
    ID_PLAYLIST     INTEGER         GENERATED ALWAYS AS IDENTITY,
    DATA_CRIACAO    DATE            NOT NULL                        DEFAULT NOW(),
    TAG_PLAYLIST    VARCHAR(30)     NOT NULL,

    -- DETONI: tratar a nivel de aplicacao para nao deixar gerar playlists vazias
    -- sem nenhuma musica
    CONSTRAINT PK_PLAYLIST PRIMARY KEY (ID_PLAYLIST),
    CONSTRAINT UN_PLAYLIST UNIQUE(DATA_CRIACAO, TAG_PLAYLIST),
    CONSTRAINT FK_PLAYLIST FOREIGN KEY (TAG_PLAYLIST) REFERENCES
        TAG (NOME_TAG)
);

/*
*   Tabela ARTISTA: Armazena os cadastros de cada artista, que estão
*     vinculados com álbuns e músicas.
*
*   - NOME_ARTISTA: Nome cadastrado do artista.
*   - GENERO_MUSICAL: Gênero musical que representa o artista.
*/
CREATE TABLE ARTISTA (
    NOME_ARTISTA    VARCHAR(100)    NOT NULL,
    GENERO_MUSICAL  VARCHAR(30),

    CONSTRAINT PK_ARTISTA PRIMARY KEY (NOME_ARTISTA)
);

/*
*   Tabela COMENTARIO_ARTISTA: Relaciona os comentários destinados a artistas com
*     seu respectivo artista.
*
*   - ID_COMENTARIO: Referencia o identificador do comentário.
*   - ARTISTA_COMENTARIO: Referencia o nome do artista a que o comentário se destina.
*/
CREATE TABLE COMENTARIO_ARTISTA (
    ID_COMENTARIO       INTEGER,
    ARTISTA_COMENTARIO  VARCHAR(100)    NOT NULL,

    CONSTRAINT PK_COMENTARIOARTISTA PRIMARY KEY (ID_COMENTARIO),
    CONSTRAINT FK1_COMENTARIOARTISTA FOREIGN KEY (ID_COMENTARIO) REFERENCES
        COMENTARIO (ID_COMENTARIO) ON DELETE CASCADE,
    CONSTRAINT FK2_COMENTARIOARTISTA FOREIGN KEY (ARTISTA_COMENTARIO) REFERENCES
        ARTISTA (NOME_ARTISTA) ON DELETE CASCADE
);

/*
*   Tabela ALBUM: Armazena registros dos álbuns disponíveis. Deve estar
*     obrigatoriamente associado a um artista existente.
*
*   - ID_ALBUM: Identificador único para cada álbum.
*   - NOME_ALBUM: Nome do álbum.
*   - ARTISTA: Referencia o artista principal de determinado album.
*/
CREATE TABLE ALBUM (
    ID_ALBUM    INTEGER         GENERATED ALWAYS AS IDENTITY,
    NOME_ALBUM  VARCHAR(70)     NOT NULL,
    ARTISTA     VARCHAR(100)    NOT NULL,

    CONSTRAINT PK_ALBUM PRIMARY KEY (ID_ALBUM),
    CONSTRAINT UN_ALBUM UNIQUE(NOME_ALBUM, ARTISTA),
    CONSTRAINT FK_ALBUM FOREIGN KEY (ARTISTA) REFERENCES
        ARTISTA (NOME_ARTISTA) ON DELETE CASCADE
);

/*
*   Tabela PARTICIPA_ALBUM: Permite com que um álbum seja composto de 
*     diversos artistas. Relaciona os diversos artistas participantes
*     aos seus respectivos álbuns.
*
*   - ID_ALBUM: Referencia o identificador do álbum.
*   - PARTICIPANTE: Referencia o artista participante do álbum relacionado.
*/
CREATE TABLE PARTICIPA_ALBUM (
    ID_ALBUM        INTEGER,
    PARTICIPANTE    VARCHAR(100),

    CONSTRAINT PK_PARTICIPAALBUM PRIMARY KEY (ID_ALBUM, PARTICIPANTE),
    CONSTRAINT FK1_PARTICIPAALBUM FOREIGN KEY (ID_ALBUM) REFERENCES
        ALBUM (ID_ALBUM) ON DELETE CASCADE,
    CONSTRAINT FK2_PARTICIPAALBUM FOREIGN KEY (PARTICIPANTE) REFERENCES
        ARTISTA (NOME_ARTISTA)
);

-- Bloqueia a possibilidade de um artista participar de seu próprio álbum.
CREATE TRIGGER ALBUM_CIRCULAR
    BEFORE INSERT ON PARTICIPA_ALBUM
    FOR EACH ROW EXECUTE PROCEDURE TRIGGER_ALBUM_CIRCULAR();

/*
*   Tabela COMENTARIO_ALBUM: Relaciona os comentários destinados a álbuns com
*     seu respectivo álbum.
*
*   - ID_COMENTARIO: Referencia o identificador do comentário.
*   - ID_ALBUM: Referencia o identificador do álbum a que o comentário se destina.
*/
CREATE TABLE COMENTARIO_ALBUM (
    ID_COMENTARIO   INTEGER,
    ID_ALBUM        INTEGER     NOT NULL,

    CONSTRAINT PK_COMENTARIOALBUM PRIMARY KEY (ID_COMENTARIO),
    CONSTRAINT FK1_COMENTARIOALBUM FOREIGN KEY (ID_COMENTARIO) REFERENCES
        COMENTARIO (ID_COMENTARIO) ON DELETE CASCADE,
    CONSTRAINT FK2_COMENTARIOALBUM FOREIGN KEY (ID_ALBUM) REFERENCES
        ALBUM (ID_ALBUM) ON DELETE CASCADE
);

/*
*   Tabela MUSICA: Tabela que armazena os registros das músicas. Cada música
*     deve obrigatoriamente estar relacionada a um álbum já existente.
*
*   - ID_MUSICA: Identificador único de cada música.
*   - NOME_MUSICA: Nome da música.
*   - ALBUM: Referencia o identificador do álbum a que a música está relacionada.
*   - DURACAO: Duração da música, em segundos.
*/
CREATE TABLE MUSICA (
    ID_MUSICA   INTEGER         GENERATED ALWAYS AS IDENTITY,
    NOME_MUSICA VARCHAR(70)     NOT NULL,
    ALBUM       INTEGER         NOT NULL,
    DURACAO     INTEGER,

    CONSTRAINT PK_MUSICA PRIMARY KEY (ID_MUSICA),
    CONSTRAINT FK_MUSICA FOREIGN KEY (ALBUM) REFERENCES
        ALBUM (ID_ALBUM) ON DELETE CASCADE,
    CONSTRAINT CK_MUSICA CHECK(DURACAO > 0)
);

/*
*   Tabela COMENTARIO_MUSICA: Relaciona os comentários destinados a músicas com
*     sua respectiva música.
*
*   - ID_COMENTARIO: Referencia o identificador do comentário.
*   - ID_ALBUM: Referencia o identificador da música a que o comentário se destina.
*/
CREATE TABLE COMENTARIO_MUSICA (
    ID_COMENTARIO   INTEGER,
    ID_MUSICA       INTEGER     NOT NULL,

    CONSTRAINT PK_COMENTARIOMUSICA PRIMARY KEY (ID_COMENTARIO),
    CONSTRAINT FK_COMENTARIOMUSICA FOREIGN KEY (ID_MUSICA) REFERENCES
        MUSICA (ID_MUSICA) ON DELETE CASCADE
);

/*
*   Tabela CLASSIFICA_POR: Relaciona a classificação uma música por meio de
*     uma tag, por parte do usuário. Diversos usuários podem classificar uma
*     música com uma mesma tag. da mesma forma que um mesmo usuário pode clas-
*     sificar diferentes tags em diferentes músicas.
*
*   - ID_MUSICA: Referencia o identificador de música classificada.
*   - TAG: Referencia o nome da tag que está sendo usada para classificação.
*   - NOME_USUARIO: Referencia o nome do usuário que realizou a classificação.
*/
CREATE TABLE CLASSIFICA_POR (
    ID_MUSICA       INTEGER,
    TAG             VARCHAR(30),
    NOME_USUARIO    VARCHAR(50),

    CONSTRAINT PK_CLASSIFICAPOR PRIMARY KEY (ID_MUSICA, TAG, NOME_USUARIO),
    CONSTRAINT FK1_CLASSIFICAPOR FOREIGN KEY (ID_MUSICA) REFERENCES
        MUSICA (ID_MUSICA) ON DELETE CASCADE,
    CONSTRAINT FK2_CLASSIFICAPOR FOREIGN KEY (TAG) REFERENCES
        TAG (NOME_TAG) ON DELETE CASCADE,
    CONSTRAINT FK3_CLASSIFICAPOR FOREIGN KEY (NOME_USUARIO) REFERENCES
        USUARIO (NOME_USUARIO) ON DELETE CASCADE
);

-- Bloqueia usuários banidos de classificarem músicas.
CREATE TRIGGER BLOQUEIA_BANIDOS_CLASSIFICAPOR
    BEFORE INSERT ON CLASSIFICA_POR
    FOR EACH ROW EXECUTE PROCEDURE TRIGGER_BLOQUEIA_BANIDOS();

-- Bloqueia usuários de classificarem músicas por uma tag já removida.
CREATE TRIGGER CLASSIFICA_POR_TAG_REMOVIDA
    BEFORE INSERT ON CLASSIFICA_POR
    FOR EACH ROW EXECUTE PROCEDURE TRIGGER_CLASSIFICA_POR_TAG_REMOVIDA();

/*
*   Tabela TAG_REMOVIDA: Armazena o histórico de tags removidas em músicas
*     pelos moderadores.
*
*   - TAG: Referencia o nome da tag que foi removida.
*   - NOME_USUARIO: Referencia o nome do moderador responsável por remover a tag.
*   - MUSICA: Referencia o nome da música que a tag foi removida.
*/
CREATE TABLE TAG_REMOVIDA (
    TAG             VARCHAR(30),
    NOME_USUARIO    VARCHAR(50)     NOT NULL,
    MUSICA          INTEGER,

    CONSTRAINT PK_TAGREMOVIDA PRIMARY KEY (TAG, MUSICA),
    CONSTRAINT FK1_TAGREMOVIDA FOREIGN KEY (TAG) REFERENCES
        TAG (NOME_TAG) ON DELETE CASCADE,
    CONSTRAINT FK2_TAGREMOVIDA FOREIGN KEY (NOME_USUARIO) 
        REFERENCES USUARIO (NOME_USUARIO) ON DELETE CASCADE, -- rever
    CONSTRAINT FK3_TAGREMOVIDA FOREIGN KEY (MUSICA) REFERENCES
        MUSICA (ID_MUSICA) ON DELETE CASCADE
);

-- Bloqueia usuários moderadores banidos de remover tags.
CREATE TRIGGER BLOQUEIA_BANIDOS_TAGREMOVIDA
    BEFORE INSERT ON TAG_REMOVIDA
    FOR EACH ROW EXECUTE PROCEDURE TRIGGER_BLOQUEIA_BANIDOS();

-- Realiza a remoção de todas as entradas da tabela CLASSIFICA_POR na qual
--   contenha uma classificação daquela tag removida, naquela música.
CREATE TRIGGER TAG_REMOVER_CONSISTENTE
    BEFORE INSERT ON TAG_REMOVIDA
    FOR EACH ROW EXECUTE PROCEDURE TRIGGER_TAG_REMOVER_CONSISTENTE();

-- Confere se o usuário possui permissão de remover uma tag da música.
CREATE TRIGGER TAG_REMOVER_PERMISSAO
    BEFORE INSERT ON TAG_REMOVIDA
    FOR EACH ROW EXECUTE PROCEDURE TRIGGER_TAG_REMOVER_PERMISSAO();

/*
*   Tabela PLAYLIST_CONTEM: Relaciona as músicas que pertencem a determinada
*     playlist.
*
*   - ID_MUSICA: Referencia o identificador da música que está inclusa na playlist.
*   - ID_PLAYLIST: Referencia o identificador da playlist que as músicas são incluídas.
*/
CREATE TABLE PLAYLIST_CONTEM (
    ID_MUSICA       INTEGER,
    ID_PLAYLIST     INTEGER,

    CONSTRAINT PK_PLAYLISTCONTEM PRIMARY KEY (ID_MUSICA, ID_PLAYLIST),
    CONSTRAINT FK1_PLAYLISTCONTEM FOREIGN KEY (ID_MUSICA) REFERENCES
        MUSICA (ID_MUSICA) ON DELETE CASCADE,
    CONSTRAINT FK2_PLAYLISTCONTEM FOREIGN KEY (ID_PLAYLIST) REFERENCES
        PLAYLIST (ID_PLAYLIST) ON DELETE CASCADE
);

/*
*   Tabela CURTE: Registra os usuários que curtiram determinada playlist.
*
*   - NOME_USUARIO: Nome do usuário curtidor.
*   - ID_PLAYLIST: Identificador da playlist curtida.
*/
CREATE TABLE CURTE (
    NOME_USUARIO    VARCHAR(50),
    ID_PLAYLIST     INTEGER,

    CONSTRAINT PK_CURTE PRIMARY KEY (NOME_USUARIO, ID_PLAYLIST),
    CONSTRAINT FK1_CURTE FOREIGN KEY (NOME_USUARIO) REFERENCES
        USUARIO (NOME_USUARIO) ON DELETE CASCADE,
    CONSTRAINT FK2_CURTE FOREIGN KEY (ID_PLAYLIST) REFERENCES
        PLAYLIST (ID_PLAYLIST) ON DELETE CASCADE
);

-- Bloqueia usuários banidos de curtirem playlists.
CREATE TRIGGER BLOQUEIA_BANIDOS_CURTE
    BEFORE INSERT ON CURTE
    FOR EACH ROW EXECUTE PROCEDURE TRIGGER_BLOQUEIA_BANIDOS();

/*
*   Tabela AVALIA: Armazena o histórico de avaliações de cada usuário,
*     relacionando a música avaliada com a quantidade de estrelas dadas
*     na avaliação.
*
*   - NOME_USUARIO: Referencia o usuário avaliador.
*   - ID_MUSICA: Referencia a música avaliada.
*   - ESTRELAS: Quantidade de estrelas dadas na avaliação.
*/
CREATE TABLE AVALIA (
    NOME_USUARIO    VARCHAR(50),
    ID_MUSICA       INTEGER,
    ESTRELAS        INTEGER     NOT NULL,

    CONSTRAINT PK_AVALIA PRIMARY KEY (NOME_USUARIO, ID_MUSICA),
    CONSTRAINT FK1_CURTE FOREIGN KEY (NOME_USUARIO) REFERENCES
        USUARIO (NOME_USUARIO) ON DELETE CASCADE,
    CONSTRAINT FK2_AVALIA FOREIGN KEY (ID_MUSICA) REFERENCES
        MUSICA (ID_MUSICA) ON DELETE CASCADE,
    CONSTRAINT CK_AVALIA CHECK(ESTRELAS >= 0 AND ESTRELAS <= 5)
);

-- Bloqueia usuários banidos de avaliar músicas.
CREATE TRIGGER BLOQUEIA_BANIDOS_AVALIA
    BEFORE INSERT ON AVALIA
    FOR EACH ROW EXECUTE PROCEDURE TRIGGER_BLOQUEIA_BANIDOS();
