import { serve } from '@hono/node-server'
import { Hono } from 'hono'
import { db } from './db/index.js'
import { users } from './db/schema.js'
import { sign } from 'hono/jwt'
import bcrypt from 'bcryptjs'
import { eq } from 'drizzle-orm'

const app = new Hono()

app.get('/', (c) => {
  return c.text('Hello Hono!')
})

app.get('/api/hello', (c) => {
  return c.json({
    ok: true,
    message: 'Hello Hono!',
  })
})

app.get('/users', async (c) => {
  try {
    const allUsers = await db.select().from(users)
    return c.json(allUsers)
  } catch (error) {
    return c.json({ error: 'Database query failed' }, 500)
  }
})

app.post('/signup', async (c) => {
  const { name, email, password } = await c.req.json<{
    name: string
    email: string
    password: string
  }>()
  const [existing] = await db.select().from(users).where(eq(users.email, email))
  if (existing) {
    return c.json({ error: 'このメールアドレスは既に登録されています' }, 409)
  }
  const passwordHash = await bcrypt.hash(password, 10)
  await db.insert(users).values({ name, email, passwordHash })
  return c.json({ ok: true }, 201)
})

const port = Number(process.env.PORT ?? 8000)

serve({ fetch: app.fetch, port }, (info) => {
  console.log(`Listening on http://localhost:${info.port}`)
})
