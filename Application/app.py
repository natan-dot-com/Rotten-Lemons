import readline
import atexit
import os
import subprocess as subp
from functools import reduce
import psycopg2 as psy

DBNAME = "rottenlemons"
USER = "gabrieldertoni"
HISTFILE = os.path.join(os.path.expanduser("~"), ".history")

useremail = None

class CommandError(Exception): pass

def mk_dict(**kwargs): return kwargs;

def repl_input(prompt=">> "):
  line = input(prompt)
  return line

def create_user(conn, _):
  email = repl_input("email: ")
  nome = repl_input("nome: ")
  data_nascimento = repl_input("data de nascimento: ")

  with conn.cursor() as cur:
    # TODO: eh_critico deveria ser default
    cur.execute("""
      INSERT INTO usuario(nome_usuario, eh_critico, email, data_nascimento)
        VALUES (%(nome_usuario)s, 'f', %(email)s,
                TO_DATE(%(data_nascimento)s, 'DD/MM/YYYY'))""",
      mk_dict(
        nome_usuario = nome,
        email = email,
        data_nascimento = data_nascimento
      ))

def login(conn, command):
  global useremail

  email = command.strip()
  with conn.cursor() as cur:
    cur.execute("""
      SELECT * FROM usuario
        WHERE email = %(email)s
      """,
      {'email': email})

    user = cur.fetchone()
    if user is None:
      print("Email não encontrado")
    else:
      useremail = email
      print("Logado com sucesso")

def search_song(conn, _):
  song_name = repl_input("nome da música (parcial): ")

  with conn.cursor() as cur:
    cur.execute("""
        SELECT * FROM musica
          WHERE nome_musica LIKE %s
      """,
      [song_name + '%'])

    tuples = cur.fetchall()
    if not tuples:
      print("Nenhuma música encontrada")
      return

    n_fields = len(tuples[0])
    tuple_strings = map(lambda tup: map(str, tup), tuples)
    col_widths = reduce(
      lambda acc, el: map(max, zip(acc, el)),
      map(lambda tup: map(len, tup), tuple_strings))

    def to_byte_line(tup):
      line = "\t".join(map(lambda col, w: f"{col:<{w}}", zip(tup, col_widths)))
      return bytes(line + '\n', encoding="utf-8")

    lines = list(map(to_byte_line, tuples))

    with subp.Popen(["/usr/bin/less", "-"], stdin=subp.PIPE) as proc:
      proc.stdin.writelines(lines)

def rate_song(conn, _):
  global useremail
  if useremail is None:
    raise CommandError("É necessário estar logado")

  song_id = repl_input("id da música: ")

  with conn.cursor() as cur:
    cur.execute("""
      SELECT * FROM musica
        WHERE id_musica = %s
    """,
    song_id)

    print(cur.fetchone())

COMMANDS = {
  "login as": login,
  "registrar": create_user,
  "buscar musica": search_song,
}

def run_command(conn, command):
  for [cmd, handler] in COMMANDS.items():
    if command.startswith(cmd):
      try: handler(conn, command[len(cmd):])
      except CommandError as err:
        print(f"Erro de comando: {err}")
      break

def main(conn):
  while True:
    try: run_command(conn, repl_input())
    except EOFError: break

def save(prev_hist_len):
  new_hist_len = readline.get_current_history_length()
  readline.set_history_length(1000)
  readline.append_history_file(new_hist_len - prev_hist_len, HISTFILE)

if __name__ == '__main__':
  try:
    readline.read_history_file()
    hist_len = readline.get_current_history_length()
  except FileNotFoundError:
    open(HISTFILE, 'w').close()
    hist_len = 0

  atexit.register(save, hist_len)

  with psy.connect(f"dbname={DBNAME} user={USER}") as conn:
    try: main(conn)
    except KeyboardInterrupt: pass