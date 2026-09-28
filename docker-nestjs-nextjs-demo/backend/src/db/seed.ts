import 'dotenv/config'
import { faker } from '@faker-js/faker'
import { db } from './index.js'
import { users } from './schema.js'

async function seed() {
  console.log('🌱 ダミーデータの投入を開始します...')

  // 例: 50件のユーザーデータを生成
  const dummyUsers = Array.from({ length: 50 }, () => ({
    name: faker.person.fullName(),
    email: faker.internet.email().toLowerCase(),
    createdAt: faker.date.past()
  }))

  // Drizzle でデータベースへ一括挿入 (Bulk Insert)
  await db.insert(users).values(dummyUsers)

  console.log('✅ 50件のダミーデータを正常に作成しました。')
  process.exit(0)
}

seed().catch((error) => {
  console.error('❌ エラーが発生しました:', error)
  process.exit(1)
})