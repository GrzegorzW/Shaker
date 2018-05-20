PROJECT = shaker
PROJECT_DESCRIPTION = Lists the drinks you can create from the ingredients you have
PROJECT_VERSION = 0.1.0

DEPS = cowboy jiffy

dep_cowboy_commit = 2.3.0
dep_jiffy = git https://github.com/davisp/jiffy

DEP_PLUGINS = cowboy

include erlang.mk
