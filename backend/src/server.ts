import { ApolloServer } from 'apollo-server-cloud-functions'
import { context } from './context';
import { schema } from './schema'

const server = new ApolloServer({ 
  schema,
  context,
  playground: true,
  introspection: true,
})

export const handler = server.createHandler({
  cors: {
    origin: true,
    credentials: true,
  },
})