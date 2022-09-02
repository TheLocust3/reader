open Model
open Model.User.Internal

let make ~id ~email ~password =
  { id = id; email = email; password = Bcrypt.hash_of_string password }

let migrate_query = [%rapper
  execute {sql|
    CREATE TABLE users (
      id TEXT NOT NULL UNIQUE PRIMARY KEY,
      email TEXT NOT NULL UNIQUE,
      password TEXT
    )
  |sql}
  syntax_off
]

let rollback_query = [%rapper
  execute {sql|
    DROP TABLE users
  |sql}
  syntax_off
]

let create_query = [%rapper
  execute {sql|
    INSERT INTO users (id, email, password)
    VALUES (%string{id}, %string{email}, %string{password})
  |sql}
  syntax_off
]

let by_email_query = [%rapper
  get_opt {sql|
    SELECT @string{users.id}, @string{users.email}, @string{users.password}
    FROM users
    WHERE email = %string{email}
  |sql}
  function_out
  syntax_off
](make)

let migrate connection =
  let query = migrate_query() in
    query connection |> Error.Database.or_print

let rollback connection =
  let query = rollback_query() in
    query connection |> Error.Database.or_print

let by_email email connection =
  let query = by_email_query ~email: email in
    query connection |> Error.Database.or_error_opt

let create { id; email; password } connection =
  let query = create_query ~id: id ~email: email ~password: (Bcrypt.string_of_hash password) in
    query connection |> Error.Database.or_error
