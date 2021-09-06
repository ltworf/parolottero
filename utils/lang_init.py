# parolottero
# Copyright (C) 2021 Salvo "LtWorf" Tomaselli
#
# parolottero is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
# author Salvo "LtWorf" Tomaselli <tiposchi@tiscali.it>

from typing import NamedTuple, Set, Tuple
from pathlib import Path


class Language(NamedTuple):
    letters: Set[str]
    vowels: Set[str]
    substitutions: Set[Tuple[str, str]]
    excluded: Set[str]
    wordlist: Path

Language(
    letters=set('abcdefghilmnopqrstuvz'),
    vowels=set('aeiou'),
    substitutions={
        ('à', 'a'),
        ('è', 'e'),
        ('é', 'e'),
        ('ì', 'i'),
        ('ò', 'o'),
        ('ù', 'u'),
    },
    excluded=set('\''),
    wordlist=Path('/usr/share/dict/italian'),
)

