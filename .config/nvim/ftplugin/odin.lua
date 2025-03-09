-- Set the make program to build.bat
-- right now this assumes one exists in the working directory.
-- maybe in the future I make this smarter
vim.cmd 'setlocal makeprg=build.bat'

-- Set the error format patterns for Odin compiler errors
vim.cmd 'setlocal errorformat=%f(%l:%c)\\ %trror:\\ %m,%f(%l:%c)\\ %tarning:\\ %m'

-- Create a custom command to compile Odin files and open the quickfix window only if there are errors
vim.api.nvim_create_user_command('Odin', function(opts)
  -- Get any arguments passed to the command
  local args = opts.args

  -- If arguments were provided, add them to the make command
  if args and args ~= '' then
    vim.cmd('make ' .. args)
  else
    vim.cmd 'make'
  end

  -- Get the number of quickfix entries
  local qf_list = vim.fn.getqflist()

  -- Only open quickfix window if there are errors
  if #qf_list > 0 then
    vim.cmd 'copen'
  else
    vim.notify('Build successful - no errors found', vim.log.levels.INFO)
  end
end, {
  nargs = '*', -- Allow any number of arguments
  complete = function(ArgLead, CmdLine, CursorPos)
    -- Provide completion options for the command
    return { 'release', 'run', 'scratch' }
  end,
})

-- You might also want to add other Odin-specific settings here
vim.cmd 'setlocal commentstring=//\\ %s' -- Set comment style for Odin
vim.cmd 'setlocal tabstop=4' -- Set tab width to 4 spaces
vim.cmd 'setlocal shiftwidth=4' -- Set indent width to 4 spaces
vim.cmd 'setlocal expandtab' -- Use spaces instead of tabs
vim.cmd 'set softtabstop=-1' -- Use value of shiftwidth
vim.cmd 'set smarttab' -- Always use shiftwidth

-- possible way to fix the indent issue with annotations
-- " Don't change indentation for annotation lines
--  if prev_line =~ '^\s*@(.*)'
--    return indent(a:lnum - 1)
--  endif
