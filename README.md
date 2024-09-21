UPDATE: You've since moved on to using Stow. Which basically means most, if not all, of what's in
this readme no longer applies to your dotfiles. Go through these steps only if you want to revert
back to a bare git repo setup where you manage everything "through git". One of the main reasons you
moved over to Stow is that it allows you to save everything in a single directory location, which
makes sending/updating through git MUCH less prone to errors and weird overwrite situations.

Still want to go ahead with this route? Cool, read away!  But if you'd rather set things up with
stow, refer to the initial installs up at the top of your reference file

NOTE! Before you do this stuff, be sure you first have curl installed
($ sudo apt-get install curl). This is so that, when you do clone your .dotfiles
repo, your .vimrc will have what it needs to run its built-in curl commands

# PART 1 - How to pull from this repo from a fresh setup

First, you'll need to create an RSA key for your computer

```
$ cd ~/.ssh # create this directory if it does not exist
$ ssh-keygen
```

Then link that RSA key to your bitbucket repo by adding it to your profile
Copy and paste the output from the below command...

```
$ cat ~/.ssh/<rsa name>.pub
```

Now that you have your RSA keys all ready to go, there's a good chance that your system is not yet

associated with a particular RSA key. To remedy...

```
$ ssh-add -l # displays your active RSA key for the system, if no identities...
$ ssh-add ~/.ssh/<private_RSA_key_name>
# example ssh-add ~/.ssh/laptop
```

Confirm with `ssh-add -l`

Check to make sure you have access to bitbucket with

```
$ ssh -T git@bitbucket.org # verifies your active config and username
```

At this point you should be ready to make your pull from the repo

```
git clone --bare git@bitbucket.org:<account_username>/dotfiles.git $HOME/.dotfiles
```

Now setup a custom "git" tag, this will let you use dotfiles add, dotfiles pull, etc

```
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
dotfiles config --local status.showUntrackedFiles no
$ dotfiles checkout # This may warn that your .bashrc file would be overwritten by checkout,
#  simply rename this file then rerun the command
# Since your dotfiles repo comes with a bunch of font files, get'em integrated to the system with:
$ fc-cache -f
# And there you go! You should be all set!
# Chances are, now you'll need to get your vim up and running, so open your .vimrc
```

# PART 2 - How to use

Since your home directory has so many files in it, you should NOT use add -A

Instead, you need to specify each file separately each time, like this...

```
dotfiles status
dotfiles add .vimrc
dotfiles commit -m "Add .vimrc"
dotfiles add .bashrc
dotfiles commit -m "Add .bashrc"
dotfiles push
```

You may need to run this'n to get the remote setup properly
```
dotfiles remote add origin git@bitbucket.org:spectator6/dotfiles.git
```

# EXTRAS - How to intially build something like this

You can use any directory/alias you want in place of <.dotfiles>
```
$ git init --bare $HOME/.dotfiles

$ alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
$ dotfiles config --local status.showUntrackedFiles no

# Add to .bashrc, this will already be part of the .bashrc file if you pulled from the repo
$ echo "alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'">>$HOME/.bashrc

# That alias allows you to interact with your home directory as you would git,
#   but instead of using "git <>" you use "dotfiles <>"
```
