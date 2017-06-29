# bash

This repository holds example bash shell 

File names are prepended with the appropriate OS type

Files are evolving to be OS-agnostic.  Key to this is the $my_OS value that is set using uname function.

# mac.bash_aliases
  Contains a wide variety of aliases to make things easier and to deal with occaisional typos
# mac.bash_functions
  Contains a variety of functions for various complex behaviors
# mac.bash_prompt
  Contains the definitions of variables for 
      color escape codes
      connection type
      user type
      processor/load values
      prompt PS1 definitions
# mac.bashrc
  Contains bash option and environmental settings
# mac.gitconfig
  Contains global git configuration details and aliases
# mac.gitignore_global
  Contains a list of file types and directories to never be added to a git repository
# mac.profile
  Contaains calls to execute the contents of:
      .bash_aliases,
      .bash_functions,
      .bash_prompt
  and sets a few universal environment variables
# mac.vimrc
    This is the vim initial configuration options to get it to always do syntax checking, show linenumbers, etc.
