# Import some python builtin librarys
import readline, atexit, pydoc, os
from functools import reduce

import psycopg2 as psy

from completer import Completer

# TODO: Make configurable
DBNAME = "rottenlemons"
USER = "postgres"
HISTFILE = os.path.join(os.path.expanduser("~"), ".history")

userdata = None

class CommandError(Exception): pass

def mk_dict(**kwargs): return kwargs;

def repl_input(prompt=">>> "):
  line = input(prompt)
  return line

def get_table_col_names(conn, table_name):
  with conn.cursor() as cur:
    cur.execute("""
      SELECT column_name FROM information_schema.columns
        WHERE table_name = %(table_name)s
        ORDER BY ordinal_position
    """,
    mk_dict(table_name=table_name))
    return [tup[0] for tup in cur.fetchall()]

class Command:
  instances = []

  @staticmethod
  def match_and_run(conn, command):
    had_match = False
    for cmd in Command.instances:
      if command.startswith(cmd.name):
        try: cmd.run(conn, command[len(cmd.name):])
        except CommandError as err:
          print(f"Erro de comando: {err}")
        had_match = True
        break

    return had_match
  
  @staticmethod
  def command_names():
    return list(map(lambda cmd: cmd.name, Command.instances))

  def __init__(self, name, handler, requires_login=False, help=""):
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
    print(self.help)

def command(name, requires_login=False, help="...sem mensagem..."):
  def command_decorator(handler):
    Command.instances.append(
      Command(name, handler, requires_login=requires_login, help=help)
    )
    return handler
  
  return command_decorator

## Commands ##


# This command is special and doesn't have a handler function.
# It will be caught before any handler is called.
@command("sair")
def quit_repl():
  # Code should never reach this line because this command should
  # be caught early and exit gracefully. But if we do get here,
  # exiting is also acceptable behavior.
  exit()

@command("help", help="help '<comando>' - retorna uma mensagem de ajuda sobre o comando")
def help_cmd(_, args):
  args = args.strip()
  if len(args) <= 2 or args[0] != "'" or args[-1] != "'":
    raise CommandError("forma de uso: help 'comando entre aspas simples'")

  cmd_name = args[1:-1]
  try:
    # Find the command with the specified name.
    cmd = next(cmd for cmd in Command.instances if cmd.name == cmd_name)
    print(cmd.help)
  except StopIteration:
    raise CommandError(f"comando '{cmd_name}' não encontrado")

@command("registrar")
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

@command("login")
def login(conn, command):
  global userdata

  email = command.strip()
  user_cols = get_table_col_names(conn, 'usuario')
  with conn.cursor() as cur:
    cur.execute("""
      SELECT * FROM usuario
        WHERE email = %(email)s
      """,
      {'email': email})

    user = cur.fetchone()
    if user is None: raise CommandError("Email não encontrado")

    userdata = {}
    for col, data in zip(user_cols, user):
      userdata[col] = data

    print("Logado com sucesso")

@command("buscar musica")
def search_song(conn, _):
  song_name = repl_input("nome da música (parcial): ")

  col_names = get_table_col_names(conn, 'musica')
  with conn.cursor() as cur:
    cur.execute("""
        SELECT * FROM musica
          WHERE UPPER(nome_musica) LIKE %s
      """,
      [song_name.upper() + '%'])

    tuples = cur.fetchall()
    if not tuples:
      print("Nenhuma música encontrada")
      return

    # Convert all columns of the table to strings
    tuple_strings = [col_names] + list(map(lambda tup: tuple(map(str, tup)), tuples))

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
      "Músicas:",
      "========",
      header,
      separator,
      *rest
    ]
    pydoc.pager("\n".join(lines))

@command("avaliar musica", requires_login=True)
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

@command("atribuir tag", requires_login=True)
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

@command("comentar", requires_login=True)
def comment(conn, _):
  type = repl_input("tipo do comentário (artista, album ou musica): ")
  if type == "artista":
    target_id = repl_input("id do artista: ")
  elif type == "album":
    target_id = repl_input("id do álbum: ")
  elif type == "musica":
    target_id = repl_input("id da música: ")

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

      if type.upper() == "ARTISTA":
        cur.execute(
          """
            INSERT INTO comentario_artista(id_comentario, artista_comentario)
              VALUES (%(id_comentario)s, %(artista_comentario)s)
          """,
          mk_dict(
            id_comentario = comment_id,
            artista_comentario = target_id
          )
        )
      elif type.upper() == "ALBUM":
        cur.execute(
          """
            INSERT INTO comentario_album(id_comentario, id_album)
              VALUES (%(id_comentario)s, %(id_album)s)
          """,
          mk_dict(
            id_comentario = comment_id,
            id_album = target_id
          )
        )
      elif type.upper() == "MUSICA":
        cur.execute(
          """
            INSERT INTO comentario_musica(id_comentario, id_musica)
              VALUES (%(id_comentario)s, %(id_musica)s)
          """,
          mk_dict(
            id_comentario = comment_id,
            id_musica = target_id
          )
        )

    print("Comentário efetuado com sucesso!")

def main(conn):
  while True:
    try:
      cmd = repl_input()
      if cmd.startswith("sair"): break
      if not Command.match_and_run(conn, cmd):
        print("Erro: comando não reconhecido")
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

  completer = Completer(Command.command_names())
  readline.set_completer_delims(' \t\n;')
  readline.set_completer(completer.complete)
  readline.parse_and_bind('tab: complete')
  readline.set_completion_display_matches_hook(completer.display_matches)

  def savehist(prev_hist_len):
    new_hist_len = readline.get_current_history_length()
    readline.set_history_length(1000)
    readline.append_history_file(new_hist_len - prev_hist_len, HISTFILE)

  atexit.register(savehist, hist_len)

  conn = psy.connect(f"dbname={DBNAME} user={USER}")
  main(conn)
  conn.close()