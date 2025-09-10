gen:
	@dart run build_runner build --delete-conflicting-outputs
	@dart run slang

apk: gen
	@flutter build apk --dart-define-from-file=config/config.json