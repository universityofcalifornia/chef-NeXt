name          "foundation-packages"
description   "Install baseline packages"

run_list([
  'recipe[build-essential]',
  'recipe[git]',
  'recipe[java]',
  'recipe[nodejs]',
  'recipe[nodejs::npm]',
  'recipe[packages]',
  'recipe[rvm::system]',
  'recipe[yum-epel]'
])

default_attributes({
  'java' => {
    'install_flavor' => 'openjdk',
    'jdk_version' => 7
  },
  'packages_action' => 'install',
  'packages' => [
    'curl'
  ],
  'rvm' => {
      'rubies' => ['2.2.0'],
      'default_ruby' => '2.2.0'
  },
  'yum' => {
    'epel' => {
      'enabled' => true
    }
  }
})