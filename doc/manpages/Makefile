# Makefile

MAN = hpc-config-apply.1  hpc-config-push.1

all: $(MAN)

clean:
	rm -f *.1

%.1:%.md; pandoc -s -t man $< -o $@
