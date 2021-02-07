// FIXME - deprecate ApolloServer -there are two ApolloServers to support dev run and lambda run
import { ApolloServer } from 'apollo-server'
import { ApolloServer as ApolloServerLambda } from 'apollo-server-lambda'
import { context } from './context';
import { schema } from './schema'

export const server = new ApolloServer({ 
  schema,
  context,
  playground: {
    endpoint: "/dev/graphql"
  }
})

const lambdaServer = new ApolloServerLambda({ 
  schema,
  context,
  playground: {
    endpoint: "/dev/graphql"
  }
})

// https://www.apollographql.com/docs/apollo-server/deployment/lambda/
export const handler = lambdaServer.createHandler({
  cors: {
    origin: true,
    credentials: true,
  },
})