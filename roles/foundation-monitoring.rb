name          "foundation-packages"
description   "Install baseline monitoring"

run_list([
  'recipe[monit-ng]',
  'recipe[monit-ng::sshd]',
  'recipe[monit-ng::crond]',
  'recipe[monit-ng::rsyslog]'
])

default_attributes({
  'monit' => {
    'install_method' => 'source',
    'source' => {
      'version' => '5.10',
      'checksum' => '3791155a1b1b6b51a4a104dfe6f17b37d7c346081889f1bec9339565348d9453'
    }
  }
})