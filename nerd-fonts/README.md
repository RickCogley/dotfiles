# Nerd Font Usage

You need to install and specify a font that has been patched with a "[Nerd Font](https://github.com/ryanoasis/nerd-fonts)", to be able to display icons in your vim or neovim, or tmux status line. In the case of this setup, I'm using [vim-devicons](https://github.com/ryanoasis/vim-devicons) which put icons next to file names in NerdTree in vim/nvim. 

That project has plenty of already-patched fonts that you can simply download, install in your OS in the normal way, and then specify in your ``.vimrc``. I'm using [Pragmata Pro](), which is a commercial font, and have encrypted a zip of my patched version, for my own convenience. It's trivial to patch it yourself, though, if you own it. Just download the rather-large Nerd Fonts repo, and use the font-patcher Python script from within the cloned repo.

```bash
$ fontforge -script font-patcher-py3 PragmataProR_0822.ttf --careful --out patched-fonts
```

I did the ``gpg`` encryption like this: 

```bash
$ gpg --encrypt --recipient 1234ABCD PragmataProR_patched.zip
```

... where 1234ABCD is my ``gpg`` key's ID. Then when I clone it to a new system, I can decrypt like this: 

```bash
$ gpg --output PragmataProR_patched.zip --decrypt PragmataProR_patched.zip.gpg
```

