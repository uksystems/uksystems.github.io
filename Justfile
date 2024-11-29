_default:
    @just --list

port := "8080"
docker := "docker run -ti -v $(pwd -P):/cwd -w /cwd ${DOCKER_FLAGS:-}"
jekyll := docker + " -p " + port + ":" + port + " mor1/jekyll"

# build site
build:
  {{jekyll}} build --trace

# serve site for testing
test:
	{{jekyll}} serve -H 0.0.0.0 -P {{port}} --trace --watch --future

# serve site, including draft posts
drafts: 
	{{jekyll}} serve -H 0.0.0.0 -P {{port}} --trace --watch --future --drafts

# remove built site
clean: 
	rm -rf _site
