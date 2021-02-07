import { Post } from '@prisma/client';
import { Context } from '../../../context'

export default function posts(_: any, __: any, ctx: Context): Promise<Post[]> {
  return ctx.db.post.findMany({ where: { published: true }})
}