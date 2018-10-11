## Mac Setup

Almost all of these commands are meant to be executed within Terminal so these instructions expect a basic understanding of Terminal usage.  You should not need to use [sudo](https://en.wikipedia.org/wiki/Sudo) for any command unless otherwise noted.  If you need sudo for anything else that's an indication that you're doing something wrong.  You may not know what some applications or commands are.  Ask your fellow students or me when we next meet.

- Update OS X via the command line.  Or open up the Mac App Store, and update all.
```bash
$ sudo softwareupdate -ia --verbose
```

- Install Xcode Command Line Tools.  This includes several useful command line tools, mostly C/C++ compilers and make.
```bash
$ xcode-select --install
```

- Install [Homebrew](https://brew.sh).  Read the home page, and these [FAQs](https://docs.brew.sh/FAQ). Homebrew is a [package manager](https://en.wikipedia.org/wiki/Package_manager).  These first become popular with Linux.  This is the best one for a Mac.  Useful for installing/managing command line tools, though for this installation we will also use it for some GUI apps.
```bash
$ /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"   
```

- Install git.  There is already a system-level version git, but it's not usually the latest version and you don't want to update system tools as that could break the system.  Instead, you should install your own local version.
```bash
$ brew install git
```

- Install gcc (for gfortran)
```bash
$ brew install gcc
```

- Install open-mpi
```bash
$ brew install open-mpi
```

- Install wget.  Mainly just to make some  later steps in this installation easier.
```bash
$ brew install wget
```

- Install tools for continuous backup/sync.
```bash
$ brew cask install dropbox
$ brew cask install box-drive
```

- Install text editors.  I primarily use VSCode.  Others prefer Atom.
```bash
$ brew cask install visual-studio-code
$ brew cask install atom
```

- Install communication tools.
```bash
$ brew cask install slack
$ brew cask install zoomus
```

- Install Julia if you are going to program in Julia.  If you need a specific version go to their [downloads page](https://julialang.org/downloads/).
```bash
$ brew cask install julia
```

- Install GitHub Desktop if you like to use a GUI for git (I prefer the command line).
```bash
$ brew cask install github-desktop
```

- AppCleaner does a better job uninstalling applications.
```bash
$ brew cask install appcleaner
```

- Install MacTeX unless you plan to only use Overleaf for writing LaTeX.
```bash
$ brew cask install mactex
```

- Update all the LaTeX packages (will take a while).
```bash
$ sudo /Library/TeX/texbin/tlmgr update --self
$ sudo /Library/TeX/texbin/tlmgr update --all
```

- Some useful Quick Look plugins.  Some description [here](https://github.com/sindresorhus/quick-look-plugins).  Quick Look is when you press spacebar when a file is selected in Finder.
```bash
$ brew cask install qlcolorcode qlstephen qlmarkdown
```

- Change some default OS X settings:
```bash
# Expand save panel by default
$ defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
$ defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# Save to disk (not to iCloud) by default
$ defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Disable smart quotes as they're annoying when typing code
$ defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

# Disable smart dashes as they're annoying when typing code
$ defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# Disable auto-correct
$ defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# Set Dropbox as the default location for new Finder windows
# For other paths, use `PfLo` and `file:///full/path/here/`
$ defaults write com.apple.finder NewWindowTarget -string "PfDe"
$ defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/Dropbox/"

# Finder: show all filename extensions
$ defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# auto hide dock
$ defaults write com.apple.dock autohide -bool true
killall Dock
```


- Create some config files.  First, improve how tab completion and history search works in Terminal.
```bash
$ cat <<EOT >> ~/.inputrc
"\e[A": history-search-backward
"\e[B": history-search-forward
set show-all-if-ambiguous on
set completion-ignore-case on
EOT
```

- Next, create a file that will allow you to build nomenclature automatically when using LaTeX.
```bash
$ cat <<EOT >> ~/.latexmkrc
@cus_dep_list = (@cus_dep_list, "nlo nls 0 makenomenclature");
sub makenomenclature {
   system("makeindex $_[0].nlo -s nomencl.ist -o $_[0].nls"); }
EOT
```

- Create a file called `~/.bash_profile` and add the text below.  This file is run every time you open a terminal window.  The first shows colors when you use `ls` in terminal. In the second I like to set the command `edit` as an alias to open my text editor.  I do this because I've changed text editors over time, but I want to continue use the same command.  For your editor of choice you'll need to also install their command line tools for this to work.  The last removes some extraneous info in the command prompt.
```bash
# colors in ls
alias ls="ls -G"

# alias for edit (choose one)
alias edit="/usr/local/bin/code"
# alias edit="/usr/local/bin/atom"

# simplify command prompt
export PS1="\W$ "
```


- Configure git.  You may need some [additional configuration](http://burnedpixel.com/blog/setting-up-git-and-github-on-your-mac/#done) for the keychain helper or maybe ssh keys, but in general you shouldn't need to do anything more other than login with your github account the first time.
```bash
$ git config --global user.name "Your Name Here"
$ git config --global user.email your@email.com
```

- Install miniconda if you are going to program in  Python.  Conda is a separate package manager just for Python.  Typically it comes with a bunch of stuff pre-bundled.  The mini version strips it down to the essentials so we can just install what we need.
```bash
$ cd ~/Downloads
$ wget https://repo.continuum.io/miniconda/Miniconda2-latest-MacOSX-x86_64.sh -O miniconda.sh
$ bash miniconda.sh 
$ conda update conda
$ conda install numpy scipy matplotlib swig
```

- Install an optimizer (Snopt).  The sources files are in our github repo: lab-internal.  For Julia the instructions are in our repo [Snopt.jl](https://github.com/byuflowlab/Snopt.jl).  For Python you should use [pyoptsparse](https://github.com/mdolab/pyoptsparse). Follow the same basic procedure.  Before doing the Python install make sure you are referring to the correct version (not the system one).  If you execute `which python` you should see the path you setup with conda, you should NOT see `/usr/bin/python`.  If you've installed python but are getting the wrong one, you may just need to reopen the terminal (or reload your bash_profile: `source ~/.bash_profile`)
```bash
$ cp lab-internal/optimizers/snopt7/src/* pyoptsparse/pyoptsparse/pySNOPT/source/
$ cd pyoptsparse
python setup.py install
```

- If you use Python and need openmdao (note that you use should conda instead of pip whenever possible, but openmdao is not available through conda).  I'd also check `which pip`
```bash
$ pip install openmdao
```

- If you use VSCode, you might want some of these extensions (first for LaTeX, second for Julia).  Note that there are tons of extensions, and they are easy to install from within the app.:
```bash
$ code --install-extension james-yu.latex-workshop
 julialang.language-julia
```

- If you prefer Atom, you can do the same:
```bash
$ apm install latextools uber-juno
```

- If you want Matlab or any Adobe products  (potentially Acrobat and maybe Illustrator) you need to install from <https://software.byu.edu>.

- Microsoft Office you can install from <https://office.byu.edu>


- From the Mac App Store I recommend either Better Snap Tool or Magnet.  They allow you to define keyboard shortcuts to snap your windows left/right/fullscreen (with absurd amounts of customization if you want).  Great for putting two documents side-by-side.  

- I like to use a better theme for Terminal.  Here's one I like.  After downloading, you need to double click and change as default in preferences (might also like to change fonts).
```bash
$ wget https://raw.githubusercontent.com/chriskempson/tomorrow-theme/master/OS%20X%20Terminal/Tomorrow%20Night.terminal
```


