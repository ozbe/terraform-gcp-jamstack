import { extendType } from 'nexus'
import { Post } from '../index'

import drafts from './drafts'
import posts from './posts'

export const PostQuery = extendType({
  type: 'Query',
  definition(t) {
    t.nonNull.list.field('drafts', {
      type: Post,
      resolve: drafts
    })
    t.list.field('posts', {
      type: Post,
      resolve: posts
    })
  },
})