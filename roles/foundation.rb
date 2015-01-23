name          "foundation"
description   "Node foundation"

run_list([
  'role[foundation-chef]',
  'role[foundation-security]',
  'role[foundation-packages]',
  'role[foundation-monitoring]'
])