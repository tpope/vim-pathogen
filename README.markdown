pathogen.vim
============

Manage your `'runtimepath'` with ease.  In practical terms, pathogen.vim
makes it super easy to install plugins and runtime files in their own
private directories.

Installation
------------

Install to `~/.vim/autoload/pathogen.vim`.  Or copy and paste:

    mkdir -p ~/.vim/autoload ~/.vim/bundle; \
    curl -so ~/.vim/autoload/pathogen.vim \
        https://raw.github.com/tpope/vim-pathogen/HEAD/autoload/pathogen.vim

If you don't have `curl`, use `wget -O -` instead.

By the way, if you're using Windows, change all occurrences of `~/.vim`
to `~\vimfiles`.

Runtime Path Manipulation
-------------------------

Add this to your vimrc:

    call pathogen#infect()

If you're brand new to Vim and lacking a vimrc, `vim ~/.vimrc` and paste
in the following super-minimal example:

    call pathogen#infect()
    syntax on
    filetype plugin indent on

Now any plugins you wish to install can be extracted to a subdirectory
under `~/.vim/bundle`, and they will be added to the `'runtimepath'`.
Observe:

    cd ~/.vim/bundle
    git clone git://github.com/tpope/vim-fugitive.git

Now [fugitive.vim](https://github.com/tpope/vim-fugitive) is installed.
If you really want to get crazy, you could set it up as a submodule in
whatever repository you keep your dot files in.  I don't like to get
crazy.

If you don't like the directory name `bundle`, you can pass a different
name as an argument:

    call pathogen#infect('stuff')

You can also pass an entire path instead.  I keep the plugins I maintain
under `~/src`, and this is how I add them:

    call pathogen#infect('~/src/vim/bundle')

Normally to generate documentation, Vim expects you to run `:helptags`
on each directory with documentation (e.g., `:helptags ~/.vim/doc`).
Provided with pathogen.vim is a `:Helptags` command that does this on
every directory in your `'runtimepath'`.  If you really want to get
crazy, you could even invoke `Helptags` in your vimrc.  I don't like to
get crazy.

Finally, pathogen.vim has a rich API that can manipulate `'runtimepath'`
and other comma-delimited path options in ways most people will never
need to do.  If you're one of those edge cases, look at the source.
It's well documented.

Runtime File Editing
--------------------

As a guy who writes a lot of Vim script, I edit a lot of runtime files.
For example, when editing PDF files like I do every day, I might notice
something weird in the syntax highlighting and want to have a look:

    :sp $VIMRUNTIME/syntax/pdf.vim

Even the best case scenario with tab complete is painful:

    :sp $VIMR<Tab>/synt<Tab>/pd<Tab>

The picture is even bleaker if the file in question sits in a
bundle.  Enter the V family of commands.  The V stands for Vimruntime
(work with me here).

    :Vsp s/pd<Tab>

As you can see, not only does it eliminate the need to qualify the
runtime path being targeted, the tab completion is friendlier, allowing
you to expand multiple components at once.  Here's me editing
pathogen.vim itself:

    :Ve a/pat<Tab>

In the event of duplicate files, you can give a count to disambiguate.
Here's the full list of commands:

* `:Vedit`
* `:Vsplit`
* `:Vvsplit`
* `:Vtabedit`
* `:Vpedit`
* `:Vread`

All but `:Vedit` automatically `:lcd` to the target's runtime path.  To
suppress that behavior, use a `!`, and to `:lcd` with `:Vedit`, use
`:Vopen` instead.

FAQ
---

> Can I put pathogen.vim in a submodule like all my other plugins?

Sure, stick it under `~/.vim/bundle`, and prepend the following to your
vimrc:

    runtime bundle/vim-pathogen/autoload/pathogen.vim

Or if your bundles are somewhere other than `~/.vim` (say, `~/src/vim`):

    source ~/src/vim/bundle/vim-pathogen/autoload/pathogen.vim

> Will you accept these 14 pull requests adding a `.gitignore` for
> `tags` so I don't see untracked changes in my dot files repository?

No, but I'll teach you how to ignore `tags` globally:

    git config --global core.excludesfile '~/.cvsignore'
    echo tags >> ~/.cvsignore

While any filename will work, I've chosen to follow the ancient
tradition of `.cvsignore` because utilities like rsync use it, too.
Clever, huh?

> What about Vimballs?

If you really must use one:

    :e name.vba
    :!mkdir ~/.vim/bundle/name
    :UseVimball ~/.vim/bundle/name

Contributing
------------

If your [commit message sucks](http://stopwritingramblingcommitmessages.com/),
I'm not going to accept your pull request.  I've explained very politely
dozens of times that
[my general guidelines](http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html)
are absolute rules on my own repositories, so I may lack the energy to
explain it to you yet another time.  And please, if I ask you to change
something, `git commit --amend`.

Beyond that, don't be shy about asking before patching.  What takes you
hours might take me minutes simply because I have both domain knowledge
and a perverse knowledge of Vim script so vast that many would consider
it a symptom of mental illness.  On the flip side, some ideas I'll
reject no matter how good the implementation is.  "Send a patch" is an
edge case answer in my book.

Self-Promotion
--------------

Like pathogen.vim?  Follow the repository on
[GitHub](https://github.com/tpope/vim-pathogen) and vote for it on
[vim.org](http://www.vim.org/scripts/script.php?script_id=2332).  And if
you're feeling especially charitable, follow [tpope](http://tpo.pe/) on
[Twitter](http://twitter.com/tpope) and
[GitHub](https://github.com/tpope).

License
-------

Copyright (c) Tim Pope.  Distributed under the same terms as Vim itself.
See `:help license`.
