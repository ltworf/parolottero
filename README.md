Parolottero
===========

Interactive game inspired by Passaparola (which I later learnt was inspired by Boggle).


Game modes
----------

You can either challenge yourself or other people.

To play against other people you will all need a device and will need to set the seed and timer to the same value, in order to obtain the same board.


Playing
-------

[Gameplay video](https://www.youtube.com/watch?v=NEwD4Rn_nPQ)


Installing
----------

The preferred mode is to install the .deb files.

There is one which contains the game code and data packages which contain the languages.


Building
--------

Refer to debian/control for the list of build-time and run-time dependencies.

You must do

```
mkdir build
cd build
qmake ../src
make -j
```

Game files
----------

See here: https://github.com/ltworf/parolottero-languages


Contributing
------------

Contributions are welcome both via git send mail to tiposchi@tiscali.it or github pull requests.
