# Rotten Lemons

- Gabriel da Cunha Dertoni       - 11795717
- Natan Henrique Sanches         - 11795680
- Paulo Henrique de Souza Soares - 11884713
- Álvaro José Lopes              - 10873365

## Descrição do problema e dos requisitos de dados

Um dos principais serviços de streaming de música utilizados na atualidade é o
Spotify, que conta com uma grande variedade e quantidade de músicas, possuindo
também uma grande gama de funcionalidades. Mesmo assim, algumas funcionalidades
demandadas pelos usuários não estão disponíveis até o momento. Em particular, o
Spotify não permite que usuários ou críticos deixem reviews em músicas, álbuns e
artistas. Além disso, métodos de review e classificação são amplamente
utilizados em outras mídias digitais, como no caso dos filmes e séries (através
de plataformas como o Rotten Tomatoes). Por conta disso, existe uma demanda para
tal serviço como demonstram publicações e comentários de usuários do Spotify no
fórum oficial da plataforma (Spofity community).

O sistema proposto atende à demanda existente permitindo a classificação e
avaliação de músicas, álbuns e artistas da plataforma Spotify. Nesse sistema, o
usuário dispõe de um mecanismo de avaliação cinco estrelas, abrangendo também
tags para classificação de acordo com gênero e sentimento. Com os dados, serão
levantadas estatísticas para sugestão de novas músicas aos usuários através de
um sistema de recomendação. Além disso, as músicas também poderão ser agrupadas
em playlists temáticas caso requisitado pelo usuário.

Um **usuário** do sistema pode deixar uma **avaliação** para **músicas**, além
de **tags** classificadoras para ela. Cada **usuário** possui **nome de usuário**,
**sinalizador para críticos** e um **sinalizador de cargo**, sendo os cargos: 
**usuário**, **moderador** e **administrador**. Os **moderadores** são responsáveis por
garantir a um ambiente agradável aos usuários e podem remover avaliações e tags
que não às diretrizes da comunidade. Já os **administradores** possuem
permissões ainda maiores, podendo gerenciar o sistema no geral. Além disso, cada
**usuário** também possui **endereço de email**, **idade** e um **conjunto de
tags** com o qual se identifica.

Um **artista** possui um nome

As tags possuem sua relevância de acordo com a frequência que são
utilizdas em cada música. Assim, se a tag "Eletrônica" for associada com
grande frequência a determinada música, ela será considerada relevante para essa
música.

### Métodos de avaliação das músicas

- Comentário
- Avaliação de estrelas
- Avaliação de "gostei" para comentários

### Métodos de classificação

- Tags
- Gêneros

## Características e Atributos

```
Música:
  nome: String
  álbum: Álbum
  artista: Artista

Álbum:
  artista: Artista

Artista:
  nome: String

Tag:
  nome: String

OcorrênciaTag:
  tag: Tag
  música: Música
  ocorrências: Inteiro

Avaliação:
  usuário: Usuário
  comentário: String
  estrelas: Inteiro
  música: Música

Usuário:
  name: String
  éCrítico: Booleano
```

## Relacionamento entre entidades do 'mundo real'

## Restrições de Integridade

## Principais operações
