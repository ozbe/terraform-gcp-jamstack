import { objectType } from 'nexus'

export * from './query'

export const Post = objectType({
  name: 'Post',
  definition(t) {
    t.nonNull.int('id')
    t.nonNull.string('title')
    t.nonNull.string('body')
    t.nonNull.boolean('published')
  },
})
