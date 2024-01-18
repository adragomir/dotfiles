local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { '/Users/adragomi/temp/source/jai/Jails2/bin/jails' },
    filetypes = { 'jai' },
    root_dir = util.root_pattern('jails.json'),
    single_file_support = true,
  }
}
