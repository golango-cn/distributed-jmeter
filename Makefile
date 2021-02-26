build:
	docker build -t distributed-jmeter .

slave:
	docker run -it --network=host -e JMETER_RUN_MODEL=slave -e JMETER_REMOTE_HOSTS=10.10.86.214 -e JMETER_SERVER_HOST=10.10.86.214 distributed-jmeter

master:
	docker run -it --network=host -e JMETER_RUN_MODEL=master -e JMETER_REMOTE_HOSTS=10.10.86.101:1099 -e JMETER_SERVER_HOST=10.10.86.214 -w /works -v ${PWD}:/works distributed-jmeter -r -n -t nginx.jmx -l nginx.jtl -e -o ./out
