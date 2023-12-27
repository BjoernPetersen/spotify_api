.PHONY: gen
gen:
	dart run build_runner build --delete-conflicting-outputs

.PHONY: watch
watch:
	dart run build_runner watch --delete-conflicting-outputs

.PHONY: integration-test
	dart test -P integration -t integration
