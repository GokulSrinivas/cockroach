# Copyright 2015 The Cockroach Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
# implied. See the License for the specific language governing
# permissions and limitations under the License. See the AUTHORS file
# for names of contributors.
#
# Author: Tamir Duberstein (tamird@gmail.com)

REPO_ROOT        := $(realpath ..)
ORG_ROOT         := $(REPO_ROOT)/..
GITHUB_ROOT      := $(ORG_ROOT)/..
BOWER_COMPONENTS := bower_components
NODE_MODULES     := node_modules
TS_ROOT          := ts
STYL_ROOT        := styl
TEST_ROOT        := ts/test

# Ensure we only have one entry in GOPATH
GOPATH := $(GITHUB_ROOT)/../..
#                        ^  ^~ GOPATH
#                        |~ GOPATH/src

GOPATH_BIN := $(GOPATH)/bin

GO_BINDATA := $(GOPATH_BIN)/go-bindata

TYPESCRIPT_TARGET       := build/app.js
TEST_TARGET             := build/test.js
CSS_TARGET              := build/app.css
STYL_OPTIONS            :=
REMOTE_DEPS             := npm.installed bower.installed tsd.installed
INDEX                   := index.html
GOBINDATA_DEPS          := $(TYPESCRIPT_TARGET) $(CSS_TARGET)
GOBINDATA_SOURCES       := $(BOWER_COMPONENTS)/d3/d3.min.js \
                           $(BOWER_COMPONENTS)/lodash/lodash.min.js \
                           $(BOWER_COMPONENTS)/mithril/mithril.js \
                           $(BOWER_COMPONENTS)/mithril/mithril.min.js \
                           $(BOWER_COMPONENTS)/mithril/mithril.min.js.map \
                           $(BOWER_COMPONENTS)/nvd3/build/nv.d3.min.css \
                           $(BOWER_COMPONENTS)/nvd3/build/nv.d3.min.js
GOBINDATA_DEBUG_SOURCES := $(BOWER_COMPONENTS)/d3/d3.js \
                           $(BOWER_COMPONENTS)/lodash/lodash.js \
                           $(BOWER_COMPONENTS)/mithril/mithril.js \
                           $(BOWER_COMPONENTS)/nvd3/build/nv.d3.css \
                           $(BOWER_COMPONENTS)/nvd3/build/nv.d3.js
GOBINDATA_TARGET        := ./embedded.go
GOBINDATA_DEBUG_TARGET  := ./embedded_debug.go

.PHONY:
all: STYL_OPTIONS += --compress
all: $(GOBINDATA_TARGET) $(TEST_TARGET)
	rm -f $(GOBINDATA_DEBUG_TARGET)

.PHONY:
debug: $(GOBINDATA_DEBUG_TARGET) $(TEST_TARGET)
	rm -f $(GOBINDATA_TARGET)

bower.installed: bower.json npm.installed
	$(NODE_MODULES)/.bin/bower install --config.interactive=false --allow-root
	touch $@

npm.installed: npm-shrinkwrap.json
	npm install
	touch $@

tsd.installed: tsd.json npm.installed
	$(NODE_MODULES)/.bin/tsd install
	touch $@

$(TYPESCRIPT_TARGET): $(shell find $(TS_ROOT)) $(REMOTE_DEPS)
	$(NODE_MODULES)/.bin/tsc -p $(TS_ROOT)
	$(NODE_MODULES)/.bin/tslint -c $(TS_ROOT)/tslint.json $(shell find $(TS_ROOT) -name '*.ts' -not -path '*external*')

$(TEST_TARGET): $(shell find $(TS_ROOT)) $(REMOTE_DEPS)
	$(NODE_MODULES)/.bin/tsc -p $(TEST_ROOT)

$(CSS_TARGET): $(shell find $(STYL_ROOT)) npm.installed bower.installed
	$(NODE_MODULES)/.bin/stylus $(STYL_OPTIONS) $(STYL_ROOT)/app.styl --out build/

$(GOBINDATA_TARGET): $(GOBINDATA_DEPS) bower.installed release/$(INDEX)
	cp release/$(INDEX) $(INDEX)
	$(GO_BINDATA) -nometadata -pkg ui -o $@ $(GOBINDATA_DEPS) $(INDEX) $(GOBINDATA_SOURCES)
	gofmt -s -w $@
	goimports -w $@

$(GOBINDATA_DEBUG_TARGET): $(GOBINDATA_DEPS) bower.installed debug/$(INDEX)
	cp debug/$(INDEX) $(INDEX)
	$(GO_BINDATA) -nometadata -pkg ui -o $@ -debug $(GOBINDATA_DEPS) $(INDEX) $(GOBINDATA_DEBUG_SOURCES)
