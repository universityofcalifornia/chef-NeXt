name          "next-database"
description   "NeXt database node"

run_list([
  'recipe[next::mysql_server]'
])

default_attributes({
  'mysql' => {
    'allow_remote_root' => false,
    'remove_anonymous_users' => true
  }
})