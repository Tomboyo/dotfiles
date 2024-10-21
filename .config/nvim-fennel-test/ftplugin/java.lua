-- TODO: I think this can be written in fnl and moved to an autocommand.
local config = {
    cmd = {(os.getenv("JDTLS_HOME") .. '/bin/jdtls')},
    root_dir = vim.fs.dirname(vim.fs.find({'gradlew', '.git', 'mvnw'}, { upward = true })[1]),
}
require('jdtls').start_or_attach(config)
