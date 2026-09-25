import { serve } from '@hono/node-server'
import { Hono } from 'hono'

const app = new Hono()

app.get('/', (c) => c.text('Hello World!4'))

const port = Number(process.env.PORT ?? 8000)

serve({ fetch: app.fetch, port }, (info) => {
  console.log(`Listening on http://localhost:${info.port}`)
})
