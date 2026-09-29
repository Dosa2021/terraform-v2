import { mysqlTable, serial, varchar, timestamp } from 'drizzle-orm/mysql-core'
import { z } from '@hono/zod-openapi'

export const users = mysqlTable('users', {
  id: serial('id').primaryKey(),
  name: varchar('name', { length: 255 }).notNull(),
  email: varchar('email', { length: 255 }).notNull().unique(),
  passwordHash: varchar('password_hash', { length: 255 }).notNull(),
  createdAt: timestamp('created_at').defaultNow(),
  updatedAt: timestamp('updated_at').defaultNow(),
})

export const signupSchema = z.object({
  name: z.string().min(1).openapi({ example: 'Taro' }),
  email: z.email().openapi({ example: 'user@example.com' }),
  password: z.string().min(8).openapi({ example: 'password' }),
})
