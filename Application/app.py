# Import some python builtin librarys
import readline, atexit, pydoc
from os import environ, path
from datetime import datetime
from functools import reduce

import psycopg2 as psy

from completer import Completer

# These are only default values. At runtime, if there is an environment variable DBNAME, that will
# be used instead of this default. Same goes for USER and HISTFILE.
DBNAME = "rottenlemons"
DBUSER = "postgres"
HISTFILE = path.join(path.expanduser("~"), ".history")

userdata = None

def mk_dict(**kwargs): return kwargs;

def repl_input(prompt=">>> "):
  line = input(prompt)
  return line

def page_table(table_name, col_names, tuples, date_formatter=str):
  # Converts a tuple of things a list of strings
  def tup_to_list_of_strings(tup):
    def val_to_str(val):
      if isinstance(val, datetime): return date_formatter(val)
      return str(val)
    return list(map(val_to_str, tup))

  # Convert all columns of the table to strings
  tuple_strings = [col_names] + list(map(tup_to_list_of_strings, tuples))

  # Calculate the maximum width of the stringified columns
  col_widths = list(reduce(
    lambda acc, el: map(max, acc, el),
    map(lambda tup: map(len, tup), tuple_strings)))

  # Format table line with padding
  def format_line(tup):
    return " | ".join(map(lambda col, w: f"{col:<{w}}", tup, col_widths))

  separator = "-+-".join(['-' * w for w in col_widths])
  header, *rest = map(format_line, tuple_strings)
  lines = [
    table_name + ':',
    '=' * (len(table_name) + 1),
    header,
    separator,
    *rest
  ]
  pydoc.pager("\n".join(lines))

class CommandError(Exception): pass

class Command:
  instances = []

  def __init__(self, name, handler, requires_login=False, help=None):
    self.name = name
    self.handler = handler
    self.requires_login = requires_login
    self.help = help

  def run(self, conn, cmd_args):
    if self.requires_login:
      global userdata
      if userdata is None:
        raise CommandError("É necessário estar logado")

    self.handler(conn, cmd_args)

  def display_help(self):
    print(self.help or "...sem mensagem...")

def command(name, requires_login=False, help=None):
  def command_decorator(handler):
    Command.instances.append(
      Command(name, handler, requires_login=requires_login, help=help)
    )
    return handler

  return command_decorator

def get_all_commands():
    return Command.instances

def command_names():
    return list(map(lambda cmd: cmd.name, Command.instances))

def match_and_run_command(command, *args):
    had_match = False
    for cmd in Command.instances:
      if command.startswith(cmd.name):
        try: cmd.run(*args, command[len(cmd.name):])
        except CommandError as err:
          print(f"Erro de comando: {err}")
        had_match = True
        break

    return had_match

## Commands ##

# This command is special and doesn't have a handler function.
# It will be caught before any handler is called.
@command("sair", help="sair - fecha o REPL e encerra a sessão")
def quit_repl():
  # Code should never reach this line because this command should
  # be caught early and exit gracefully. But if we do get here,
  # exiting is also acceptable behavior.
  exit()

@command("ajuda", help="ajuda '<comando>' - retorna uma mensagem de ajuda sobre o comando")
def help_cmd(_, args):
  args = args.strip()
  if len(args) <= 2 or args[0] != "'" or args[-1] != "'":
    raise CommandError("forma de uso: ajuda 'comando entre aspas simples'")

  cmd_name = args[1:-1]
  try:
    # Find the command with the specified name.
    cmd = next(cmd for cmd in get_all_commands() if cmd.name == cmd_name)
    cmd.display_help()
  except StopIteration:
    raise CommandError(f"comando '{cmd_name}' não encontrado")

@command("lista comandos", help="lista comandos - lista todos os comandos disponíveis")
def list_commands(_conn, _):
  for cmd in get_all_commands():
    help = cmd.help.split('\n')[0] if cmd.help else None
    if help:
      print(help)
    else:
      print(cmd.name)

@command("registrar", help="registrar - cria um novo usuário")
def create_user(conn, _):
  email = repl_input("email: ")
  username = repl_input("username: ")
  data_nascimento = repl_input("data de nascimento (dd/mm/aaaa): ")

  with conn.cursor() as cur:
    # TODO: eh_critico deveria ser default
    cur.execute("""
      INSERT INTO usuario(nome_usuario, eh_critico, email, data_nascimento)
        VALUES (%(nome_usuario)s, 'f', %(email)s,
                TO_DATE(%(data_nascimento)s, 'DD/MM/YYYY'))""",
      mk_dict(
        nome_usuario = username,
        email = email,
        data_nascimento = data_nascimento
      ))

  print("Usuário criado com sucesso")

@command("login", help="""\
login <email> - faz login com um email

PARAMS:
    <email> - endereço de email para usuário
""")
def login(conn, command):
  global userdata

  email = command.strip()
  with conn.cursor() as cur:
    cur.execute("SELECT * FROM usuario WHERE email = %(email)s", mk_dict(email = email))

    user = cur.fetchone()
    if user is None: raise CommandError("Email não encontrado")

    user_cols = [col[0] for col in cur.description]
    userdata = {}
    for col, data in zip(user_cols, user):
      userdata[col] = data

    print("Logado com sucesso")

@command("buscar", help="""\
buscar <tipo> - busca por uma música, álbum, artista ou usuário por nome.

PARAMS:
    <tipo> pode ser 'musica', 'album', 'artista' ou 'usuario'.\
""")
def search(conn, command):
  type = command.strip()
  if type == "musica":
    prompt = "nome da música (parcial)"
    nothing_msg = "Nenhuma música encontrada com esse nome."
    table_name = "musica"
    table_col = "nome_musica"
  elif type == "album":
    prompt = "nome do álbum (parcial)"
    nothing_msg = "Nenhum álbum encontrada com esse nome."
    table_name = "album"
    table_col = "nome_album"
  elif type == "artista":
    prompt = "nome do artista (parcial)"
    nothing_msg = "Nenhum artista encontrado com esse nome."
    table_name = "artista"
    table_col = "nome_artista"
  elif type == "usuario":
    prompt = "nome do usuário (parcial)"
    nothing_msg = "Nenhum usuário encontrado com esse nome."
    table_name = "usuario"
    table_col = "nome_usuario"
  else:
    raise CommandError("<tipo> precisa ser 'musica', 'album' ou 'artista'")

  search = repl_input(f"{prompt}: ")

  with conn.cursor() as cur:
    # It is ok to use f-strings here directly since we control the values of `table_name` and
    # `table_col` so there is no danger for SQL injection.
    cur.execute(f"""
        SELECT * FROM {table_name}
          WHERE UPPER({table_col}) LIKE %s
      """,
      [search.upper() + '%'])

    tuples = cur.fetchall()
    if not tuples:
      print(nothing_msg)
      return

    col_names = [col[0] for col in cur.description]
    page_table(table_name, col_names, tuples);

@command("avaliar musica", requires_login=True,
         help="avaliar musica - avalia uma música (por id) numa escala de 5 estrelas")
def rate_song(conn, _):
  global userdata

  song_id = repl_input("id da música: ")
  stars = int(repl_input("número de estrelas (de 1 a 5): "))

  with conn:
    with conn.cursor() as cur:
      cur.execute(
        """
          INSERT INTO avalia(nome_usuario, id_musica, estrelas)
            VALUES (%(nome_usuario)s, %(id_musica)s, %(estrelas)s)
        """,
        mk_dict(
          nome_usuario = userdata["nome_usuario"],
          id_musica = song_id,
          estrelas = stars
        )
      )

    print("Música avaliada com sucesso")

@command("atribuir tag", requires_login=True,
         help="atribuir tag - atribui uma tag a uma música (por id)")
def tag(conn, _):
  global userdata

  song_id = repl_input("id da música: ")
  tag = repl_input("nome da tag: ")

  with conn:
    with conn.cursor() as cur:
      cur.execute(
        """
          SELECT * FROM tag WHERE nome_tag = %(tag)s
        """,
        mk_dict(tag = tag)
      )

      # Check if tag already exits
      if cur.fetchone() is None:
        # Tag does not exits, create it
        cur.execute(
          """
            INSERT INTO tag(nome_tag)
              VALUES (%(tag)s)
          """,
          mk_dict(tag = tag)
        )

      cur.execute(
        """
          INSERT INTO classifica_por(id_musica, tag, nome_usuario)
            VALUES (%(id_musica)s, %(tag)s, %(nome_usuario)s)
        """,
        mk_dict(
          id_musica = song_id,
          tag = tag,
          nome_usuario = userdata["nome_usuario"]
        )
      )

    print("Tag atribuida com sucesso")

@command("remover tag", requires_login=True,
         help="remover tag - remove uma tag de uma música (por id)")
def untag(conn, _):
  global userdata

  song_id = repl_input("id da música: ")
  tag = repl_input("nome da tag: ")

  with conn:
    with conn.cursor() as cur:
      cur.execute(
        """
          DELETE FROM classifica_por
            WHERE id_musica = %(id_musica)s
              AND tag = %(tag)s
              AND nome_usuario = %(nome_usuario)s
        """,
        mk_dict(
          id_musica = song_id,
          tag = tag,
          nome_usuario = userdata["nome_usuario"]
        )
      )

      if cur.rowcount == 0:
        print("Tag não tinha sido atribuída. Nada foi modificado.")
      else:
        print("Tag removida com sucesso")

@command("comentar", requires_login=True, help="""\
comentar <tipo> - deixa um comentário.

PARAMS:
    <tipo> - pode ser 'artista', 'album' ou 'musica'\
""")
def comment(conn, args):
  global userdata

  type = args.strip()
  if type == "artista":
    target_id = repl_input("nome do artista: ")
    table_name = "comentario_artista"
    fk_col = "artista_comentari"
  elif type == "album":
    target_id = repl_input("id do álbum: ")
    table_name = "comentario_album"
    fk_col = "id_album"
  elif type == "musica":
    target_id = repl_input("id da música: ")
    table_name = "comentario_musica"
    fk_col = "id_musica"
  else:
    raise CommandError("<tipo> precisa ser 'artista', 'album' ou 'musica'")

  comment = repl_input("comentário: ")

  with conn:
    with conn.cursor() as cur:
      cur.execute(
        """
          INSERT INTO comentario(nome_usuario, conteudo, tipo)
            VALUES (%(nome_usuario)s, %(conteudo)s, %(tipo)s)
            RETURNING id_comentario
        """,
        mk_dict(
          nome_usuario = userdata["nome_usuario"],
          conteudo = comment,
          tipo = type.upper()
        )
      )

      [comment_id] = cur.fetchone()

      # Here it is ok to use f-strings directly since we control the values of `table_name` and
      # `fk_col`. They are NOT user provided and can only be assigned safe values, so no SQL
      # injections can occur.
      cur.execute(
        f"""
          INSERT INTO {table_name}(id_comentario, {fk_col})
            VALUES (%(id_comentario)s, %(target_id)s)
        """,
        mk_dict(
          id_comentario = comment_id,
          target_id = target_id
        )
      )

    print(f"Comentário efetuado com sucesso! ID do comentário: {comment_id}")

@command("remove comentario", requires_login=True, help="""\
remove comentario <id do comentário> - remove um comentário.

PARAMS:
    <id do comenário> - id único do comentário.\
""")
def remove_comment(conn, comment_id):
  try: comment_id = int(command.trim())
  except ValueError: raise CommandError("<id do comentário> precisa ser um inteiro")

  with conn:
    with conn.cursor() as cur:
      cur.execute(
        """
          DELETE FROM comentario
            WHERE id_comentario = %(id_comentario)s
        """,
        mk_dict(id_comentario = comment_id)
      )

      if cur.rowcount == 0:
        print("Comentário não encontrado")
      else:
        print("Comentário removido")

@command("lista comentarios de", help="""\
lista comentarios de <nome de usuário> - lista os comentários feitos por um usuário\
""")
def list_comments_by(conn, command):
  username = command.strip()

  with conn.cursor() as cur:
    cur.execute(
      """
        SELECT com.id_comentario, data_publ, conteudo, art.artista_comentario, alb.id_album, mus.id_musica
          FROM comentario com
            LEFT JOIN comentario_artista art ON art.id_comentario = com.id_comentario
            LEFT JOIN comentario_album   alb ON alb.id_comentario = com.id_comentario
            LEFT JOIN comentario_musica  mus ON mus.id_comentario = com.id_comentario
          WHERE nome_usuario = %(nome_usuario)s
      """,
      mk_dict(nome_usuario = username)
    )

    tuples = cur.fetchall()
    if len(tuples) == 0:
      print("Nada encontrado...")
      return

    colnames = ["id_comentario", "data_publ", "conteudo", "artista_comentario", "id_album", "id_musica"]
    page_table(f"Comentários de {username}", colnames, tuples, date_formatter=lambda d: str(d.date()))

@command("lista tags", help="lista todas as tags registradas")
def list_tags(conn, _):
  with conn.cursor() as cur:
    cur.execute("""SELECT * FROM tag""")
    tuples = cur.fetchall()

    if len(tuples) == 0:
      print("Nenhuma tag registradas")
      return

    colnames = [col[0] for col in cur.description]
    page_table("Tags", colnames, tuples)

@command("curtir", requires_login=True, help="""\
curtir <id da playlist> - curte uma playlist

PARAMS:
    <id da playlist> - playlist a ser curtida\
""")
def like(conn, command):
  global userdata

  try: playlist_id = int(command.strip())
  except ValueError: raise CommandError("<id da playlist> precisa ser um inteiro")

  with conn:
    with conn.cursor() as cur:
      cur.execute(
        """
          INSERT INTO curte(nome_usuario, id_playlist)
            VALUES (%(nome_usuario)s, %(id_playlist)s)
        """,
        mk_dict(
          nome_usuario = userdata["nome_usuario"],
          id_playlist = playlist_id
        )
      )

@command("remover curtida", requires_login=True, help="""\
remover curtida <id da playlist> - remove a curtida de uma playlist

PARAMS:
    <id da playlist> - playlist que foi curtida, mas terá a curtida removida.\
""")
def dislike(conn, _):
  global userdata

  playlist_id = repl_input("id da playlist: ")

  with conn:
    with conn.cursor() as cur:
      cur.execute(
        """
          DELETE FROM curte
            WHERE nome_usuario = %(nome_usuario)s
              AND id_playlist = %(id_playlist)s
        """,
        mk_dict(
          nome_usuario = userdata["nome_usuario"],
          id_playlist = playlist_id
        )
      )

      if cur.rowcount == 0:
        print("Não havia curtido ainda. Nada foi modificado.")
      else:
        print("Curtida efetuada com sucesso")

@command("seguir", requires_login=True, help="""\
seguir <nome do usuário> - segue um usuário

PARAMS:
    <nome do usuário> - nome do usuário que gostaria de seguir.\
""")
def follow(conn, command):
  global userdata

  username = command.strip()

  with conn:
    with conn.cursor() as cur:
      cur.execute(
        """
          INSERT INTO segue(nome_usuario, nome_usuario_seguido)
            VALUES (%(nome_usuario)s, %(nome_usuario_seguido)s)
        """,
        mk_dict(
          nome_usuario = userdata["nome_usuario"],
          nome_usuario_seguido = username
        )
      )

      print(f"Agora seguindo {username}")

@command("deixar de seguir", requires_login=True, help="""\
deixar de seguir <nome do usuário> - deixa de seguir um usuário

PARAMS:
    <nome do usuário> - nome do usuário que estava seguindo e gostaria de deixar de seguir.\
""")
def unfollow(conn, command):
  global userdata

  username = command.strip()

  with conn:
    with conn.cursor() as cur:
      cur.execute(
        """
          DELETE FROM segue
            WHERE nome_usuario = %(nome_usuario)s
              AND nome_usuario_seguido = %(nome_usuario_seguido)s
        """,
        mk_dict(
          nome_usuario = userdata["nome_usuario"],
          nome_usuario_seguido = username
        )
      )

      if cur.rowcount == 0:
        print(f"Não estava seguindo {username}. Nada foi modificado.")
      else:
        print(f"Deixou de seguir {username}")

@command("banir", requires_login=True, help="""\
banir <nome do usuário> - bane um usuário (somente para moderadores e administradores)

PARAMS:
    <nome do usuário> - nome do usuário a ser banido\
""")
def ban(conn, command):
  global userdata

  username = command.strip()
  motive = repl_input("motivo: ")

  with conn:
    with conn.cursor() as cur:
      cur.execute(
        """
          INSERT INTO banido_por(usuario_banido, moderador, motivo)
            VALUES (%(usuario_banido)s, %(moderador)s, %(motivo)s)
        """,
        mk_dict(
          usuario_banido = username,
          moderador = userdata["nome_usuario"],
          motivo = motive
        )
      )

    print(f"Usuário '{username}' banido com sucesso")

@command("perdoar", requires_login=True, help="""\
perdoar <nome do usuário> - remove o banimento de um usuário (somente para moderadores e administradores)

PARAMS:
    <nome do usuário> - nome do usuário que será perdoado.\
""")
def forgive(conn, command):
  username = command.strip()

  with conn:
    with conn.cursor() as cur:
      cur.execute(
        """
          DELETE FROM banido_por
            WHERE usuario_banido = %(usuario_banido)s
        """,
        mk_dict(usuario_banido = username)
      )

      if cur.rowcount == 0:
        print("Usuário não estava banido ou não foi encontrado. Nada foi modificado.")
      else:
        print(f"Usuário {username} foi perdoado")

@command("lista playlists", help="lista playlists - lista todas as playlists registradas.")
def list_playlists(conn, _):
  with conn.cursor() as cur:
    cur.execute("SELECT id_playlist, tag_playlist FROM playlist")
    colnames = ["id_playlist", "tag_playlist"]
    tuples = cur.fetchall()
    if len(tuples) == 0:
      print("nenuma playlist encontrada")
      return

    page_table("Playlists", colnames, tuples)

@command("cria playlist", requires_login=True, help="""\
cria playlist <tag> - cria uma nova playlist (vazia) (somente para administradores)

PARAMS:
    <tag> - nome da tag que será associada à playlist\
""")
def create_playlist(conn, command):
  global userdata

  if userdata["cargo"] != 'A':
    raise CommandError("Somente administradores podem criar playlists")

  tag = command.strip()
  with conn:
    with conn.cursor() as cur:
      cur.execute(
        """
          INSERT INTO playlist(tag_playlist)
            VALUES (%(tag_playlist)s)
          RETURNING id_playlist
        """,
        mk_dict(tag_playlist = tag)
      )

      [id_playlist] = cur.fetchone()
      print(f"Playlist criada com sucesso. ID: {id_playlist}")

@command("adiciona playlist", requires_login=True, help="""\
adiciona playlist <id playlist> <id musica> - Adiciona musica à playlist (somente para administradores)

PARAMS:
    <id playlist> - id da playlist que terá um música adicionada.
    <id musica> - id da música a ser adicionada na playlist.
""")
def add_to_playlist(conn, command):
  global userdata

  if userdata["cargo"] != 'A':
    raise CommandError("Somente administradores podem adicionar músicas a playlists")

  playlist_id, song_id = command.strip().split()

  try: playlist_id = int(playlist_id)
  except ValueError: raise CommandError("<id playlist> precisa ser um valor inteiro")

  try: song_id = int(song_id)
  except ValueError: raise CommandError("<id musica> precisa ser um valor inteiro")

  with conn:
    with conn.cursor() as cur:
      cur.execute(
        """
          INSERT INTO playlist_contem(id_musica, id_playlist)
            VALUES (%(id_musica)s, %(id_playlist)s)
        """,
        mk_dict(
          id_musica = song_id,
          id_playlist = playlist_id,
        )
      )

    print("Música adicionada com sucesso à playlist")

@command("remove playlist", requires_login=True, help="""\
remove playlist <id playlist> - remove uma playlist (somente para administradores).

PARAMS:
    <id playlist> - id da playlist que será removida.\
""")
def create_playlist(conn, command):
  if userdata["cargo"] != 'A':
    raise CommandError("Somente administradores podem remover playlists")

  try: playlist_id = int(command.strip())
  except ValueError: raise CommandError("<id playlist> precisa ser um valor inteiro")

  tag = command.strip()
  with conn:
    with conn.cursor() as cur:
      cur.execute(
        """
          DELETE FROM playlist
            WHERE id_playlist = %(id_playlist)s
        """,
        mk_dict(id_playlist = playlist_id)
      )

      print(f"Playlist removida com sucesso.")

@command("mostra playlist", help="""\
mostra playlist <id playlist> - mostra as músicas de uma playlist.

PARAMS:
    <id playlist> - id da playlist que será mostrada.\
""")
def show_playlist(conn, command):
  try: playlist_id = int(command.strip())
  except ValueError: raise CommandError("<id playlist> precisa ser um valor inteiro")

  with conn.cursor() as cur:
    cur.execute(
      """
        SELECT musica.nome_musica, musica.album, musica.duracao, album.nome_album,
               artista.nome_artista
          FROM playlist_contem
          NATURAL JOIN musica
          INNER JOIN album ON musica.album = album.id_album
          INNER JOIN artista ON artista.nome_artista = album.artista
          WHERE playlist_contem.id_playlist = %(id_playlist)s
      """,
      mk_dict(id_playlist = playlist_id)
    )

    tuples = cur.fetchall()

    if len(tuples) == 0:
      print("Playlist vazia ou não existente")
      return

    colnames = ["nome_musica", "album", "duracao", "nome_album", "nome_artista"]
    page_table(f"Playlist {playlist_id}", colnames, tuples)

def main(conn):
  while True:
    try:
      cmd = repl_input()
      if cmd.startswith("sair"): break
      if not match_and_run_command(cmd, conn):
        print(f"Erro: comando '{cmd}' não reconhecido")
    except EOFError: break
    except KeyboardInterrupt: print() # Print an emtpy line
    except psy.DatabaseError as err:
      database_error_str = "DatabaseError:"
      print(database_error_str)
      print('=' * len(database_error_str))
      print(err)

if __name__ == '__main__':
  try:
    readline.read_history_file()
    hist_len = readline.get_current_history_length()
  except FileNotFoundError:
    open(HISTFILE, 'w').close()
    hist_len = 0

  completer = Completer(command_names())
  readline.set_completer_delims(' \t\n;')
  readline.set_completer(completer.complete)
  readline.parse_and_bind('tab: complete')
  readline.set_completion_display_matches_hook(completer.display_matches)

  def savehist(prev_hist_len):
    new_hist_len = readline.get_current_history_length()
    readline.set_history_length(1000)
    readline.append_history_file(new_hist_len - prev_hist_len, HISTFILE)

  atexit.register(savehist, hist_len)

  DBNAME = environ.get("DBNAME") or DBNAME
  DBUSER = environ.get("DBUSER") or DBUSER
  HISTFILE = environ.get("HISTFILE") or HISTFILE

  conn = psy.connect(f"dbname={DBNAME} user={DBUSER}")
  main(conn)
  conn.close()
