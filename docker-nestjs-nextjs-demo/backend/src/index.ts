import { serve } from '@hono/node-server'
import { Hono } from 'hono'
import { db } from './db/index.js'
import { users } from './db/schema.js'

const app = new Hono()

// app.get('/', (c) => c.text('Hello World! hoge'))
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


const port = Number(process.env.PORT ?? 8000)

serve({ fetch: app.fetch, port }, (info) => {
  console.log(`Listening on http://localhost:${info.port}`)
})
