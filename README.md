# tor-reverse

tor-reverse is a Tor network reverse proxy base implemented in Docker. It uses `mkp224o` to generate onion addresses and `nginx` to handle proxy passing.

## Getting Started

### Prerequisites

Make sure you have the following installed on your system:

- Docker
- Docker Compose
- `make` utility

### Usage

To build and start the Docker containers, simply run:

```bash
make
```

### Makefile Targets

The Makefile includes several targets for managing the setup and deployment:

- `setup`: Generate the onion address.
- `deploy`: Deploy the reverse proxy using Docker Compose.
- `info`: Show the generated onion address.
- `destroy`: Clean up and remove the deployment.

#### Example Commands

To generate the onion address:

```bash
make setup
```

To deploy the reverse proxy:

```bash
make deploy
```

To show the onion address:

```bash
make info
```

To clean up the deployment:

```bash
make destroy
```
