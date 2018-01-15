#
# Copyright (c) 2012--2017 Richard Mortier <mort@cantab.net>. All Rights
# Reserved.
#
# Permission to use, copy, modify, and distribute this software for any purpose
# with or without fee is hereby granted, provided that the above copyright
# notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH
# REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY
# AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT,
# INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
# LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
# OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
# PERFORMANCE OF THIS SOFTWARE.
#

.PHONY: all
all: site
	@ :

.PHONY: help
help: # list targets
	@egrep "^\S+:" Makefile \
	  | grep -v "^.PHONY" \
	  | awk -F"[[:space:]]*#[[:space:]]*" \
	      '{ if (length($2) != 0) printf("-- %s\n  %s\n", $$1, $$2) }'

PORT  ?= 8080

DOCKER = docker run -ti -v $$(pwd -P):/cwd -w /cwd $$DOCKER_FLAGS
JEKYLL = $(DOCKER) mor1/jekyll
JEKYLLS = $(DOCKER) -p $(PORT):$(PORT) mor1/jekyll

# .PHONY: clean
# clean: # remove build artefacts
#	$(RM) -r _mirage/_build
#	$(MIRAGE) clean || true
#	$(MIRAGE) destroy || true

# .PHONY: distclean
# distclean: | clean # also remove built assets
#	$(RM) -r _site
#	$(RM) -r _coffee/*.js js/*.js $(PAPERS)

.PHONY: site
site: # build site
	$(JEKYLL) build --trace

.PHONY: test
test: # serve site for testing
	$(JEKYLLS) serve -H 0.0.0.0 -P $(PORT) --trace --watch --future

.PHONY: drafts
drafts: # serve site, including draft posts
	$(JEKYLLS) serve -H 0.0.0.0 -P $(PORT) --trace --watch --future --drafts

.PHONY: clean
clean: # remove built site
	$(RM) -r _site
