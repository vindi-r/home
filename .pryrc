if defined?(PryDebugger)
  Pry.commands.alias_command 'c', 'continue'
  Pry.commands.alias_command 's', 'step'
  Pry.commands.alias_command 'n', 'next'
  Pry.commands.alias_command 'f', 'finish'
end

if Gem.win_platform?

  # Display utf-8 chars in Windows console.
  existing = `chcp`.scan(/[0-9]+/).first
  system 'chcp', '65001'
  at_exit {system 'chcp', existing}

end

