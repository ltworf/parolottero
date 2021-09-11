.PHONY: all
all: language_data/italian

language_data:
	mkdir language_data

language_data/%: language_data
	utils/lang_init.py `basename $@` $@ $@.wordlist

.PHONY: clean
clean:
	$(RM) -r language_data
