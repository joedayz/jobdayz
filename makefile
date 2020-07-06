.PHONY: test

gems:
	which gs  || gem install gs
	which dep || gem install dep
	which shotgun || gem install shotgun
	gs init

install:
	dep install

server:
	env $$(cat env.sh) shotgun -o 0.0.0.0

console:
	env $$(cat env.sh) irb -r ./app

test:
	env $$(cat env.sh) cutest test/**/*.rb

push:
	git push

db:
	ruby seed.rb

workers-start:
	env $$(cat env.sh) ost start -d contact_us

workers-stop:
	kill $$(cat workers/contact_us.pid)

