# nexus+

[Nexus](https://nexusjs.org/) example with:
* [Prisma](https://www.prisma.io/)
* [Docker Compose](https://docs.docker.com/compose/)
* [Serverless](https://www.serverless.com/)
* [VS Remote - Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)

## Development

### Start dependencies

```
$ docker-compose up
```

### One-time setup

#### .env

Create an `.env` file at the project root
```
# .env
DATABASE_URL="postgresql://postgres:postgres@localhost:5432/myapp"
```

#### Prisma

```
# Init
$ npx prisma init

# Migrate
$ npx prisma migrate dev --preview-feature
```

### Run development

#### Via VS Code Remote - Container

Requires [Remote - Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)

```
$ code .
# `Open in Remote Window` by pressing the button in the bottom left of VS Code
```

#### Via Command-line

```
$ npm run dev
```