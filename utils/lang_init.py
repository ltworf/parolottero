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

from math import log
from typing import NamedTuple, Iterable
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


def scan_language(language: Language) -> set[str]:
    '''
    Load a language, returns a set of playable words
    '''
    words = set()
    with open(language.wordlist, 'rt') as f:
        for word in f.readlines():
            word = word.strip().lower()

            for find, replace in language.substitutions:
                word = word.replace(find, replace)

            if set(word).difference(language.letters):
                # unknown symbols in the word, skipping
                continue

            words.add(word)
    return words


def print_letterlist(ll: Iterable[tuple[str, int]], title: str):
    '''
    Pretty print a letter list
    '''
    print(title)
    print('=' * len(title))

    for letter, count in ll:
        print(f'{letter}: {count}')
    print()


def letter_frequency(words: Iterable[str]) -> list[tuple[str, int]]:
    '''
    Calculates the frequency of the letters in the
    given set of words
    '''
    frequency = {}

    for word in words:
        for letter in word:
            frequency[letter] = frequency.get(letter, 0) + 1

    freqs = [(k, v) for k,v in frequency.items()]
    freqs.sort(key=lambda x: x[1])
    return freqs


def letter_score(freqs: list[str]) -> list[tuple[str, int]]:
    '''
    Assigns scores for letters.

    More common letters are worth less points.

    Score is done on a log scale.
    '''
    score = 1.1
    r = []

    while len(freqs):
        letter = freqs.pop()
        points = 2 + score
        r.append((letter, round(log(points))))
        score *= 2
    return r
