# Duvidas

1. Sobre a exclusão mútua do comentário. Existe alguma forma melhor de
   representar? Se for com herança, precisaria de uma chave...
2. Dimensão do trabalho. O trabalho está dentro da dimensão esperada?
3. O diagrama com o cargo como entidade está correto? No caso a entidade
   "cargo" só poderia ter uma instância para cada subtipo, uma vez que o chave
   é também o que diferencia entre os tipos.
4. Não faz sentido a relação de Artista com Álbum ser N para M sendo que o
   Álbum é entidade fraca. Isso porque, se a chave do Álbum é o próprio
   artista, e vários artistas publicam um Álbum, então
