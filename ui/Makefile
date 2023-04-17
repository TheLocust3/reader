install:
	yarn install

refresh:
	yarn remove central || echo
	rm -rf node_modules/central/
	rm -rf node_modules/.cache/
	yarn add ../../central/common/react

start:
	PORT=3000 yarn start