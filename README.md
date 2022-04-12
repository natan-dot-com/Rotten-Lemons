# Rotten Lemons

- Gabriel da Cunha Dertoni       - 11795717
- Natan Henrique Sanches         - 11795680
- Paulo Henrique de Souza Soares - 11884713
- Álvaro José Lopes              - 10873365

## Descrição do problema e dos requisitos de dados

Um dos principais serviços de *streaming* de músicas utilizados na
atualidade é o *Spotify*, que conta com uma grande variedade e
quantidade de músicas, possuindo também uma grande gama de
funcionalidades. Mesmo assim, algumas funcionalidades demandadas pelos
usuários não estão disponíveis até o momento. Em particular, o *Spotify*
não permite que usuários ou críticos deixem *reviews* em músicas, álbuns
e artistas. Além disso, métodos de *reviews* e classificação são
amplamente utilizados em outras mídias digitais, como no caso dos filmes
e séries (através de plataformas como o *Rotten Tomatoes*). Por conta
disso, existe uma demanda para tal serviço como demonstram publicações e
comentários de usuários do *Spotify* no fórum oficial da plataforma
(*Spofity community*[^1]).

O sistema proposto atende à demanda existente permitindo a classificação
e avaliação de músicas, álbuns e artistas da plataforma *Spotify*. Nesse
sistema, o usuário dispõe de um mecanismo de avaliação de cinco
estrelas, abrangendo também *tags* para classificação de acordo com
gênero e temática, além de comentários de livre escrita. Com os dados
das *tags*, serão levantadas estatísticas para a construção automática
de *playlists* tematizadas, com uma gama de músicas fortemente
relacionadas à *tag* escolhida. O usuário também pode se relacionar com
outros usuários da plataforma na forma de seguidor, sendo notificado dos
comentários e avaliações do seguido.

## Relacionamento entre entidades do 'mundo real'

Um **usuário** do sistema pode deixar uma **avaliação** (de 1 a 5
estrelas) para **músicas**, escolher ***tags*** classificadoras (como
feliz, triste, nostálgica, etc.) para ela e deixar um **comentário**
(com no máximo 300 caracteres). Cada usuário possui **nome de usuário**,
**sinalizador para críticos** (sim ou não) e um **sinalizador de
cargo**, sendo os cargos: **usuário**, **moderador** e
**administrador**. Os **moderadores** são responsáveis por garantir um
ambiente agradável aos **usuários** e podem remover **avaliações** e
***tags*** que não atendem às diretrizes da comunidade. Já os
**administradores** possuem permissões ainda maiores, podendo gerenciar
o sistema no geral. Além disso, cada **usuário** também possui um
conjunto de informações pessoais, sendo eles **endereço de *e-mail*** e
**idade**. Ademais, **usuários** também podem seguir outros **usuários**
e serão notificados de seus **comentários** e **avaliações**.

Um **artista** possui um **nome** e pode publicar vários **álbuns**.
Cada **álbum** possui um **nome** e é composto por um conjunto de
**músicas**. Artistas também podem colaborar na publicação de um
**álbum** conjunto. Além disso, uma **música** pode estar presente em
vários **álbuns**.

As ***tags*** são compostas e identificadas pelo seu **nome** e sua
relevância é determinada de acordo com a frequência que são utilizadas
por **música**. Cada **música** pode ser dita fortemente relacionada com
uma ***tag***, se ela foi repetidamente atribuída à **música** por
diferentes **usuários**. Uma ***tag*** gera uma ***playlist*** que será
composta por uma lista de **músicas**.

Os **comentários** (com no máximo 300 caracteres) **de** **música**,
**álbum** e **artista** são feitos por **usuários** e possuem
**conteúdo** e **data/hora de publicação**, se relacionando diretamente
com **música**, **álbum** e **artista** respectivamente.

## Principais funcionalidades

As funcionalidades são diversas para cada tipo de usuário. Dentre elas,
podemos citar:

-   **Usuário**
    -   Inserção, alteração ou remoção de avaliações em músicas, álbuns
        e artistas através de um sistema de avaliação cinco estrelas;
    -   Inserção, alteração ou remoção de *tags* em músicas para
        classificação;
    -   Inserção, alteração ou remoção de comentários de livre escrita
        em músicas, álbuns e artistas;
    -   Seguir outros usuários de preferência;
    -   Navegação entre as avaliações e os comentários mais recentes de
        determinada música, artista ou álbum;
    -   Pesquisa por determinado usuário, com base em seu nome de
        usuário;
    -   Salvamento de *playlists* através do mecanismo de 'Curtir'.

-   **Moderador**
    -   Alteração ou remoção de avaliações, comentários e *tags* que não
        sigam as diretrizes da comunidade;
    -   Banimento e perdão a usuários que descumpram as regras da
        comunidade;
    -   Listagem de usuários banidos;
    -   Concebimento do sinalizador de crítico para usuários
        reconhecidos como tal.

-   **Administrador**
    -   Inserção, modificação ou remoção de registros de músicas, álbuns
        e artistas;
    -   Listagem de moderadores;
    -   Concebimento do cargo de moderador para usuário.

## Restrições de Integridade (parcialmente feito)

## Discussões sobre ciclos

[^1]: Pode ser observado em
    <https://community.spotify.com/t5/Closed-Ideas/Social-Allow-Comments-on-Tracks-Albums/idi-p/1295893.>
    e
    <https://community.spotify.com/t5/Live-Ideas/Music-Personal-Rating-of-Music/idi-p/179102>
