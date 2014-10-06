
dependencies: dependencies.json
	@packin install --folder $@ --meta $<
	@ln -snf .. $@/write-json

test: dependencies
	@$</jest/bin/jest test

.PHONY: test
