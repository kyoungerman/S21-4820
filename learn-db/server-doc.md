# Server Document

## Command Line

--host-port		List of host:port or :port values for all ports.

Example: :7001 will listen on all IP addresses for this machine on port 7001.

		:7001,:7002 will listen on all IP address on both ports. 

		https://www.2c-why.com:7001 will use TLS and listen on the resolved address for www.2c-why.com at port 7001.

		https://www.2c-why.com will use TLS and listen on the resolved address for www.2c-why.com at the default port of 443.

