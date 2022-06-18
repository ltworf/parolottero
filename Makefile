# parolottero
# Copyright (C) 2021-2022 Salvo "LtWorf" Tomaselli
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
#
# author Salvo "LtWorf" Tomaselli <tiposchi@tiscali.it>

.PHONY: clean
clean:

.PHONY: dist
dist:
	rm -rf /tmp/parolottero/
	rm -rf /tmp/parolottero-*
	mkdir /tmp/parolottero/
	cp -R * /tmp/parolottero/
	( \
		cd /tmp; \
		tar --exclude '*.user' -zcf parolottero.tar.gz \
			parolottero/src \
			parolottero/Makefile \
			parolottero/LICENSE \
			parolottero/README.md \
			parolottero/CHANGELOG \
			parolottero/CODE_OF_CONDUCT.md \
	)
	mv /tmp/parolottero.tar.gz ./parolottero_`head -1 CHANGELOG`.orig.tar.gz
	gpg --sign --armor --detach-sign ./parolottero_`head -1 CHANGELOG`.orig.tar.gz

.PHONY: deb-pkg
deb-pkg: dist
	$(RM) -r /tmp/parolottero*
	mv parolottero*orig* /tmp
	cd /tmp; tar -xf parolottero*orig*.gz
	cp -r debian /tmp/parolottero/
	cd /tmp/parolottero; dpkg-buildpackage --changes-option=-S
	mkdir -p deb-pkg
	mv /tmp/parolottero*.* deb-pkg
	lintian --pedantic -E --color auto -i -I deb-pkg/*changes deb-pkg/*deb

translations:
	cd src; lupdate -verbose parolottero.pro
