EXTRACTDIR=-D lib -D themes/default
POT=themes/default/lib/Lstu/I18N/lstu.pot
XGETTEXT=carton exec local/bin/xgettext.pl
CARTON=carton exec
REAL_LSTU=script/application
LSTU=script/lstu

minify:
	@echo "Minification of fontelico.css"
	@cd ./themes/default/public/css/ && minify fontelico.css
	@echo "Minification of lstu.css"
	@cd ./themes/milligram/public/css/ && minify lstu.css

locales:
	$(XGETTEXT) $(EXTRACTDIR) -o $(POT) 2>/dev/null
	cd ./themes/milligram && make locales

push-locales:
	zanata-cli push

pull-locales:
	zanata-cli pull

podcheck:
	podchecker lib/Lstu/DB/Ban.pm lib/Lstu/DB/Session.pm lib/Lstu/DB/URL.pm

test: podcheck
	$(CARTON) $(REAL_LSTU) test

test-sqlite:
	MOJO_CONFIG=t/sqlite1.conf $(CARTON) $(REAL_LSTU) test
	MOJO_CONFIG=t/sqlite2.conf $(CARTON) $(REAL_LSTU) test

dev: minify
	$(CARTON) morbo $(LSTU) --listen http://0.0.0.0:3000 --watch lib/ --watch script/ --watch themes/ --watch lstu.conf

devlog:
	multitail log/development.log

minion:
	$(CARTON) $(REAL_LSTU) minion worker

installdeps:
	carton install

updatedeps:
	carton update
